import 'package:injectable/injectable.dart';
import 'package:remote/core/enums/remote_command.dart';
import '../driver_exception.dart';
import '../models/driver_capability.dart';
import '../models/driver_connection.dart';
import '../models/driver_device.dart';
import '../models/driver_info.dart';
import '../models/driver_pairing_session.dart';
import '../models/driver_touch_input.dart';
import '../tv_driver.dart';
import 'android_keycodes.dart';
import 'android_tv_connection_manager.dart';

@Singleton()
@Named('android_tv')
class AndroidTvDriver implements TvDriver {
  final AndroidTvConnectionManager _connectionManager;

  AndroidTvDriver(this._connectionManager);

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
      device.deviceType == 'android_tv_emulator' ||
      device.deviceType == 'android_tv_remote';

  @override
  Stream<DriverDevice> discover() async* {
    throw const DriverNotImplementedException('android_tv', 'discover');
  }

  @override
  Future<DriverConnection> connect(DriverDevice device) async {
    // Port 6466 is the default Android TV remote protocol port
    final normalizedDevice = device.port == 0
        ? device.copyWith(port: 6466)
        : device;
    return _connectionManager.connect(normalizedDevice);
  }

  @override
  Future<DriverPairingSession> pair(DriverDevice device) async {
    // ponytail: pairing will be implemented in M7.2
    // For now, connect and return a stub session
    await connect(device);
    return DriverPairingSession(
      deviceId: device.id,
      sessionId: 'pending_${device.id}',
      pin: 0,
      isPaired: false,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> disconnect() async {
    await _connectionManager.disconnect();
  }

  @override
  Future<void> sendCommand(RemoteCommand command) async {
    final keyCode = remoteCommandToAndroidKeyCode(command);
    await _connectionManager.sendKeyEvent(keyCode);
  }

  @override
  Future<void> sendText(String text) async {
    await _connectionManager.sendText(text);
  }

  @override
  Future<void> sendTouch(DriverTouchInput input) async {
    await _connectionManager.sendTouchEvent(
      input.type == DriverTouchType.up
          ? 2
          : input.type == DriverTouchType.move
          ? 1
          : 0,
      input.x,
      input.y,
    );
  }
}
