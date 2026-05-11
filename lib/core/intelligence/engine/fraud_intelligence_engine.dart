import 'package:truthlens/features/threat_intelligence/domain/entities/scam_report.dart';
import 'package:truthlens/core/security/request_sanitizer.dart';
import 'package:truthlens/core/monitoring/security_logger.dart';
import '../models/intelligence_models.dart';
import '../interfaces/analyzer_interface.dart';
import '../modules/url_threat_analyzer.dart';
import '../modules/nlp_scam_analyzer.dart';
import '../modules/entropy_analyzer.dart';
import 'risk_score_aggregator.dart';
import 'explainability_engine.dart';

class FraudIntelligenceEngine {
  // Dependency Injection pattern allows injecting mocked or additional modules for testing/scaling
  FraudIntelligenceEngine({
    List<AnalyzerModule>? analyzers,
    RiskScoreAggregator? aggregator,
    ExplainabilityEngine? explainabilityEngine,
  })  : _analyzers = analyzers ?? [
          UrlThreatAnalyzer(),
          NlpScamAnalyzer(),
          EntropyAnalyzer(),
        ],
        _aggregator = aggregator ?? RiskScoreAggregator(),
        _explainabilityEngine = explainabilityEngine ?? ExplainabilityEngine();

  final List<AnalyzerModule> _analyzers;
  final RiskScoreAggregator _aggregator;
  final ExplainabilityEngine _explainabilityEngine;

  Future<IntelligenceReport> analyze(String input, ScanType type) async {
    // 1. Zero-Trust Sanitization
    final sanitizedInput = RequestSanitizer.sanitize(input);
    
    final baseTrust = _determineBaseTrust(type);
    final allSignals = <DetectionSignal>[];

    SecurityLogger.log(LogLevel.info, 'Initiating analysis for ${type.label}', metadata: {
      'payload_length': sanitizedInput.length,
      'surface_type': type.name,
    });

    // 2. Map-Reduce execution: Execute all analyzers concurrently
    final futures = _analyzers.map((module) => module.analyze(sanitizedInput, type));
    final results = await Future.wait(futures);
    
    for (final signals in results) {
      allSignals.addAll(signals);
    }

    // 3. Deduplicate identical signals to prevent mathematical penalty stacking
    final uniqueSignals = _deduplicateSignals(allSignals);

    // 4. Intelligence Logging for Audit
    for (final signal in uniqueSignals) {
      if (signal.severity == SignalSeverity.critical || signal.severity == SignalSeverity.high) {
        SecurityLogger.threat(signal.category.name, signal.evidence, signal.confidence);
      }
    }

    final finalScore = _aggregator.calculateFinalScore(baseTrust, uniqueSignals);
    final isLikelyScam = finalScore < 45;
    
    RiskLevel riskLevel;
    if (finalScore >= 70) {
      riskLevel = RiskLevel.low;
    } else if (finalScore >= 45) {
      riskLevel = RiskLevel.medium;
    } else {
      riskLevel = RiskLevel.high;
    }

    final explanation = _explainabilityEngine.generateExplanation(uniqueSignals, finalScore);

    return IntelligenceReport(
      signals: uniqueSignals,
      baseTrust: baseTrust,
      finalTrustScore: finalScore,
      isLikelyScam: isLikelyScam,
      riskLevel: riskLevel,
      explanation: explanation,
    );
  }

  double _determineBaseTrust(ScanType type) {
    switch (type) {
      case ScanType.url: return 85.0; // URLs are inherently untrusted surfaces
      case ScanType.message: return 90.0;
      case ScanType.news: return 95.0;
      case ScanType.document: return 100.0; // Documents start trusted, analyzed down
    }
  }

  List<DetectionSignal> _deduplicateSignals(List<DetectionSignal> signals) {
    final seen = <String>{};
    return signals.where((signal) {
      final key = '${signal.category.name}_${signal.evidence}';
      if (seen.contains(key)) return false;
      seen.add(key);
      return true;
    }).toList();
  }
}