import 'dart:math' as math;
import 'package:truthlens/features/threat_intelligence/domain/entities/scam_report.dart';
import '../models/intelligence_models.dart';
import '../interfaces/analyzer_interface.dart';

class EntropyAnalyzer implements AnalyzerModule {
  @override
  Future<List<DetectionSignal>> analyze(String input, ScanType type) async {
    final signals = <DetectionSignal>[];
    
    if (type != ScanType.url && !input.contains('http')) return signals;

    final normalized = input.toLowerCase().trim();
    final domainMatch = RegExp(r'https?:\/\/([^\/\?]+)').firstMatch(normalized);
    
    if (domainMatch != null) {
      final domain = domainMatch.group(1)!;
      final coreDomain = domain.split('.').first;
      
      if (coreDomain.length > 5) {
        final entropy = _calculateShannonEntropy(coreDomain);
        
        // Typical english words have entropy < 3.5. Highly randomized strings peak > 3.8
        if (entropy > 3.8) {
          signals.add(DetectionSignal(
            severity: SignalSeverity.critical,
            category: ThreatCategory.structural,
            evidence: 'High domain entropy ($entropy). Indicates potential Domain Generation Algorithm (DGA).',
            mitigation: 'Highly randomized domain strings are typically associated with disposable scam infrastructure.',
            confidence: 0.90,
          ));
        }
      }
    }

    return signals;
  }

  double _calculateShannonEntropy(String str) {
    final map = <String, int>{};
    for (int i = 0; i < str.length; i++) {
      final char = str[i];
      map[char] = (map[char] ?? 0) + 1;
    }
    double entropy = 0.0;
    for (final count in map.values) {
      final p = count / str.length;
      entropy -= p * (math.log(p) / math.ln2);
    }
    return double.parse(entropy.toStringAsFixed(2));
  }
}