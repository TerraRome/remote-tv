import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../enums/connection_state.dart';
import '../driver_exception.dart';
import '../models/driver_connection.dart';
import '../models/driver_device.dart';
import 'android_keycodes.dart';
import 'protocol/android_tv_protocol_handler.dart';
import 'transport/android_tv_transport.dart';

/// Manages a TLS-based connection to an Android TV using the TV remote protocol.
///
/// Uses port 6466 (default Android TV remote protocol port).
/// No pairing logic. Pure connection management.
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
