import 'package:injectable/injectable.dart';
import 'package:hive/hive.dart';
import '../../../../core/drivers/models/driver_pairing_session.dart';
import '../../../../core/enums/connection_state.dart';
import '../../../remote/domain/entities/tv_connection.dart';
import '../../../discovery/domain/entities/tv_device.dart';
import '../../domain/repositories/connection_repository.dart';
import '../datasources/pairing_datasource.dart';

@Injectable(as: ConnectionRepository)
final class ConnectionRepositoryImpl implements ConnectionRepository {
  final PairingDatasource _datasource;
  late final Box<TvConnection> _connectionBox;

  ConnectionRepositoryImpl(this._datasource) {
    _connectionBox = Hive.box<TvConnection>('connections');
  }

  @override
  Future<TvConnection> connect(TvDevice device) async {
    final session = await _datasource.pairDevice(device);

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
    return _datasource.startPairing(device);
  }

  @override
  Future<bool> submitPin(String sessionId, String pin) async {
    return _datasource.submitPin(sessionId, pin);
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
