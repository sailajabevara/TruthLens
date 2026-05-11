import 'package:truthlens/features/threat_intelligence/domain/entities/scam_report.dart';
import '../models/intelligence_models.dart';

abstract class AnalyzerModule {
  /// Asynchronously analyzes the input payload. 
  /// Future is utilized to prevent blocking the main isolate during computationally heavy regex or entropy operations.
  Future<List<DetectionSignal>> analyze(String input, ScanType type);
}