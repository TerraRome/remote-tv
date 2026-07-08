# MVP Execution Plan — Xiaomi TV Remote

## Status: READY TO EXECUTE

## Files to Edit

### Step 2a: `pairing_page.dart` — Pass TvDevice as route extra

File: `lib/features/pairing/presentation/pages/pairing_page.dart`

**Change L55**: Add `extra: state.device` to push call:

```dart
// BEFORE:
context.push('/remote/${state.device.id}');

// AFTER:
context.push('/remote/${state.device.id}', extra: state.device);
```

---

### Step 2b: `app_router.dart` — Extract TvDevice, pass to RemotePage

File: `lib/app/router/app_router.dart`

**Change L47-56** — Route `/remote/:deviceId`:

```dart
// BEFORE:
GoRoute(
  path: '/remote/:deviceId',
  name: 'remote',
  builder: (context, state) {
    final deviceId = state.pathParameters['deviceId']!;
    return BlocProvider(
      create: (_) => getIt<RemoteBloc>(),
      child: RemotePage(deviceId: deviceId),
    );
  },
),

// AFTER:
GoRoute(
  path: '/remote/:deviceId',
  name: 'remote',
  builder: (context, state) {
    final device = state.extra as TvDevice;
    return BlocProvider(
      create: (_) => getIt<RemoteBloc>(),
      child: RemotePage(device: device),
    );
  },
),
```

**Add import** if not present:
```dart
import '../../features/discovery/domain/entities/tv_device.dart';
```

---

### Step 2c: `remote_event.dart` — RemoteDeviceChanged bawa TvDevice

File: `lib/features/remote/presentation/bloc/remote_event.dart`

**Add import**:
```dart
import '../../../discovery/domain/entities/tv_device.dart';
```

**Change L36-41**:
```dart
// BEFORE:
final class RemoteDeviceChanged extends RemoteEvent {
  final String deviceId;
  const RemoteDeviceChanged(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}

// AFTER:
final class RemoteDeviceChanged extends RemoteEvent {
  final TvDevice device;
  const RemoteDeviceChanged(this.device);

  @override
  List<Object?> get props => [device];
}
```

---

### Step 2d: `remote_state.dart` — RemoteReady bawa TvDevice

File: `lib/features/remote/presentation/bloc/remote_state.dart`

**Add import**:
```dart
import '../../../discovery/domain/entities/tv_device.dart';
```

**Change L14-19**:
```dart
// BEFORE:
final class RemoteReady extends RemoteState {
  final String deviceId;
  const RemoteReady(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}

// AFTER:
final class RemoteReady extends RemoteState {
  final TvDevice device;
  const RemoteReady(this.device);

  @override
  List<Object?> get props => [device];
}
```

---

### Step 2e: `remote_page.dart` — Accept TvDevice, pass to bloc

File: `lib/features/remote/presentation/pages/remote_page.dart`

**Add import**:
```dart
import '../../../discovery/domain/entities/tv_device.dart';
import '../../../../di/injection.dart';
```

**Change L14-29**:
```dart
// BEFORE:
final class RemotePage extends StatelessWidget {
  final String deviceId;
  const RemotePage({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RemoteBloc>(
      create: (context) {
        final bloc = context.read<RemoteBloc>();
        bloc.add(RemoteDeviceChanged(deviceId));
        return bloc;
      },
      child: const _RemoteView(),
    );
  }
}

// AFTER:
final class RemotePage extends StatelessWidget {
  final TvDevice device;
  const RemotePage({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RemoteBloc>(
      create: (context) {
        final bloc = getIt<RemoteBloc>();
        bloc.add(RemoteDeviceChanged(device));
        return bloc;
      },
      child: const _RemoteView(),
    );
  }
}
```

---

### Step 2f: `remote_bloc.dart` — Handle TvDevice

File: `lib/features/remote/presentation/bloc/remote_bloc.dart`

**Add import**:
```dart
import '../../../discovery/domain/entities/tv_device.dart';
```

**Change L19-36** — Match on device instead of deviceId:
```dart
// BEFORE:
@override
void _onDeviceChanged(RemoteDeviceChanged event, Emitter<RemoteState> emit) {
  emit(RemoteReady(event.deviceId));
}

Future<void> _onCommandIssued(
  RemoteCommandIssued event,
  Emitter<RemoteState> emit,
) async {
  try {
    final state = this.state;
    if (state case RemoteReady(:final deviceId)) {
      await _repository.sendCommand(deviceId, event.command);
      // ...
    }
  } // ...
}

// AFTER:
void _onDeviceChanged(RemoteDeviceChanged event, Emitter<RemoteState> emit) {
  emit(RemoteReady(event.device));
}

Future<void> _onCommandIssued(
  RemoteCommandIssued event,
  Emitter<RemoteState> emit,
) async {
  try {
    final state = this.state;
    if (state case RemoteReady(:final device)) {
      await _repository.sendCommand(device, event.command);
      final label = event.command.name;
      emit(RemoteCommandSent('$label sent'));
    }
  } catch (e) {
    emit(RemoteError(e.toString()));
  }
}

Future<void> _onTouchSent(
  RemoteTouchEventSent event,
  Emitter<RemoteState> emit,
) async {
  try {
    final state = this.state;
    if (state case RemoteReady(:final device)) {
      await _repository.sendTouch(device, event.touchEvent);
      emit(const RemoteCommandSent('Touch sent'));
    }
  } catch (e) {
    emit(RemoteError(e.toString()));
  }
}

Future<void> _onTextSent(
  RemoteTextSent event,
  Emitter<RemoteState> emit,
) async {
  try {
    final state = this.state;
    if (state case RemoteReady(:final device)) {
      await _repository.sendText(device, event.text);
      emit(RemoteCommandSent('Text sent'));
    }
  } catch (e) {
    emit(RemoteError(e.toString()));
  }
}
```

**Remove helper function** at bottom:
```dart
// DELETE this function:
/// Helper to create RemoteDevice from a discovery device
TvDevice tvDeviceFromId(String deviceId) {
  return TvDevice(
    id: deviceId,
    name: '',
    ipAddress: '',
    port: 0,
    deviceType: 'android_tv',
  );
}
```

---

### Step 2g: `remote_repository_impl.dart` — Use TvDevice directly

File: `lib/features/remote/data/repositories/remote_repository_impl.dart`

**Change L15-49** — Remove dummy TvDevice construction, use passed device:
```dart
// BEFORE:
  @override
  Future<void> sendCommand(String deviceId, RemoteCommand command) async {
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

// AFTER:
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
```

**Also update RemoteRepository interface** file: `lib/features/remote/domain/repositories/remote_repository.dart`:
```dart
// BEFORE:
abstract interface class RemoteRepository {
  Future<void> sendCommand(String deviceId, RemoteCommand command);
  Future<void> sendText(String deviceId, String text);
  Future<void> sendTouch(String deviceId, TouchEvent event);
}

// AFTER:
import '../../../discovery/domain/entities/tv_device.dart';

abstract interface class RemoteRepository {
  Future<void> sendCommand(TvDevice device, RemoteCommand command);
  Future<void> sendText(TvDevice device, String text);
  Future<void> sendTouch(TvDevice device, TouchEvent event);
}
```

---

### Step 2h: `remote_datasource.dart` — Auto-connect before send

File: `lib/features/remote/data/datasources/remote_datasource.dart`

**Add imports**:
```dart
import '../../../../core/drivers/tv_driver.dart';
import '../../../../core/drivers/models/driver_device.dart' as drv;
```

**Change entire class**:
```dart
@injectable
final class RemoteDatasource {
  final DriverRegistry _driverRegistry;

  RemoteDatasource(this._driverRegistry);

  TvDriver _getDriver() {
    final driver = _driverRegistry.resolveById('android_tv');
    if (driver == null) {
      throw Exception('No driver available for remote control');
    }
    return driver;
  }

  drv.DriverDevice _toDriverDevice(TvDevice device) {
    return drv.DriverDevice(
      id: device.id,
      name: device.name,
      ipAddress: device.ipAddress,
      port: device.port,
      deviceType: device.deviceType,
    );
  }

  Future<void> _ensureConnected(TvDriver driver, TvDevice device) async {
    // Use isConnected from AndroidTvConnectionManager via transport
    // This is best-effort; if already connected, connect() is idempotent
    try {
      await driver.connect(_toDriverDevice(device));
    } catch (_) {
      // If connect fails, let the caller handle the error
    }
  }

  Future<void> sendCommand(TvDevice device, RemoteCommand command) async {
    final driver = _getDriver();
    try {
      await driver.sendCommand(command);
    } catch (e) {
      // If not connected, try reconnecting first
      await _ensureConnected(driver, device);
      await driver.sendCommand(command);
    }
  }

  Future<void> sendText(TvDevice device, String text) async {
    final driver = _getDriver();
    try {
      await driver.sendText(text);
    } catch (e) {
      await _ensureConnected(driver, device);
      await driver.sendText(text);
    }
  }

  Future<void> sendTouch(TvDevice device, TouchEvent event) async {
    final driver = _getDriver();
    final input = drv_touch.DriverTouchInput(
      type: drv_touch.DriverTouchType.values[event.type.index],
      x: event.x,
      y: event.y,
      dx: event.dx,
      dy: event.dy,
    );
    try {
      await driver.sendTouch(input);
    } catch (e) {
      await _ensureConnected(driver, device);
      await driver.sendTouch(input);
    }
  }
}
```

---

### Step 2i: `android_tv_connection_manager.dart` — Idempotent connect

File: `lib/core/drivers/android_tv/android_tv_connection_manager.dart`

Add this check after the `isConnected` guard:
```dart
if (isConnected) {
  // Already connected to the same device
  if (_connectedDevice?.ipAddress == device.ipAddress && _connectedDevice?.port == port) {
    return DriverConnection(
      deviceId: device.id,
      driverId: 'android_tv',
      state: 'connected',
      sessionToken: 'session_${device.id}_${_connectedAt!.millisecondsSinceEpoch}',
      connectedAt: _connectedAt!,
      lastActivityAt: _connectedAt,
    );
  }
  // Different device, disconnect first
  await disconnect();
}
```

---

### Step 3a: PIN Extraction — Multi-format parser

File: `lib/core/drivers/android_tv/android_tv_connection_manager.dart`

**Change L208-218**:
```dart
int _parsePinFromAck(Uint8List payload) {
  // Android TV protocol: PIN dikirim sebagai ASCII string
  // Contoh: "123456" -> bytes [0x31, 0x32, 0x33, 0x34, 0x35, 0x36]
  try {
    final pinStr = String.fromCharCodes(payload).trim();
    if (pinStr.isNotEmpty && RegExp(r'^\d+$').hasMatch(pinStr)) {
      return int.parse(pinStr);
    }
  } catch (_) {}

  // Fallback: big-endian uint32
  if (payload.length >= 4) {
    return (payload[0] << 24 | payload[1] << 16 | payload[2] << 8 | payload[3])
        .toUnsigned(32);
  }

  // Last fallback: random 4-digit (shouldn't happen)
  return DateTime.now().millisecond % 9000 + 1000;
}
```

---

### Step 3b: `protocol_handler.dart` — Parse ack success/failure

File: `lib/core/drivers/android_tv/protocol/android_tv_protocol_handler.dart`

**Add import**:
```dart
import '../driver_exception.dart';
```

**Change L176-188**:
```dart
Future<AndroidTvMessage> sendPin(String pin) async {
  debugPrint('[ProtocolHandler] sendPin pin=$pin');
  final secret = _codec.encodePairingSecret(pin);
  debugPrint('[ProtocolHandler] encoded pairing secret, waiting for ack');
  final ack = await sendAndWait(
    secret,
    AndroidTvMessageType.pairingSecretAck,
  );
  debugPrint(
    '[ProtocolHandler] sendPin ack received, payloadLen=${ack.payload.length}',
  );
  // Parse ack: byte 0 = 0x01 success, 0x00 failure
  if (ack.payload.isNotEmpty && ack.payload[0] == 0x00) {
    throw DriverPairingException('TV rejected the PIN');
  }
  return ack;
}
```

---

### Step 4: Remove redundant connect

File: `lib/features/pairing/data/datasources/pairing_datasource.dart`

**Change L65-71** — Remove explicit `driver.connect()` since `driver.pair()` calls it:

```dart
// BEFORE:
Future<drv_session.DriverPairingSession> startPairing(TvDevice device) async {
  final driverDevice = _toDriverDevice(device);
  final driver = await _resolve(driverDevice);

  await driver.connect(driverDevice);
  return driver.pair(driverDevice);
}

// AFTER:
Future<drv_session.DriverPairingSession> startPairing(TvDevice device) async {
  final driverDevice = _toDriverDevice(device);
  final driver = await _resolve(driverDevice);
  return driver.pair(driverDevice); // pair() calls connect() internally
}
```

---

### Step 5: Clean debug logs

Replace verbose `debugPrint` in all modified files with `AppLogger` calls.
- Keep important lifecycle logs (connect, pairing result, disconnect)
- Remove per-byte/per-packet logs (e.g., "send 12 bytes", "received 48 bytes")
- Use consistent format: `[ClassName] method: message`

Files to clean:
- `android_tv_connection_manager.dart`
- `android_tv_protocol_handler.dart`
- `secure_socket_transport.dart`
- `pairing_page.dart`
- `pairing_bloc.dart`
- `pairing_datasource.dart`
- `connection_repository_impl.dart`
- `storage_service.dart`
- `discovery_page.dart`

---

### Step 6: Build & Analyze

```bash
cd /Users/macbook/Desktop/Projects/Remote
dart pub get
dart run build_runner build --delete-conflicting-outputs
dart analyze
```

Fix any issues.

---

### Step 7: Build APK Debug

```bash
flutter build apk --debug
```

APK akan di: `build/app/outputs/flutter-apk/app-debug.apk`
