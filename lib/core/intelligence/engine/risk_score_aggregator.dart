import 'dart:math' as math;
import '../models/intelligence_models.dart';

class RiskScoreAggregator {
  static const double _decayConstant = 0.025;

  int calculateFinalScore(double baseTrust, List<DetectionSignal> signals) {
    if (signals.isEmpty) return baseTrust.round();
    
    double totalPenalty = 0;
    for (final signal in signals) {
      totalPenalty += (signal.penaltyWeight * signal.confidence);
    }

    if (totalPenalty <= 0) {
      return math.min(100, (baseTrust - totalPenalty)).round();
    }

    // Asymptotic decay: Trust = Base * e^(-k * totalPenalty)
    // Prevents linear subtraction breaking math constraints when multiple signals trigger.
    final calculatedScore = baseTrust * math.exp(-_decayConstant * totalPenalty);
    return calculatedScore.clamp(0, 100).round();
  }
}