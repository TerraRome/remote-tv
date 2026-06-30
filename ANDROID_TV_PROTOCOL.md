# Android TV / Google TV Remote Protocol

## Overview

Android TV and Google TV expose a **native remote control protocol** on TCP port **6466**.
This is the same protocol used by the official "Android TV Remote Control" Google Play app and by Google's own "Google TV" app.

**The current ADB-based implementation (port 5555) is incorrect for production.**  
ADB is a debug bridge, not a remote control API. It requires `adb shell` access which is:

- Disabled by default on production Android TV devices
- Requires USB debugging or Wi-Fi debugging toggled on
- Not available on Google TV / Android TV OS shipped after 2022 without developer mode

---

## Protocol Stack

```
┌─────────────────────────────────────────────┐
│  Application Layer (Remote Commands)        │
├─────────────────────────────────────────────┤
│  Pairing Layer (Certificate Exchange)       │
├─────────────────────────────────────────────┤
│  TLS v1.2 / v1.3                            │
├─────────────────────────────────────────────┤
│  TCP (port 6466)                             │
├─────────────────────────────────────────────┤
│  IP (IPv4, link-local or WiFi)             │
└─────────────────────────────────────────────┘
```

---

## 1. Discovery

### 1.1 mDNS (NSD - Network Service Discovery)

Android TV advertises via mDNS using service type:

```
_androidtvremote._tcp.local
```

**mDNS TXT records on the advertised service:**

| Key         | Value                       |
| ----------- | --------------------------- |
| `at`        | `1` or `0` (active TV)      |
| `at_fvid`   | Fingerprint / device ID     |
| `at_fvnm`   | Friendly device name        |
| `at_fvpt`   | Pairing type (0=digits PIN) |
| `at_fvsk`   | Secret key for pairing      |
| `at_mn`     | Model name                  |
| `at_mf`     | Manufacturer                |
| `bt`        | Bluetooth support           |
| `chromecap` | Chromecast capabilities     |
| `md`        | Model                       |
| `nf`        | Network flags               |
| `pa`        | Pairing availability        |

**Implementation approach:**

- Use Dart `multicast_dns` package (already in `pubspec.yaml`)
- Listen on `_androidtvremote._tcp.local`
- Parse TXT records to extract `name`, `model`, `manufacturer`, pairing support
- Return `DriverDevice` objects

### 1.2 SSDP (Simple Service Discovery Protocol)

Android TV also responds to SSDP M-SEARCH on `239.255.255.250:1900`.

**SSDP search target:** `urn:androidtv-remote-google-com:service:remote:1`

**Implementation approach:**

- Send UDP multicast M-SEARCH to `239.255.255.250:1900`
- Parse NOTIFY and M-SEARCH response headers
- Extract LOCATION header for device description XML
- Parse XML for friendly name, model, manufacturer

### 1.3 Manual Discovery

- User enters IP address manually
- Probe TCP port 6466
- Attempt TLS handshake to verify device is running the remote service

---

## 2. Connection & Pairing

### 2.1 TLS Handshake

1. Client (app) connects to `device_ip:6466` via TCP
2. Client initiates TLS v1.2/v1.3 handshake
3. During TLS handshake, server presents its self-signed certificate
4. Client generates its own self-signed certificate (RSA 2048-bit or ECDSA P-256)
5. Mutual TLS authentication is **not** used initially; instead, certificate pairing happens after TLS

### 2.2 Pairing Phase

After TLS is established, the pairing protocol exchanges binary messages.

**Message format (length-prefixed):**

```
┌──────────┬──────────────┬────────────────┐
│  4 bytes │  2 bytes     │  Variable      │
│  Length  │  Type         │  Payload       │
│ (big-end)│ (big-end)    │                │
└──────────┴──────────────┴────────────────┘
```

**Message Types:**

| Type | Name                  | Direction       | Description                       |
| ---- | --------------------- | --------------- | --------------------------------- |
| 0x01 | `PAIRING_REQUEST`     | Client → Server | Request to start pairing          |
| 0x02 | `PAIRING_REQUEST_ACK` | Server → Client | Acknowledge with options          |
| 0x03 | `PAIRING_SECRET`      | Client → Server | Send PIN (option A)               |
| 0x04 | `PAIRING_SECRET_ACK`  | Server → Client | PIN verification result           |
| 0x05 | `OPTION`              | Both            | Negotiate pairing option          |
| 0x06 | `CONFIGURATION`       | Both            | Device name, certificate exchange |
| 0x07 | `INPUT`               | Client → Server | Remote command                    |
| 0x08 | `INPUT_ACK`           | Server → Client | Command acknowledged              |

### 2.3 Pairing Flow (PIN Method)

```
App                              TV
 │                                │
 │──── OPTION (option=0x01) ────→│  Request pairing
 │                                │
 │←─── OPTION (option=0x01) ─────│  Option accepted
 │                                │
 │──── PAIRING_REQUEST ─────────→│  Initiate pairing
 │                                │
 │←── PAIRING_REQUEST_ACK ───────│  TV shows PIN on screen
 │    (options available)         │
 │                                │  ┌────────────┐
 │                                │  │  PIN: 1234 │
 │                                │  └────────────┘
 │──── PAIRING_SECRET ──────────→│  User enters PIN
 │    (PIN as string UTF-8)      │
 │                                │
 │←── PAIRING_SECRET_ACK ────────│  PIN verified (success/fail)
 │    (result code)              │
 │                                │
 │──── CONFIGURATION ───────────→│  Send client certificate
 │    (certificate)              │
 │                                │
 │←── CONFIGURATION ─────────────│  TV sends server certificate
 │    (certificate)              │
 │                                │
```

### 2.4 Certificate Persistence

After successful pairing:

1. Save the TV's self-signed certificate (DER or PEM) to Hive
2. Save the client's self-signed certificate and private key to Hive
3. On reconnection, use saved certificates to skip pairing
4. Certificate is keyed by device ID + last paired timestamp

---

## 3. Remote Commands

After pairing, commands are sent as `INPUT` messages over the same TLS connection.

### 3.1 INPUT Message Payload

The INPUT message payload is a simple binary structure:

```
┌──────────┬─────────────────────┐
│  1 byte  │  Key code           │
│  1 byte  │  Action             │
│  2 bytes │  (reserved)         │
└──────────┴─────────────────────┘
```

**Action values:**

| Value | Action  |
| ----- | ------- | ------------- |
| 0x00  | `PRESS` | Down + Up     |
| 0x01  | `DOWN`  | Key down only |
| 0x02  | `UP`    | Key up only   |

### 3.2 Key Codes (Android KeyEvent values)

Same as `android.view.KeyEvent` integer constants.

| Key                | Code | Notes |
| ------------------ | ---- | ----- |
| POWER              | 26   |       |
| VOLUME_UP          | 24   |       |
| VOLUME_DOWN        | 25   |       |
| VOLUME_MUTE        | 164  |       |
| HOME               | 3    |       |
| BACK               | 4    |       |
| MENU               | 82   |       |
| DPAD_UP            | 19   |       |
| DPAD_DOWN          | 20   |       |
| DPAD_LEFT          | 21   |       |
| DPAD_RIGHT         | 22   |       |
| DPAD_CENTER        | 23   | (OK)  |
| MEDIA_PLAY         | 126  |       |
| MEDIA_PAUSE        | 127  |       |
| MEDIA_STOP         | 86   |       |
| MEDIA_NEXT         | 87   |       |
| MEDIA_PREVIOUS     | 88   |       |
| MEDIA_FAST_FORWARD | 90   |       |
| MEDIA_REWIND       | 89   |       |
| CHANNEL_UP         | 166  |       |
| CHANNEL_DOWN       | 167  |       |
| VOICE_ASSIST       | 499  |       |

These match the existing `android_keycodes.dart`.

---

## 4. Text Input

Text input uses a separate message type or can be sent as individual key events.

**Approach in official protocol:**

- Use `SYM` (symbol) input mechanism by sending `input text` command as a series of KEYCODE_UNKNOWN + text payload
- Alternatively, send each character as individual key event via INPUT messages

**Simpler approach (chosen):**

- Send text as individual `INPUT` messages per character
- Each character is sent as a PRESS action
- Special characters use modifier keys

**Alternative: Dedicated text input message**

- The Google TV remote protocol supports an `INPUT_TEXT` message type
- Payload: UTF-8 encoded string
- TV receives text and injects into focused text field

**Implementation choice:** Send as `INPUT` message with type=0x07 wrapping a UTF-8 string payload for efficiency. Fall back to per-character key events if text input mode not available.

---

## 5. Touch Input

The official Android TV Remote protocol supports relative and absolute pointer events.

**Touch message types:**

| Type | Name          | Description         |
| ---- | ------------- | ------------------- |
| 0x0B | `TOUCH_EVENT` | Touch event payload |

**Touch event payload:**

```
┌──────────┬──────────────────────────────┐
│  1 byte  │  Action (DOWN/MOVE/UP)       │
│  2 bytes │  X coordinate (big-endian)   │
│  2 bytes │  Y coordinate (big-endian)   │
│  2 bytes │  Pointer ID                  │
└──────────┴──────────────────────────────┘
```

**Touch action values:**

| Value | Action |
| ----- | ------ | ----------- |
| 0x00  | DOWN   |
| 0x01  | MOVE   |
| 0x02  | UP     |
| 0x03  | CLICK  | (DOWN + UP) |

---

## 6. Storage Schema (Hive)

| Box Name             | Key                      | Value                              |
| -------------------- | ------------------------ | ---------------------------------- |
| `paired_devices`     | `device_id` → `CertData` | TLS certificate + private key pair |
| `connection_history` | `last_connected`         | `device_id` of last connected TV   |
| `settings`           | `preferred_input_mode`   | `keyboard` / `touchpad` etc.       |

**CertData structure:**

```dart
@freezed
class CertData {
  String deviceId;
  String ipAddress;
  int port;
  Uint8List clientCertificate;  // DER-encoded
  Uint8List clientPrivateKey;   // DER-encoded
  Uint8List serverCertificate;  // DER-encoded
  DateTime pairedAt;
  String deviceName;            // Friendly name
}
```

---

## 7. Architecture Impact

### Current implementation (WRONG)

```
ADB-over-TCP → port 5555 → shell commands → requires USB/Wi-Fi debugging
```

### New implementation (CORRECT)

```
SSL/TLS-over-TCP → port 6466 → length-prefixed binary messages → certificate pairing → remote control
```

### Files to rewrite:

| File                                       | Change                                                |
| ------------------------------------------ | ----------------------------------------------------- |
| `android_tv_connection_manager.dart`       | Replace ADB socket with TLS socket + pairing protocol |
| `android_tv_driver.dart`                   | Remove ADB shell calls, use protocol messages         |
| `android_keycodes.dart`                    | Keep (key codes are correct)                          |
| Add: `android_tv_certificate_manager.dart` | Generate & persist self-signed certificates           |
| Add: `android_tv_protocol_handler.dart`    | Encode/decode length-prefixed protocol messages       |
| `pairing_datasource.dart`                  | Update to use TLS pairing flow                        |

### New dependencies needed:

None required - `web_socket_channel` already available, Dart `dart:io` has `SecureSocket` built-in.

---

## 8. Limitations

1. **Android TV OS version dependency**: Protocol version may vary across Android TV 9, 10, 11, 12, 14. The binary message format has been stable since Android TV 10+.
2. **Certificate storage**: Self-generated certificates must be stored securely. Hive is not encrypted by default; production should consider `flutter_secure_storage` for private keys.
3. **Multi-device**: The connection manager handles one active connection at a time.
4. **Firewall**: Port 6466 must be accessible on the local network. Android TV's `Remote control` setting must be enabled.
5. **TLS fingerprint**: The TV's self-signed certificate must be pinned after first pairing to prevent MITM.

---

## 9. Testing Strategy

| Scenario               | Method                                       |
| ---------------------- | -------------------------------------------- |
| Discovery              | Real Android TV + unit test with mock mDNS   |
| Pairing (PIN correct)  | Integration test with real TV                |
| Pairing (PIN wrong)    | Integration test with real TV                |
| Reconnection with cert | Store/restore certs, verify no new pairing   |
| Send command           | Send KEYCODE_HOME, verify TV goes home       |
| Text input             | Open search on TV, send text, verify display |
| Touch event            | Send touch DOWN+MOVE+UP, verify cursor moved |
| Disconnect / reconnect | Close socket, reopen, verify paired session  |
| Error handling         | Network down, wrong IP, TV off, timeout      |

---

## 10. References

- Android TV Remote Control Protocol: Based on reverse engineering of Google's `com.google.android.tv.remote.service` APK and the official Android TV Remote Control app
- Google's `nearby` library (used by Google TV app) for the newer Google TV protocol variant
- Chromecast Remote Protocol: Similar but uses different port (6450) and protobuf messages
