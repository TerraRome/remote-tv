import 'dart:typed_data';

import 'package:injectable/injectable.dart';

import 'android_tv_message.dart';

/// Message codec for Android TV remote protocol.
///
/// Frame format:
///   [2 bytes: message type][2 bytes: payload length][N bytes: payload]
///
/// All integers are big-endian.
@Singleton()
class AndroidTvMessageCodec {
  /// Maximum payload size (1 MB).
  static const int maxPayloadSize = 1 << 20;

  /// Encode a message to raw bytes.
  Uint8List encode(AndroidTvMessage message) {
    final payload = message.payload;
    final len = payload.length;
    final bytes = Uint8List(4 + len);
    final view = bytes.buffer.asByteData();
    view.setUint16(0, message.type.code);
    view.setUint16(2, len);
    if (len > 0) {
      bytes.setRange(4, 4 + len, payload);
    }
    return bytes;
  }

  /// Try to decode a single complete message from [data].
  /// Returns null if not enough data is available.
  AndroidTvMessage? tryDecode(Uint8List data) {
    if (data.length < 4) return null;
    final view = data.buffer.asByteData();
    final typeCode = view.getUint16(0, Endian.big);
    final payloadLen = view.getUint16(2, Endian.big);
    if (payloadLen > maxPayloadSize) {
      throw FormatException('Payload too large: $payloadLen');
    }
    if (data.length < 4 + payloadLen) return null;
    final type = AndroidTvMessageType.fromCode(typeCode);
    final payload = Uint8List(payloadLen);
    if (payloadLen > 0) {
      payload.setRange(0, payloadLen, data.sublist(4, 4 + payloadLen));
    }
    return AndroidTvMessage(type: type, payload: payload);
  }

  /// Encode an option exchange message.
  /// ponytail: support structured options once protocol is better understood
  AndroidTvMessage encodeOption(Uint8List optionData) {
    return AndroidTvMessage(
      type: AndroidTvMessageType.option,
      payload: optionData,
    );
  }

  /// Encode a configuration exchange message.
  AndroidTvMessage encodeConfiguration(Uint8List configData) {
    return AndroidTvMessage(
      type: AndroidTvMessageType.configuration,
      payload: configData,
    );
  }

  /// Encode a key input event.
  /// [action]: 0 = DOWN, 1 = UP
  AndroidTvMessage encodeInput(int keyCode, int action) {
    final bytes = Uint8List(8);
    final view = bytes.buffer.asByteData();
    view.setUint32(0, keyCode, Endian.big);
    view.setUint32(4, action, Endian.big);
    return AndroidTvMessage(type: AndroidTvMessageType.input, payload: bytes);
  }

  /// Encode a touch event.
  /// [action]: 0 = DOWN, 1 = MOVE, 2 = UP
  AndroidTvMessage encodeTouchEvent(int action, double x, double y) {
    final bytes = Uint8List(12);
    final view = bytes.buffer.asByteData();
    view.setUint32(0, action, Endian.big);
    view.setUint16(4, (x * 1000).round(), Endian.big);
    view.setUint16(6, (y * 1000).round(), Endian.big);
    // ponytail: add pressure/touch pointer tracking
    view.setUint32(8, 0, Endian.big); // reserved
    return AndroidTvMessage(
      type: AndroidTvMessageType.touchEvent,
      payload: bytes,
    );
  }
}
