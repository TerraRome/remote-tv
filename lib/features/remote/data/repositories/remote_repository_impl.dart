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
  Future<void> sendCommand(TvDevice device, RemoteCommand command) async {
    await _datasource.sendCommand(device, command);
  }

  @override
  Future<void> sendText(TvDevice device, String text) async {
    await _datasource.sendText(device, text);
  }

  @override
  Future<void> sendTouch(TvDevice device, TouchEvent event) async {
    await _datasource.sendTouch(device, event);
  }
}
