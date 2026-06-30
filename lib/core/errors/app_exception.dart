sealed class AppException implements Exception {
  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;

  AppException(this.message, {this.originalError, this.stackTrace});

  @override
  String toString() => message;
}

final class NetworkException extends AppException {
  NetworkException(super.message, {super.originalError, super.stackTrace});
}

final class DiscoveryException extends AppException {
  DiscoveryException(super.message, {super.originalError, super.stackTrace});
}

final class ConnectionException extends AppException {
  ConnectionException(super.message, {super.originalError, super.stackTrace});
}

final class PairingException extends AppException {
  PairingException(super.message, {super.originalError, super.stackTrace});
}

final class CommandException extends AppException {
  CommandException(super.message, {super.originalError, super.stackTrace});
}
