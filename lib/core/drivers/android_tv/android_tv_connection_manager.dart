import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../enums/connection_state.dart';
import '../driver_exception.dart';
import '../models/driver_connection.dart';
import '../models/driver_device.dart';
import '../models/driver_pairing_session.dart';
import 'android_keycodes.dart';
import 'protocol/android_tv_protocol_handler.dart';
import 'protocol/cast_message.dart';
import 'protocol/cast_protocol_handler.dart';
import 'transport/android_tv_transport.dart';

/// Manages connections to Android TV and Google Cast devices.
///
/// Auto-detects protocol: port 8009 → Cast v2, port 6466 → ATV remote.
@singleton
class AndroidTvConnectionManager {
  AndroidTvConnectionManager({
    required AndroidTvProtocolHandler protocol,
    required CastProtocolHandler castProtocol,
    required AndroidTvTransport transport,
  }) : _protocol = protocol,
       _castProtocol = castProtocol,
       _transport = transport;

  final AndroidTvProtocolHandler _protocol;
  final CastProtocolHandler _castProtocol;
  final AndroidTvTransport _transport;

  DriverDevice? _connectedDevice;
  DateTime? _connectedAt;
  bool _disposed = false;
  bool _useCast = false;

  final _connectionStateController =
      StreamController<TvConnectionState>.broadcast();

  Stream<TvConnectionState> get connectionState =>
      _connectionStateController.stream;

  bool get isConnected => _transport.isConnected && _connectedDevice != null;

  DriverDevice? get connectedDevice => _connectedDevice;

  /// Connect to a device using the appropriate protocol.
  Future<DriverConnection> connect(
    DriverDevice device, {
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
  }) async {
    debugPrint(
      '[AndroidTvConnMgr] connect() ${device.ipAddress}:${device.port}',
    );
    if (_disposed) throw StateError('Connection manager disposed');

    final port = device.port == 0 ? _defaultPort(device) : device.port;
    _useCast = (port == 8009);

    if (isConnected) {
      if (_connectedDevice?.ipAddress == device.ipAddress &&
          _connectedDevice?.port == port) {
        debugPrint('[AndroidTvConnMgr] already connected to same device, skipping');
        return DriverConnection(
          deviceId: device.id,
          driverId: 'android_tv',
          state: 'connected',
          sessionToken:
              'session_${device.id}_${_connectedAt!.millisecondsSinceEpoch}',
          connectedAt: _connectedAt!,
          lastActivityAt: _connectedAt,
        );
      }
      debugPrint('[AndroidTvConnMgr] connected to different device, disconnecting first');
      await disconnect();
    }

    _connectionStateController.add(TvConnectionState.connecting);

    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      debugPrint('[AndroidTvConnMgr] connect attempt $attempt/$maxRetries proto=${_useCast ? "Cast" : "ATV"}');
      try {
        if (_useCast) {
          await _castProtocol.connect(device.ipAddress, port);
          // Send transport CONNECT and get status
          await _castProtocol.sendConnect();
          await _castProtocol.sendGetStatus();
        } else {
          await _protocol.connect(device.ipAddress, port);
        }
        debugPrint('[AndroidTvConnMgr] protocol connected OK');
        _connectedDevice = device;
        _connectedAt = DateTime.now();
        _connectionStateController.add(TvConnectionState.connected);
        debugPrint('[AndroidTvConnMgr] connected to ${device.ipAddress}:$port');
        return DriverConnection(
          deviceId: device.id,
          driverId: 'android_tv',
          state: 'connected',
          sessionToken:
              'session_${device.id}_${_connectedAt!.millisecondsSinceEpoch}',
          connectedAt: _connectedAt!,
          lastActivityAt: _connectedAt,
        );
      } on DriverException catch (e) {
        debugPrint(
          '[AndroidTvConnMgr] DriverException on attempt $attempt: $e',
        );
        if (attempt >= maxRetries) {
          _connectionStateController.add(TvConnectionState.failed);
          rethrow;
        }
        await Future<void>.delayed(retryDelay);
      } catch (e) {
        debugPrint('[AndroidTvConnMgr] error on attempt $attempt: $e');
        if (attempt >= maxRetries) {
          _connectionStateController.add(TvConnectionState.failed);
          throw DriverConnectionException(
            'Failed to connect to ${device.ipAddress}:$port after ${maxRetries + 1} attempts: $e',
            cause: e is Exception ? e : null,
          );
        }
        await Future<void>.delayed(retryDelay);
      }
    }
    throw DriverConnectionException('Unreachable');
  }

  int _defaultPort(DriverDevice device) {
    // Cast devices found via _googlecast._tcp.local are on port 8009
    return 6466;
  }

  /// Perform pairing.
  /// For Cast devices, pairing is not needed (returns mock session).
  Future<DriverPairingSession> pair(DriverDevice device) async {
    debugPrint('[AndroidTvConnMgr] pair() device=${device.id} useCast=$_useCast');
    if (_disposed) throw StateError('Connection manager disposed');
    if (!isConnected) {
      debugPrint('[AndroidTvConnMgr] pair FAILED - not connected');
      throw DriverConnectionException('Not connected - call connect() first');
    }

    if (_useCast) {
      // Cast protocol doesn't need PIN pairing
      debugPrint('[AndroidTvConnMgr] Cast device - skipping PIN pairing');
      _connectionStateController.add(TvConnectionState.pairing);
      return DriverPairingSession(
        deviceId: device.id,
        sessionId: 'cast_${device.id}_${DateTime.now().millisecondsSinceEpoch}',
        pin: 0,
        isPaired: true,
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 365)),
      );
    }

    _connectionStateController.add(TvConnectionState.connecting);
    debugPrint('[AndroidTvConnMgr] initiating pairing...');
    final ack = await _protocol.initiatePairing(Uint8List.fromList([0x01]));
    debugPrint(
      '[AndroidTvConnMgr] initiate pairing ack received, payload len=${ack.payload.length}',
    );
    final pin = _parsePinFromAck(ack.payload);
    debugPrint('[AndroidTvConnMgr] parsed PIN: $pin');

    _connectionStateController.add(TvConnectionState.pairing);
    return DriverPairingSession(
      deviceId: device.id,
      sessionId: 'pair_${device.id}_${DateTime.now().millisecondsSinceEpoch}',
      pin: pin,
      isPaired: false,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(seconds: 30)),
    );
  }

  /// Submit PIN to complete pairing.
  /// For Cast devices, always succeeds.
  Future<bool> submitPin(DriverPairingSession session, String pin) async {
    debugPrint(
      '[AndroidTvConnMgr] submitPin() sessionId=${session.sessionId} pin=$pin useCast=$_useCast',
    );
    if (_disposed) {
      debugPrint('[AndroidTvConnMgr] submitPin FAILED - disposed');
      throw StateError('Connection manager disposed');
    }
    if (!isConnected) {
      debugPrint('[AndroidTvConnMgr] submitPin FAILED - not connected');
      throw DriverConnectionException('Not connected');
    }

    if (_useCast) {
      debugPrint('[AndroidTvConnMgr] Cast device - pairing always succeeds');
      return true;
    }

    try {
      debugPrint('[AndroidTvConnMgr] sending PIN to TV...');
      await _protocol.sendPin(pin);
      debugPrint('[AndroidTvConnMgr] PIN sent');

      final serverCert = _transport.serverCertificate;
      if (serverCert != null) {
        debugPrint('[AndroidTvConnMgr] setting server certificate');
        _protocol.setServerCertificate(serverCert);
      }

      debugPrint('[AndroidTvConnMgr] exchanging final options...');
      await _protocol.exchangeOptions(
        Uint8List.fromList([0x01]),
        Uint8List.fromList('Remote App (paired)'.codeUnits),
      );
      debugPrint('[AndroidTvConnMgr] final options exchanged OK');

      final paired = _protocol.isPaired;
      debugPrint('[AndroidTvConnMgr] pairing result: isPaired=$paired');
      return paired;
    } catch (e) {
      debugPrint('[AndroidTvConnMgr] submitPin error: $e');
      throw DriverPairingException(
        'Pairing failed: $e',
        cause: e is Exception ? e : null,
      );
    }
  }

  int _parsePinFromAck(Uint8List payload) {
    try {
      final pinStr = String.fromCharCodes(payload).trim();
      if (pinStr.isNotEmpty && RegExp(r'^\d+$').hasMatch(pinStr)) {
        return int.parse(pinStr);
      }
    } catch (_) {}
    if (payload.length >= 4) {
      return (payload[0] << 24 |
              payload[1] << 16 |
              payload[2] << 8 |
              payload[3])
          .toUnsigned(32);
    }
    return DateTime.now().millisecond % 9000 + 1000;
  }

  /// Disconnect from the device.
  Future<void> disconnect() async {
    debugPrint('[AndroidTvConnMgr] disconnect()');
    _connectionStateController.add(TvConnectionState.disconnecting);
    try {
      if (_useCast) {
        await _castProtocol.disconnect();
      } else {
        await _protocol.disconnect();
      }
      debugPrint('[AndroidTvConnMgr] protocol disconnected');
    } catch (e) {
      debugPrint('[AndroidTvConnMgr] disconnect error: $e');
    }
    _connectedDevice = null;
    _connectedAt = null;
    _connectionStateController.add(TvConnectionState.disconnected);
  }

  /// Send a key event.
  Future<void> sendKeyEvent(int keyCode, {int action = 0}) async {
    debugPrint(
      '[AndroidTvConnMgr] sendKeyEvent keyCode=$keyCode action=$action useCast=$_useCast',
    );
    if (!isConnected) {
      debugPrint('[AndroidTvConnMgr] sendKeyEvent FAILED - not connected');
      throw DriverConnectionException('Not connected to device');
    }
    try {
      if (_useCast) {
        await _castProtocol.sendKeyEvent(keyCode, 0);
        if (action == 0) {
          await _castProtocol.sendKeyEvent(keyCode, 1);
        }
      } else {
        await _protocol.sendKeyEvent(keyCode, 0);
        if (action == 0) {
          await _protocol.sendKeyEvent(keyCode, 1);
        }
      }
      debugPrint('[AndroidTvConnMgr] key event sent OK');
    } catch (e) {
      debugPrint('[AndroidTvConnMgr] key event error: $e');
      throw DriverCommandException(
        'Key event failed: $e',
        cause: e is Exception ? e : null,
      );
    }
  }

  /// Send a touch event.
  Future<void> sendTouchEvent(int action, double x, double y) async {
    debugPrint('[AndroidTvConnMgr] sendTouchEvent action=$action x=$x y=$y');
    if (!isConnected) {
      debugPrint('[AndroidTvConnMgr] sendTouchEvent FAILED - not connected');
      throw DriverConnectionException('Not connected to device');
    }
    try {
      if (_useCast) {
        final payload = '{"type":"TOUCH_EVENT","action":$action,"x":$x,"y":$y}';
        await _castProtocol.sendMessage(
          _buildCastMessage('urn:x-cast:com.google.cast.input', payload),
        );
      } else {
        await _protocol.sendTouchEvent(action, x, y);
      }
      debugPrint('[AndroidTvConnMgr] touch event sent OK');
    } catch (e) {
      debugPrint('[AndroidTvConnMgr] touch event error: $e');
      throw DriverCommandException(
        'Touch event failed: $e',
        cause: e is Exception ? e : null,
      );
    }
  }

  CastMessage _buildCastMessage(String namespace, String payload) {
    // We need to import CastMessage
    return CastMessage(
      sourceId: 'sender-0',
      destinationId: 'receiver-0',
      namespace: namespace,
      payloadUtf8: payload,
    );
  }

  /// Send text by translating each character to key events.
  Future<void> sendText(String text) async {
    debugPrint('[AndroidTvConnMgr] sendText text="$text"');
    if (!isConnected) {
      debugPrint('[AndroidTvConnMgr] sendText FAILED - not connected');
      throw DriverConnectionException('Not connected to device');
    }
    try {
      int sent = 0;
      for (final char in text.runes) {
        final keyCode = charCodeToAndroidKeyCode(char);
        if (keyCode != null) {
          await sendKeyEvent(keyCode);
          sent++;
        }
      }
      debugPrint('[AndroidTvConnMgr] sendText sent $sent characters');
    } catch (e) {
      debugPrint('[AndroidTvConnMgr] sendText error: $e');
      throw DriverCommandException(
        'Send text failed: $e',
        cause: e is Exception ? e : null,
      );
    }
  }

  /// Clean up.
  Future<void> dispose() async {
    _disposed = true;
    await disconnect();
    await _connectionStateController.close();
  }
}
