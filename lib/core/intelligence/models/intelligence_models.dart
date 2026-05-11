import 'package:truthlens/features/threat_intelligence/domain/entities/scam_report.dart';

enum SignalSeverity { critical, high, medium, low, safe }
enum ThreatCategory { phishing, financial, employment, manipulation, structural, unknown }

class DetectionSignal {
  const DetectionSignal({
    required this.severity,
    required this.category,
    required this.evidence,
    required this.mitigation,
    this.confidence = 1.0,
  });

  final SignalSeverity severity;
  final ThreatCategory category;
  final String evidence;
  final String mitigation;
  final double confidence; // 0.0 to 1.0

  double get penaltyWeight {
    switch (severity) {
      case SignalSeverity.critical: return 35.0;
      case SignalSeverity.high: return 20.0;
      case SignalSeverity.medium: return 10.0;
      case SignalSeverity.low: return 3.0;
      case SignalSeverity.safe: return -5.0; // Positive reinforcement
    }
  }
}

class IntelligenceReport {
  const IntelligenceReport({
    required this.signals,
    required this.baseTrust,
    required this.finalTrustScore,
    required this.isLikelyScam,
    required this.riskLevel,
    required this.explanation,
  });

  final List<DetectionSignal> signals;
  final double baseTrust;
  final int finalTrustScore;
  final bool isLikelyScam;
  final RiskLevel riskLevel;
  final List<String> explanation;
}