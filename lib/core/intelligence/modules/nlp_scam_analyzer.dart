import 'package:truthlens/features/threat_intelligence/domain/entities/scam_report.dart';
import '../models/intelligence_models.dart';
import '../interfaces/analyzer_interface.dart';

class NlpScamAnalyzer implements AnalyzerModule {
  static final _urgencyRegex = RegExp(r'\b(immediate|urgent|act fast|suspend|block|within 24 hours|final notice)\b', caseSensitive: false);
  static final _credentialRegex = RegExp(r'\b(otp|cvv|pin|password|ssn|aadhar|pan card|account details)\b', caseSensitive: false);
  static final _paymentRegex = RegExp(r'\b(upi|gpay|crypto|bitcoin|usdt|processing fee|advance deposit|transfer now|payee)\b', caseSensitive: false);
  static final _fakeJobRegex = RegExp(r'\b(guaranteed job|daily payout|work from home 2 hours|no interview required|earn lakhs|lottery winner)\b', caseSensitive: false);
  static final _unprofessionalDomain = RegExp(r'\b[A-Za-z0-9._%+-]+@(gmail\.com|yahoo\.com|hotmail\.com)\b', caseSensitive: false);

  @override
  Future<List<DetectionSignal>> analyze(String input, ScanType type) async {
    final signals = <DetectionSignal>[];
    final normalized = input.toLowerCase();

    final hasCredentialRequest = _credentialRegex.hasMatch(normalized);
    final hasPaymentRequest = _paymentRegex.hasMatch(normalized);
    final hasUrgency = _urgencyRegex.hasMatch(normalized);

    if (hasCredentialRequest && hasUrgency) {
      signals.add(const DetectionSignal(
        severity: SignalSeverity.critical,
        category: ThreatCategory.financial,
        evidence: 'Urgent demand coupled with secure credential (OTP/PIN) request.',
        mitigation: 'Never share OTPs under manufactured pressure. Official entities never demand PINs.',
        confidence: 0.98,
      ));
    } else if (hasCredentialRequest) {
      signals.add(const DetectionSignal(
        severity: SignalSeverity.high,
        category: ThreatCategory.financial,
        evidence: 'Request for sensitive credentials detected.',
        mitigation: 'Verify the authenticity of the requester before providing any credentials.',
        confidence: 0.85,
      ));
    }

    if (hasPaymentRequest && (type == ScanType.document || type == ScanType.message)) {
      signals.add(const DetectionSignal(
        severity: SignalSeverity.critical,
        category: ThreatCategory.employment,
        evidence: 'Payment routing or advance fee mentioned in context.',
        mitigation: 'Legitimate opportunities do not require upfront deposits or crypto transfers.',
        confidence: 0.92,
      ));
    }

    if (hasUrgency && type == ScanType.message) {
      signals.add(const DetectionSignal(
        severity: SignalSeverity.medium,
        category: ThreatCategory.manipulation,
        evidence: 'Artificial urgency detected in messaging syntax.',
        mitigation: 'Threat actors use urgency to force cognitive errors. Slow down and independently verify.',
        confidence: 0.78,
      ));
    }

    if (_fakeJobRegex.hasMatch(normalized)) {
      signals.add(const DetectionSignal(
        severity: SignalSeverity.high,
        category: ThreatCategory.employment,
        evidence: 'Unrealistic or guaranteed employment claims detected.',
        mitigation: 'Offers guaranteeing income with zero friction are statistically fraudulent.',
        confidence: 0.88,
      ));
    }

    if (type == ScanType.document && _unprofessionalDomain.hasMatch(normalized)) {
      signals.add(const DetectionSignal(
        severity: SignalSeverity.medium,
        category: ThreatCategory.structural,
        evidence: 'Official document utilizes free-tier email routing.',
        mitigation: 'Legitimate corporate recruitment utilizes verified enterprise domains, not personal email providers.',
        confidence: 0.80,
      ));
    }

    return signals;
  }
}