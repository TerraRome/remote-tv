import 'package:remote/core/enums/remote_command.dart';
import 'models/driver_capability.dart';
import 'models/driver_connection.dart';
import 'models/driver_device.dart';
import 'models/driver_info.dart';
import 'models/driver_pairing_session.dart';
import 'models/driver_touch_input.dart';

abstract interface class TvDriver {
  String get id;
  String get name;
  String get manufacturer;
  DriverInfo get info;
  Set<DriverCapability> get capabilities;

  Future<bool> supports(DriverDevice device);
  Stream<DriverDevice> discover();
  Future<DriverConnection> connect(DriverDevice device);
  Future<DriverPairingSession> pair(DriverDevice device);
  Future<void> disconnect();
  Future<void> sendCommand(RemoteCommand command);
  Future<void> sendText(String text);
  Future<void> sendTouch(DriverTouchInput input);
}
