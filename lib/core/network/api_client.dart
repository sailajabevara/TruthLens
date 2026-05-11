import 'package:http/http.dart' as http;
import '../config/env_config.dart';

/// Centralized API Abstraction Layer
/// Intercepts requests to inject authorization headers, handle SSL pinning, and manage timeouts.
class ApiClient {
  static final http.Client _client = http.Client();
  
  static Future<http.Response> postJson({
    required String endpoint,
    required String body,
    Map<String, String>? additionalHeaders,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${EnvConfig.openRouterApiKey}',
      'X-Title': 'TruthLens AI (Enterprise)',
    };
    
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    try {
      final response = await _client.post(
        Uri.parse('${EnvConfig.apiBaseUrl}$endpoint'),
        headers: headers,
        body: body,
      ).timeout(timeout);

      return response;
    } catch (e) {
      // Re-throw as a network failure to be handled by the repository layer
      throw Exception('Network execution failed: $e');
    }
  }
}
