import 'package:remote/core/enums/remote_command.dart';
import '../driver_exception.dart';
import '../models/driver_capability.dart';
import '../models/driver_connection.dart';
import '../models/driver_device.dart';
import '../models/driver_info.dart';
import '../models/driver_pairing_session.dart';
import '../models/driver_touch_input.dart';
import '../tv_driver.dart';

class AndroidTvDriver implements TvDriver {
  @override
  String get id => 'android_tv';

  @override
  String get name => 'Android TV Driver';

  @override
  String get manufacturer => 'Google';

  @override
  DriverInfo get info => const DriverInfo(
    id: 'android_tv',
    name: 'Android TV Driver',
    manufacturer: 'Google',
    version: '1.0.0',
    description: 'Driver for Android TV devices via ADB/network protocol',
  );

  @override
  Set<DriverCapability> get capabilities => {
    DriverCapability.discovery,
    DriverCapability.pairing,
    DriverCapability.power,
    DriverCapability.volume,
    DriverCapability.mute,
    DriverCapability.home,
    DriverCapability.back,
    DriverCapability.menu,
    DriverCapability.dPad,
    DriverCapability.keyboard,
    DriverCapability.touchpad,
    DriverCapability.mediaControl,
    DriverCapability.voice,
  };

  @override
  Future<bool> supports(DriverDevice device) async =>
      device.deviceType == 'android_tv' ||
      device.deviceType == 'android_tv_emulator';

  @override
  Stream<DriverDevice> discover() async* {
    throw const DriverNotImplementedException('android_tv', 'discover');
  }

  @override
  Future<DriverConnection> connect(DriverDevice device) async {
    throw const DriverNotImplementedException('android_tv', 'connect');
  }

  @override
  Future<DriverPairingSession> pair(DriverDevice device) async {
    throw const DriverNotImplementedException('android_tv', 'pair');
  }

  @override
  Future<void> disconnect() async {
    throw const DriverNotImplementedException('android_tv', 'disconnect');
  }

  @override
  Future<void> sendCommand(RemoteCommand command) async {
    throw const DriverNotImplementedException('android_tv', 'sendCommand');
  }

  @override
  Future<void> sendText(String text) async {
    throw const DriverNotImplementedException('android_tv', 'sendText');
  }

  @override
  Future<void> sendTouch(DriverTouchInput input) async {
    throw const DriverNotImplementedException('android_tv', 'sendTouch');
  }
}
