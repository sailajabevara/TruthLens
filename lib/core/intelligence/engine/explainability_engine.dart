import '../models/intelligence_models.dart';

class ExplainabilityEngine {
  List<String> generateExplanation(List<DetectionSignal> signals, int finalScore) {
    final lines = <String>[];
    
    if (signals.isEmpty) {
      lines.add('✅ No malicious signatures detected in payload.');
      lines.add('Content appears statistically safe, but maintain standard caution.');
      return lines;
    }

    // Sort signals by severity weight descending
    final sortedSignals = List<DetectionSignal>.from(signals)
      ..sort((a, b) => b.penaltyWeight.compareTo(a.penaltyWeight));

    final criticals = sortedSignals.where((s) => s.severity == SignalSeverity.critical).toList();
    final highs = sortedSignals.where((s) => s.severity == SignalSeverity.high).toList();
    final others = sortedSignals.where((s) => s.severity != SignalSeverity.critical && s.severity != SignalSeverity.high).toList();

    if (criticals.isNotEmpty) {
      lines.add('--- CRITICAL THREATS ---');
      for (final s in criticals) {
        lines.add('🚨 ${s.evidence}');
        lines.add('   Mitigation: ${s.mitigation}');
      }
    }

    if (highs.isNotEmpty) {
      lines.add('--- HIGH RISKS ---');
      for (final s in highs) {
        lines.add('🚩 ${s.evidence}');
        lines.add('   Mitigation: ${s.mitigation}');
      }
    }

    if (others.isNotEmpty) {
      lines.add('--- WARNINGS ---');
      for (final s in others) {
        lines.add('⚠️ ${s.evidence}');
      }
    }

    return lines;
  }
}