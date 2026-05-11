import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error, critical }

class SecurityLogger {
  static void log(LogLevel level, String message, {Object? error, StackTrace? stackTrace, Map<String, dynamic>? metadata}) {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = {
      'timestamp': timestamp,
      'level': level.name.toUpperCase(),
      'message': message,
      if (metadata != null) 'metadata': metadata,
      if (error != null) 'error': error.toString(),
    };

    // In production, this would pipe to a centralized sink like Sentry, Datadog, or an ELK stack.
    if (kDebugMode) {
      print('[${level.name.toUpperCase()}] $timestamp: $message');
      if (metadata != null) print('Metadata: $metadata');
      if (error != null) print('Error: $error');
      // logEntry could be serialized and sent to a backend here
      debugPrint('Payload for Sink: $logEntry');
    }
  }

  static void threat(String type, String evidence, double confidence) {
    log(LogLevel.warning, 'THREAT_DETECTED: $type', metadata: {
      'threat_type': type,
      'evidence_sample': evidence.length > 50 ? evidence.substring(0, 50) : evidence,
      'confidence_interval': confidence,
    });
  }
}
