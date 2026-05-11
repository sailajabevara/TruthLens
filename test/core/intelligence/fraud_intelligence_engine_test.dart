import 'package:flutter_test/flutter_test.dart';
import 'package:truthlens/core/intelligence/engine/fraud_intelligence_engine.dart';
import 'package:truthlens/core/intelligence/models/intelligence_models.dart';
import 'package:truthlens/features/threat_intelligence/domain/entities/scam_report.dart';

void main() {
  group('FraudIntelligenceEngine Enterprise Test Suite', () {
    late FraudIntelligenceEngine engine;

    setUp(() {
      engine = FraudIntelligenceEngine();
    });

    test('Critical Threat Detection: DGA + Phishing Pattern', () async {
      const payload = 'https://zx12pv98qwe-secure-login.click/verify?otp=1234';
      final report = await engine.analyze(payload, ScanType.url);

      expect(report.finalTrustScore, lessThan(40));
      expect(report.isLikelyScam, isTrue);
      expect(report.signals.any((s) => s.severity == SignalSeverity.critical), isTrue);
      // The entropy signal might be critical if entropy > 3.8
      expect(report.explanation.any((e) => e.contains('entropy') || e.contains('Entropy')), isTrue);
    });

    test('Asymptotic Scoring Integrity: Multiple High-Risk Signals', () async {
      // Payload with multiple severe signals
      const payload = 'URGENT: Your account is suspended. Pay 5000 USDT to avoid block. Contact @scammer on Telegram.';
      final report = await engine.analyze(payload, ScanType.message);

      // Verify non-linear scoring (should not hit negative or break)
      expect(report.finalTrustScore, greaterThanOrEqualTo(0));
      expect(report.finalTrustScore, lessThan(50));
    });

    test('XAI Engine: Evidence & Mitigation Mapping', () async {
      const payload = 'URGENT: Send your OTP to verify your internship at professional@gmail.com';
      final report = await engine.analyze(payload, ScanType.document);

      expect(report.explanation, isNotEmpty);
      expect(report.explanation.any((line) => line.contains('🚨') || line.contains('🚩')), isTrue);
      expect(report.explanation.any((line) => line.contains('Mitigation')), isTrue);
    });

    test('Safe Content Validation', () async {
      const payload = 'Hello team, the monthly project update meeting is scheduled for tomorrow at 10 AM in the main conference room.';
      final report = await engine.analyze(payload, ScanType.message);

      expect(report.finalTrustScore, greaterThan(80));
      expect(report.isLikelyScam, isFalse);
      expect(report.signals.every((s) => s.severity == SignalSeverity.safe), isTrue);
    });
  });
}
