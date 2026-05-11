class EnvConfig {
  /// Centralized Environment Configuration
  /// In a full production environment, this interfaces with flutter_dotenv or CI/CD injected secrets.
  
  static String get openRouterApiKey {
    const key = String.fromEnvironment('OPENROUTER_API_KEY');
    if (key.isEmpty) {
  throw Exception(
    'OPENROUTER_API_KEY is missing. '
    'Provide it using --dart-define.'
  );
}

return key;
  }

  static String get apiBaseUrl {
    const url = String.fromEnvironment('API_BASE_URL');
    return url.isNotEmpty ? url : 'https://openrouter.ai/api/v1';
  }

  static String get aiModel {
    const model = String.fromEnvironment('AI_MODEL');
    return model.isNotEmpty ? model : 'google/gemini-2.0-flash-001';
  }
}
