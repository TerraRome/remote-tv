import 'dart:typed_data';

enum CastPayloadType { string, binary }

final class CastMessage {
  const CastMessage({
    this.protocolVersion = 0,
    required this.sourceId,
    required this.destinationId,
    required this.namespace,
    this.payloadType = CastPayloadType.string,
    this.payloadUtf8,
    this.payloadBinary,
  });

  final int protocolVersion;
  final String sourceId;
  final String destinationId;
  final String namespace;
  final CastPayloadType payloadType;
  final String? payloadUtf8;
  final Uint8List? payloadBinary;

  @override
  String toString() =>
      'CastMessage(ns: $namespace, src: $sourceId, dst: $destinationId, '
      'payload: ${payloadUtf8 ?? payloadBinary?.length})';
}

/// Cast v2 message codec.
///
/// Wire format:
///   [4 bytes: big-endian payload length][CastMessage protobuf]
///
/// CastMessage protobuf fields:
///   1: protocol_version (varint)
///   2: source_id         (string)
///   3: destination_id    (string)
///   4: namespace         (string)
///   5: payload_type      (varint: 0=STRING, 1=BINARY)
///   6: payload_utf8      (string, optional)
///   7: payload_binary    (bytes, optional)
final class CastMessageCodec {
  static void _encodeVarint(int value, WriteBuffer buf) {
    while (value > 0x7f) {
      buf.addByte((value & 0x7f) | 0x80);
      value >>= 7;
    }
    buf.addByte(value & 0x7f);
  }

  static int _decodeVarint(Uint8List data, int offset, out) {
    int result = 0;
    int shift = 0;
    while (true) {
      final byte = data[offset];
      offset++;
      result |= (byte & 0x7f) << shift;
      if ((byte & 0x80) == 0) break;
      shift += 7;
    }
    out[0] = offset;
    return result;
  }

  static void _encodeString(int field, String value, WriteBuffer buf) {
    if (value.isEmpty) return;
    final bytes = value.codeUnits;
    _encodeVarint((field << 3) | 2, buf);
    _encodeVarint(bytes.length, buf);
    for (final b in bytes) {
      buf.addByte(b);
    }
  }

  /// Encode a CastMessage to framed bytes (4-byte length + protobuf).
  static Uint8List encode(CastMessage msg) {
    final buf = WriteBuffer();

    // field 1: protocol_version
    _encodeVarint(0x08, buf);
    _encodeVarint(msg.protocolVersion, buf);

    // field 2: source_id
    _encodeString(2, msg.sourceId, buf);

    // field 3: destination_id
    _encodeString(3, msg.destinationId, buf);

    // field 4: namespace
    _encodeString(4, msg.namespace, buf);

    // field 5: payload_type
    _encodeVarint(0x28, buf);
    _encodeVarint(msg.payloadType == CastPayloadType.binary ? 1 : 0, buf);

    // field 6: payload_utf8
    if (msg.payloadUtf8 != null && msg.payloadUtf8!.isNotEmpty) {
      _encodeString(6, msg.payloadUtf8!, buf);
    }

    // field 7: payload_binary
    if (msg.payloadBinary != null && msg.payloadBinary!.isNotEmpty) {
      _encodeVarint(0x3a, buf);
      _encodeVarint(msg.payloadBinary!.length, buf);
      for (final b in msg.payloadBinary!) {
        buf.addByte(b);
      }
    }

    final protobuf = buf.toBytes();
    final result = Uint8List(protobuf.length + 4);
    result.buffer.asByteData().setUint32(0, protobuf.length);
    result.setRange(4, 4 + protobuf.length, protobuf);
    return result;
  }

  /// Try to decode a complete CastMessage from [data].
  /// Returns null if not enough data.
  /// Throws FormatException on malformed data.
  static CastMessage? tryDecode(Uint8List data) {
    if (data.length < 4) return null;
    final payloadLen = data.buffer.asByteData().getUint32(0);
    if (payloadLen == 0) return null;
    if (data.length < 4 + payloadLen) return null;

    final pb = data.sublist(4, 4 + payloadLen);
    return _decodeProtobuf(pb);
  }

  static CastMessage _decodeProtobuf(Uint8List data) {
    final out = [0];
    int offset = 0;

    int? protocolVersion;
    String? sourceId;
    String? destinationId;
    String? namespace;
    int? payloadType;
    String? payloadUtf8;
    Uint8List? payloadBinary;

    while (offset < data.length) {
      final tag = _decodeVarint(data, offset, out);
      offset = out[0];
      final fieldNum = tag >> 3;
      final wireType = tag & 0x7;

      switch (wireType) {
        case 0: // varint
          final value = _decodeVarint(data, offset, out);
          offset = out[0];
          if (fieldNum == 1) protocolVersion = value;
          if (fieldNum == 5) payloadType = value;
          break;
        case 2: // length-delimited
          final len = _decodeVarint(data, offset, out);
          offset = out[0];
          final strBytes = data.sublist(offset, offset + len);
          offset += len;
          final str = String.fromCharCodes(strBytes);
          if (fieldNum == 2) sourceId = str;
          if (fieldNum == 3) destinationId = str;
          if (fieldNum == 4) namespace = str;
          if (fieldNum == 6) payloadUtf8 = str;
          if (fieldNum == 7) payloadBinary = strBytes;
          break;
        default:
          throw FormatException('Unknown wire type: $wireType at offset $offset');
      }
    }

    return CastMessage(
      protocolVersion: protocolVersion ?? 0,
      sourceId: sourceId ?? '',
      destinationId: destinationId ?? '',
      namespace: namespace ?? '',
      payloadType: payloadType == 1 ? CastPayloadType.binary : CastPayloadType.string,
      payloadUtf8: payloadUtf8,
      payloadBinary: payloadBinary,
    );
  }
}

/// Simple byte buffer for encoding protobuf.
final class WriteBuffer {
  final List<int> _bytes = [];

  void addByte(int byte) => _bytes.add(byte);

  Uint8List toBytes() => Uint8List.fromList(_bytes);
}
