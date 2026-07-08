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
    throw const DriverNotImplementedException(
      'discover not implemented for android_tv',
    );
  }

  @override
  Future<DriverConnection> connect(DriverDevice device) async {
    // Android TV remote protocol always uses port 6466
    // Ignore mDNS port (e.g. Google Cast port 8009)
    final normalizedDevice = device.copyWith(port: 6466);
    return _connectionManager.connect(normalizedDevice);
  }

  @override
  Future<DriverPairingSession> pair(DriverDevice device) async {
    await connect(device);
    return _connectionManager.pair(device);
  }

  @override
  Future<bool> submitPin(DriverPairingSession session, String pin) async {
    return _connectionManager.submitPin(session, pin);
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
