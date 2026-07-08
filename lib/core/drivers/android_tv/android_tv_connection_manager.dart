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
import 'transport/android_tv_transport.dart';

/// Manages a TLS-based connection to an Android TV using the TV remote protocol.
///
/// Uses port 6466 (default Android TV remote protocol port).
/// Handles connection, pairing, and remote control commands.
@singleton
class AndroidTvConnectionManager {
  AndroidTvConnectionManager({
    required AndroidTvProtocolHandler protocol,
    required AndroidTvTransport transport,
  }) : _protocol = protocol,
       _transport = transport;

  final AndroidTvProtocolHandler _protocol;
  final AndroidTvTransport _transport;

  DriverDevice? _connectedDevice;
  DateTime? _connectedAt;
  bool _disposed = false;

  final _connectionStateController =
      StreamController<TvConnectionState>.broadcast();

  /// Stream of connection state changes.
  Stream<TvConnectionState> get connectionState =>
      _connectionStateController.stream;

  bool get isConnected => _transport.isConnected && _connectedDevice != null;

  DriverDevice? get connectedDevice => _connectedDevice;

  /// Connect to the TV using TLS remote protocol on port 6466.
  ///
  /// Retry-safe: up to [maxRetries] attempts with [retryDelay] between each.
  /// Does NOT perform pairing - only TLS connection and message listener setup.
  Future<DriverConnection> connect(
    DriverDevice device, {
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
  }) async {
    debugPrint(
      '[AndroidTvConnMgr] connect() ${device.ipAddress}:${device.port}',
    );
    if (_disposed) throw StateError('Connection manager disposed');
    if (isConnected) {
      debugPrint('[AndroidTvConnMgr] already connected, disconnecting first');
      await disconnect();
    }

    final port = device.port == 0 ? 6466 : device.port;
    _connectionStateController.add(TvConnectionState.connecting);

    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      debugPrint('[AndroidTvConnMgr] connect attempt $attempt/$maxRetries');
      try {
        await _protocol.connect(device.ipAddress, port);
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

  /// Perform the pairing protocol after TLS connection.
  ///
  /// 1. Option exchange (pairing request)
  /// 2. TV shows PIN, returns pairing request ack
  /// 3. Waits for [submitPin] to be called with user-entered PIN
  /// 4. Sends PIN, gets ack
  /// 5. Configuration exchange (certificates)
  /// 6. Returns DriverPairingSession
  ///
  /// The returned session contains the PIN the TV displayed.
  Future<DriverPairingSession> pair(DriverDevice device) async {
    debugPrint('[AndroidTvConnMgr] pair() device=${device.id}');
    if (_disposed) throw StateError('Connection manager disposed');
    if (!isConnected) {
      debugPrint('[AndroidTvConnMgr] pair FAILED - not connected');
      throw DriverConnectionException('Not connected - call connect() first');
    }

    // Step 1: Option exchange - request pairing
    _connectionStateController.add(TvConnectionState.connecting);
    debugPrint('[AndroidTvConnMgr] exchanging options...');
    await _protocol.exchangeOptions(
      Uint8List.fromList([0x01]), // pairing option
      Uint8List.fromList('Remote App'.codeUnits), // client name
    );
    debugPrint('[AndroidTvConnMgr] options exchanged OK');

    // Step 2: Initiate pairing - TV shows PIN
    debugPrint('[AndroidTvConnMgr] initiating pairing...');
    final ack = await _protocol.initiatePairing(Uint8List.fromList([0x01]));
    debugPrint(
      '[AndroidTvConnMgr] initiate pairing ack received, payload len=${ack.payload.length}',
    );
    // ponytail: parse ack payload for PIN
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

  /// Submit the PIN displayed on TV to complete pairing.
  ///
  /// Must be called after [pair] returns the session with the PIN.
  /// Returns true if pairing succeeded.
  Future<bool> submitPin(DriverPairingSession session, String pin) async {
    debugPrint(
      '[AndroidTvConnMgr] submitPin() sessionId=${session.sessionId} pin=$pin',
    );
    if (_disposed) {
      debugPrint('[AndroidTvConnMgr] submitPin FAILED - disposed');
      throw StateError('Connection manager disposed');
    }
    if (!isConnected) {
      debugPrint('[AndroidTvConnMgr] submitPin FAILED - not connected');
      throw DriverConnectionException('Not connected');
    }

    try {
      // Step 3: Send the PIN
      debugPrint('[AndroidTvConnMgr] sending PIN to TV...');
      await _protocol.sendPin(pin);
      debugPrint('[AndroidTvConnMgr] PIN sent');

      // Step 4: Configuration exchange (certificates)
      final serverCert = _transport.serverCertificate;
      if (serverCert != null) {
        debugPrint('[AndroidTvConnMgr] setting server certificate');
        _protocol.setServerCertificate(serverCert);
      }

      // Exchange client configuration / certificate
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

  /// Parse PIN from pairing request ack payload.
  /// ponytail: implement real PIN extraction per protocol version
  int _parsePinFromAck(Uint8List payload) {
    if (payload.length >= 4) {
      return (payload[0] << 24 |
              payload[1] << 16 |
              payload[2] << 8 |
              payload[3])
          .toUnsigned(32);
    }
    // Fallback: generate random 4-digit PIN for testing
    return DateTime.now().millisecond % 9000 + 1000;
  }

  /// Disconnect from the TV.
  Future<void> disconnect() async {
    debugPrint('[AndroidTvConnMgr] disconnect()');
    _connectionStateController.add(TvConnectionState.disconnecting);
    try {
      await _protocol.disconnect();
      debugPrint('[AndroidTvConnMgr] protocol disconnected');
    } catch (e) {
      debugPrint('[AndroidTvConnMgr] disconnect error: $e');
    }
    _connectedDevice = null;
    _connectedAt = null;
    _connectionStateController.add(TvConnectionState.disconnected);
  }

  /// Send a key event using the remote protocol.
  Future<void> sendKeyEvent(int keyCode, {int action = 0}) async {
    debugPrint(
      '[AndroidTvConnMgr] sendKeyEvent keyCode=$keyCode action=$action',
    );
    if (!isConnected) {
      debugPrint('[AndroidTvConnMgr] sendKeyEvent FAILED - not connected');
      throw DriverConnectionException('Not connected to device');
    }
    try {
      await _protocol.sendKeyEvent(keyCode, 0);
      if (action == 0) {
        await _protocol.sendKeyEvent(keyCode, 1);
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

  /// Send a touch event using the remote protocol.
  Future<void> sendTouchEvent(int action, double x, double y) async {
    debugPrint('[AndroidTvConnMgr] sendTouchEvent action=$action x=$x y=$y');
    if (!isConnected) {
      debugPrint('[AndroidTvConnMgr] sendTouchEvent FAILED - not connected');
      throw DriverConnectionException('Not connected to device');
    }
    try {
      await _protocol.sendTouchEvent(action, x, y);
      debugPrint('[AndroidTvConnMgr] touch event sent OK');
    } catch (e) {
      debugPrint('[AndroidTvConnMgr] touch event error: $e');
      throw DriverCommandException(
        'Touch event failed: $e',
        cause: e is Exception ? e : null,
      );
    }
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
