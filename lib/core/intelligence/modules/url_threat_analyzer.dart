import 'package:truthlens/features/threat_intelligence/domain/entities/scam_report.dart';
import '../models/intelligence_models.dart';
import '../interfaces/analyzer_interface.dart';

class UrlThreatAnalyzer implements AnalyzerModule {
  static final _ipRegex = RegExp(r'https?:\/\/\d{1,3}(\.\d{1,3}){3}');
  static final _shortenerRegex = RegExp(r'(bit\.ly|tinyurl|t\.ly|rb\.gy|is\.gd|goo\.gl|ow\.ly|bit\.do|lnkd\.in)');
  static final _unsafeTldRegex = RegExp(r'\.(xyz|top|click|live|shop|token|buzz|cc|tk|ml|ga|cf|gq)(\/|$)');
  static final _httpRegex = RegExp(r'^http:\/\/');
  static final _typoSquattingRegex = RegExp(r'(faceb0ok|goog1e|paypa1|amz|amazn|flipkrt)');

  @override
  Future<List<DetectionSignal>> analyze(String input, ScanType type) async {
    final signals = <DetectionSignal>[];
    if (type != ScanType.url && !input.toLowerCase().contains('http')) return signals;

    final normalized = input.toLowerCase().trim();

    if (_ipRegex.hasMatch(normalized)) {
      signals.add(const DetectionSignal(
        severity: SignalSeverity.critical,
        category: ThreatCategory.structural,
        evidence: 'Direct IP address navigation detected bypassing DNS resolution.',
        mitigation: 'Legitimate corporate services use domains, not raw IPs. Do not proceed.',
        confidence: 0.95,
      ));
    }

    if (_httpRegex.hasMatch(normalized)) {
      signals.add(const DetectionSignal(
        severity: SignalSeverity.high,
        category: ThreatCategory.structural,
        evidence: 'Insecure HTTP protocol in use.',
        mitigation: 'Data sent to this endpoint is unencrypted and vulnerable to interception.',
        confidence: 0.90,
      ));
    }

    if (_shortenerRegex.hasMatch(normalized)) {
      signals.add(const DetectionSignal(
        severity: SignalSeverity.medium,
        category: ThreatCategory.phishing,
        evidence: 'URL shortener obscures the final routing destination.',
        mitigation: 'Verify the sender identity before clicking shortened links.',
        confidence: 0.85,
      ));
    }

    if (_unsafeTldRegex.hasMatch(normalized)) {
      signals.add(const DetectionSignal(
        severity: SignalSeverity.high,
        category: ThreatCategory.phishing,
        evidence: 'Suspicious Top-Level Domain (TLD) detected.',
        mitigation: 'These specific TLDs are statistically overrepresented in bulk scam infrastructure.',
        confidence: 0.88,
      ));
    }
    
    if (_typoSquattingRegex.hasMatch(normalized)) {
      signals.add(const DetectionSignal(
        severity: SignalSeverity.critical,
        category: ThreatCategory.phishing,
        evidence: 'Typo-squatting or brand impersonation detected in URL.',
        mitigation: 'The URL attempts to mimic a well-known brand to deceive users.',
        confidence: 0.98,
      ));
    }

    return signals;
  }
}