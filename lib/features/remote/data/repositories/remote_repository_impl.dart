import 'package:injectable/injectable.dart';
import '../../../../core/enums/remote_command.dart';
import '../../domain/entities/touch_event.dart';
import '../../domain/repositories/remote_repository.dart';
import '../datasources/remote_datasource.dart';
import '../../../discovery/domain/entities/tv_device.dart';

@injectable
@LazySingleton(as: RemoteRepository)
final class RemoteRepositoryImpl implements RemoteRepository {
  final RemoteDatasource _datasource;

  RemoteRepositoryImpl(this._datasource);

  @override
  Future<void> sendCommand(String deviceId, RemoteCommand command) async {
    // Device lookup would come from a cache if needed
    final device = TvDevice(
      id: deviceId,
      name: '',
      ipAddress: '',
      port: 0,
      deviceType: 'android_tv',
    );
    await _datasource.sendCommand(device, command);
  }

  @override
  Future<void> sendText(String deviceId, String text) async {
    final device = TvDevice(
      id: deviceId,
      name: '',
      ipAddress: '',
      port: 0,
      deviceType: 'android_tv',
    );
    await _datasource.sendText(device, text);
  }

  @override
  Future<void> sendTouch(String deviceId, TouchEvent event) async {
    final device = TvDevice(
      id: deviceId,
      name: '',
      ipAddress: '',
      port: 0,
      deviceType: 'android_tv',
    );
    await _datasource.sendTouch(device, event);
  }
}
