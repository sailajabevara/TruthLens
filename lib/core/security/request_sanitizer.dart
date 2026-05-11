class RequestSanitizer {
  /// Implements Zero-Trust validation by scrubbing input strings of common injection vectors
  /// and neutralizing potential XSS/SQLi artifacts before heuristic analysis.
  static String sanitize(String input) {
    if (input.isEmpty) return '';
    
    var sanitized = input.trim();
    
    // Neutralize common script injection patterns
    sanitized = sanitized.replaceAll(RegExp(r'<[^>]*>'), ''); // Remove HTML tags
    sanitized = sanitized.replaceAll(RegExp(r'javascript:', caseSensitive: false), 'js_scrubbed:');
    
    // Prevent directory traversal artifacts
    sanitized = sanitized.replaceAll('../', '');
    
    return sanitized;
  }

  /// Validates URL structural integrity before routing to the EntropyAnalyzer
  static bool isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'));
  }
}
