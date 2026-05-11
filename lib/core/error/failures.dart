/// Enterprise Error Handling Architecture
/// Prevents raw Exceptions from leaking into the presentation layer.
abstract class Failure {
  final String message;
  final String code;

  const Failure({required this.message, required this.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message: message, code: 'ERR_NETWORK');
}

class IntelligenceEngineFailure extends Failure {
  const IntelligenceEngineFailure(String message) : super(message: message, code: 'ERR_HEURISTIC_ENGINE');
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(String message) : super(message: message, code: 'ERR_AUTH');
}

class RateLimitFailure extends Failure {
  const RateLimitFailure(String message) : super(message: message, code: 'ERR_RATE_LIMIT');
}
