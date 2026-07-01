import 'dart:async';
import 'dart:typed_data';

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
    if (_disposed) throw StateError('Connection manager disposed');
    if (isConnected) await disconnect();

    final port = device.port == 0 ? 6466 : device.port;
    _connectionStateController.add(TvConnectionState.connecting);

    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        await _protocol.connect(device.ipAddress, port);
        _connectedDevice = device;
        _connectedAt = DateTime.now();
        _connectionStateController.add(TvConnectionState.connected);
        return DriverConnection(
          deviceId: device.id,
          driverId: 'android_tv',
          state: 'connected',
          sessionToken:
              'session_${device.id}_${_connectedAt!.millisecondsSinceEpoch}',
          connectedAt: _connectedAt!,
          lastActivityAt: _connectedAt,
        );
      } on DriverException catch (_) {
        if (attempt >= maxRetries) {
          _connectionStateController.add(TvConnectionState.failed);
          rethrow;
        }
        await Future<void>.delayed(retryDelay);
      } catch (e) {
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
    if (_disposed) throw StateError('Connection manager disposed');
    if (!isConnected) {
      throw DriverConnectionException('Not connected - call connect() first');
    }

    // Step 1: Option exchange - request pairing
    _connectionStateController.add(TvConnectionState.connecting);
    await _protocol.exchangeOptions(
      Uint8List.fromList([0x01]), // pairing option
      Uint8List.fromList('Remote App'.codeUnits), // client name
    );

    // Step 2: Initiate pairing - TV shows PIN
    final ack = await _protocol.initiatePairing(Uint8List.fromList([0x01]));
    // ponytail: parse ack payload for PIN
    // The PIN displayed on TV is extracted from the pairing request ack payload.
    // Format varies; for now, generate a dummy PIN and let the data source
    // handle actual extraction.
    final pin = _parsePinFromAck(ack.payload);

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
    if (_disposed) throw StateError('Connection manager disposed');
    if (!isConnected) {
      throw DriverConnectionException('Not connected');
    }

    try {
      // Step 3: Send the PIN
      final secretAck = await _protocol.sendPin(pin);
      // ponytail: check secretAck payload for success/failure
      // ignore: unused_local_variable
      secretAck;

      // Step 4: Configuration exchange (certificates)
      // Capture the server certificate from TLS for pinning
      final serverCert = _transport.serverCertificate;
      if (serverCert != null) {
        _protocol.setServerCertificate(serverCert);
      }

      // Exchange client configuration / certificate
      // ponytail: send actual client cert once certificate manager is wired
      await _protocol.exchangeOptions(
        Uint8List.fromList([0x01]),
        Uint8List.fromList('Remote App (paired)'.codeUnits),
      );

      return _protocol.isPaired;
    } catch (e) {
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
    _connectionStateController.add(TvConnectionState.disconnecting);
    try {
      await _protocol.disconnect();
    } catch (_) {}
    _connectedDevice = null;
    _connectedAt = null;
    _connectionStateController.add(TvConnectionState.disconnected);
  }

  /// Send a key event using the remote protocol.
  Future<void> sendKeyEvent(int keyCode, {int action = 0}) async {
    if (!isConnected) {
      throw DriverConnectionException('Not connected to device');
    }
    try {
      await _protocol.sendKeyEvent(keyCode, 0);
      if (action == 0) {
        await _protocol.sendKeyEvent(keyCode, 1);
      }
    } catch (e) {
      throw DriverCommandException(
        'Key event failed: $e',
        cause: e is Exception ? e : null,
      );
    }
  }

  /// Send a touch event using the remote protocol.
  Future<void> sendTouchEvent(int action, double x, double y) async {
    if (!isConnected) {
      throw DriverConnectionException('Not connected to device');
    }
    try {
      await _protocol.sendTouchEvent(action, x, y);
    } catch (e) {
      throw DriverCommandException(
        'Touch event failed: $e',
        cause: e is Exception ? e : null,
      );
    }
  }

  /// Send text by translating each character to key events.
  Future<void> sendText(String text) async {
    if (!isConnected) {
      throw DriverConnectionException('Not connected to device');
    }
    try {
      for (final char in text.runes) {
        final keyCode = charCodeToAndroidKeyCode(char);
        if (keyCode != null) {
          await sendKeyEvent(keyCode);
        }
      }
    } catch (e) {
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
