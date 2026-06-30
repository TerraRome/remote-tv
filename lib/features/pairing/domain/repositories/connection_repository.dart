import '../../../remote/domain/entities/tv_connection.dart';
import '../../../discovery/domain/entities/tv_device.dart';
import '../../../../core/enums/connection_state.dart';

abstract interface class ConnectionRepository {
  Future<TvConnection> connect(TvDevice device);
  Future<void> disconnect(String deviceId);
  Future<TvConnection?> getConnection(String deviceId);
  Stream<TvConnectionState> watchConnectionState(String deviceId);
}
