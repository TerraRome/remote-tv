class DriverException implements Exception {
  const DriverException(this.message, {this.code, this.cause});

  final String message;
  final String? code;
  final Exception? cause;

  @override
  String toString() => 'DriverException($code): $message';
}

class DriverNotImplementedException extends DriverException {
  const DriverNotImplementedException(String driverId, String method)
    : super(
        '$method not implemented for driver $driverId',
        code: 'NOT_IMPLEMENTED',
      );
}

class DriverConnectionException extends DriverException {
  const DriverConnectionException(String message, {Exception? cause})
    : super(message, code: 'CONNECTION_ERROR', cause: cause);
}

class DriverPairingException extends DriverException {
  const DriverPairingException(String message, {Exception? cause})
    : super(message, code: 'PAIRING_ERROR', cause: cause);
}

class DriverCommandException extends DriverException {
  const DriverCommandException(String message, {Exception? cause})
    : super(message, code: 'COMMAND_ERROR', cause: cause);
}

class DriverDiscoveryException extends DriverException {
  const DriverDiscoveryException(String message, {Exception? cause})
    : super(message, code: 'DISCOVERY_ERROR', cause: cause);
}
