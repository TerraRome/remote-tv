# Current State Assessment

## Analyzed: 2026-06-30

### Critical Fix — M7.2c: mDNS Discovery hangs forever

#### Root cause

`MdnsDiscoveryProvider._doDiscovery` used `await for` on `_client!.lookup<PtrResourceRecord>()`.
This stream **never closes** when no matching mDNS services respond — the call hangs indefinitely
and no devices are ever emitted. Same issue in `_resolveDevice` for SRV, TXT, and IP lookups.

#### Fix

- PTR lookup: 5s timeout (`_ptrTimeout`)
- Each DNS resolution step (SRV, TXT, IPv4, IPv6): 3s timeout (`_resolveTimeout`)
- Added `_googlecast._tcp.local` as fallback service type
- IP-based deduplication to prevent duplicates
- Graceful `TimeoutException` handling — yields nothing instead of crashing

#### Impact

Zero false alarm on non-Android TV networks. Under 8s total wait before giving up.
Previously: infinite spinner.

### Infrastructure — Done

- [x] Flutter 3.41.3 + FVM
- [x] Feature-First Clean Architecture
- [x] DI (get_it + injectable)
- [x] Logger, Storage, Network layers
- [x] Driver system (TvDriver, DriverRegistry, 4 drivers)
- [x] Discovery engine (mDNS, SSDP, Manual + Service)
- [x] GoRouter routing + Material 3 theme
- [x] Freezed models + JSON serialization

### Domain — Done

- [x] All entities (TvDevice, TvConnection, PairingSession, TouchEvent)
- [x] All enums (RemoteCommand, ConnectionState, DiscoveryState)
- [x] All repo interfaces
- [x] All use cases

### Features — Done (scaffolded)

- [x] Discovery BLoC + UI (loading, empty, error, list)
- [x] Pairing BLoC + UI (PIN dialog, status, retry)
- [x] Remote BLoC + UI (DPad, volume, power, channel)
- [x] Favorites BLoC + page stub

### Features — Not Done (needs real implementation)

- [x] M7.1: Transport layer (real TLS with self-signed certs, connection state stream, retry)
- [x] M7.2a: Protocol verification (framing, types, key event format match; touch format mismatch)
- [x] M7.2b: Transport reliability (TCP reassembly, sendAndWait race condition fixed)
- [x] M7.3: Driver commands (key event, touch, text; default port 6466)
- [ ] M7.2c (remaining): Pairing protocol (certificate pinning, PIN code flow, server ack step, post-pairing exchange)
- [ ] M10: Favorites Hive persistence
- [ ] M11: Keyboard UI + send text
- [ ] M12: Touchpad real gestures
- [ ] M13-15: LG/Samsung/Coocaa real drivers
- [ ] M16: Polish (responsive, animations, error handling)

### Compile Status

- `flutter analyze`: **0 errors**, 0 warnings, 4 info (super params style)
- `flutter pub get`: OK
- `build_runner`: config present, generated files exist

### Next Priority

**Milestone 7** — Real Android TV driver communication.
Unblocks entire remote-control functionality.
