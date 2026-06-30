import 'dart:typed_data';

/// Message types from the Android TV remote protocol.
/// Each type maps to the 2-byte type field in the protocol header.
enum AndroidTvMessageType {
  /// 0x01 — Pairing request
  pairingRequest(0x01),

  /// 0x02 — Pairing request acknowledgment
  pairingRequestAck(0x02),

  /// 0x03 — Pairing secret (PIN code)
  pairingSecret(0x03),

  /// 0x04 — Pairing secret acknowledgment
  pairingSecretAck(0x04),

  /// 0x05 — Option exchange
  option(0x05),

  /// 0x06 — Configuration exchange
  configuration(0x06),

  /// 0x07 — Input key event
  input(0x07),

  /// 0x08 — Input acknowledgment
  inputAck(0x08),

  /// 0x0B — Touch event
  touchEvent(0x0B),

  /// Unknown / unsupported
  unknown(-1);

  const AndroidTvMessageType(this.code);

  final int code;

  static AndroidTvMessageType fromCode(int code) {
    return AndroidTvMessageType.values.firstWhere(
      (t) => t.code == code,
      orElse: () => unknown,
    );
  }
}

/// A parsed or built message for the Android TV remote protocol.
final class AndroidTvMessage {
  const AndroidTvMessage({required this.type, required this.payload});

  /// Message type (2 bytes in header).
  final AndroidTvMessageType type;

  /// Payload bytes (variable length).
  final Uint8List payload;

  @override
  String toString() =>
      'AndroidTvMessage(type: ${type.name}, payload: ${payload.length} bytes)';
}
