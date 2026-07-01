class DriverException implements Exception {
  const DriverException(this.message, {this.code, this.cause});

  final String message;
  final String? code;
  final Exception? cause;

  @override
  String toString() => 'DriverException($code): $message';
}

class DriverNotImplementedException extends DriverException {
  const DriverNotImplementedException(super.message, {super.cause})
    : super(code: 'NOT_IMPLEMENTED');
}

class DriverConnectionException extends DriverException {
  const DriverConnectionException(super.message, {super.cause})
    : super(code: 'CONNECTION_ERROR');
}

class DriverPairingException extends DriverException {
  const DriverPairingException(super.message, {super.cause})
    : super(code: 'PAIRING_ERROR');
}

class DriverCommandException extends DriverException {
  const DriverCommandException(super.message, {super.cause})
    : super(code: 'COMMAND_ERROR');
}

class DriverDiscoveryException extends DriverException {
  const DriverDiscoveryException(super.message, {super.cause})
    : super(code: 'DISCOVERY_ERROR');
}
