import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:hive/hive.dart';
import '../../../../core/drivers/models/driver_pairing_session.dart';
import '../../../../core/enums/connection_state.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../remote/domain/entities/tv_connection.dart';
import '../../../discovery/domain/entities/tv_device.dart';
import '../../domain/repositories/connection_repository.dart';
import '../datasources/pairing_datasource.dart';

@Injectable(as: ConnectionRepository)
final class ConnectionRepositoryImpl implements ConnectionRepository {
  final PairingDatasource _datasource;
  late final Box _connectionBox;

  ConnectionRepositoryImpl(this._datasource) {
    _connectionBox = Hive.box(StorageService.connectionsBoxName);
  }

  @override
  Future<TvConnection> connect(TvDevice device) async {
    debugPrint('[ConnRepoImpl] connect device=${device.id}');
    final session = await _datasource.pairDevice(device);
    debugPrint('[ConnRepoImpl] connect OK sessionId=${session.sessionId}');

    final connection = TvConnection(
      deviceId: device.id,
      driverId: 'android_tv',
      state: TvConnectionState.connected,
      sessionToken: session.sessionId,
      connectedAt: DateTime.now(),
      lastActivityAt: DateTime.now(),
    );

    await _connectionBox.put(device.id, connection);
    return connection;
  }

  @override
  Future<DriverPairingSession> startPairing(TvDevice device) async {
    debugPrint('[ConnRepoImpl] startPairing device=${device.id}');
    try {
      final session = await _datasource.startPairing(device);
      debugPrint(
        '[ConnRepoImpl] startPairing OK sessionId=${session.sessionId} pin=${session.pin}',
      );
      return session;
    } catch (e) {
      debugPrint('[ConnRepoImpl] startPairing FAILED: $e');
      rethrow;
    }
  }

  @override
  Future<bool> submitPin(String sessionId, String pin) async {
    debugPrint('[ConnRepoImpl] submitPin sessionId=$sessionId pin=$pin');
    try {
      final result = await _datasource.submitPin(sessionId, pin);
      debugPrint('[ConnRepoImpl] submitPin OK result=$result');
      return result;
    } catch (e) {
      debugPrint('[ConnRepoImpl] submitPin FAILED: $e');
      rethrow;
    }
  }

  @override
  Future<void> disconnect(String deviceId) async {
    await _datasource.disconnectDevice(deviceId);
    await _connectionBox.delete(deviceId);
  }

  @override
  Future<TvConnection?> getConnection(String deviceId) async {
    return _connectionBox.get(deviceId);
  }

  @override
  Stream<TvConnectionState> watchConnectionState(String deviceId) {
    return _connectionBox.watch(key: deviceId).map((event) {
      return event.value?.state ?? TvConnectionState.disconnected;
    });
  }
}
