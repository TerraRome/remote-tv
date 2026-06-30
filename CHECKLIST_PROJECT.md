# Remote TV (Xiaomi Android TV)

## Phase 1 — Foundation

### Project

- [x] Flutter 3.41.3
- [x] Feature First Architecture
- [x] Clean Architecture
- [x] flutter_bloc
- [x] get_it + injectable
- [x] freezed
- [x] Hive CE
- [x] build_runner

### Infrastructure

- [x] Driver System
- [x] Discovery System
- [x] Android TV Constants
- [x] Storage Keys
- [x] Certificate Manager
- [x] Connection Manager
- [x] Protocol Handler
- [x] Secure Socket (real TLS with self-signed certs)
- [x] Logger
- [x] Network Layer

---

# Phase 2 — Discovery

## mDNS

- [x] Browse `_androidtvremote._tcp.local`
- [x] Resolve hostname
- [x] Resolve IPv4
- [x] Resolve port
- [x] Resolve device id
- [x] Resolve friendly name
- [x] Resolve manufacturer
- [x] Filter Android TV only
- [ ] Discovery timeout
- [ ] Refresh discovery

## Repository

- [x] DiscoveryRepository complete
- [x] DiscoveryDatasource complete
- [x] Mapper complete

## Bloc

- [x] DiscoveryBloc complete
- [x] Loading state
- [x] Success state
- [x] Error state

## UI

- [x] Discovery page
- [x] TV list
- [x] Empty state
- [x] Error state
- [x] Refresh button
- [ ] Scan animation (placeholder)

---

# Phase 3 — Pairing

## TLS

- [x] TLS connection (real, with onBadCertificate for self-signed TV certs)
- [x] Certificate exchange (scaffolded)
- [x] Pairing request (scaffolded)
- [x] Pairing PIN (scaffolded)
- [x] Pairing success (scaffolded)
- [x] Save certificate (scaffolded)
- [x] Connection state stream (TvConnectionState)
- [x] Retry-safe connect (3 attempts, 2s delay)
- [x] Default port 6466 (not ADB 5555)
- [ ] Auto reconnect

## UI

- [x] PIN dialog
- [x] Pairing status
- [x] Retry

---

# Phase 4 — Remote MVP

## Commands

- [x] Home
- [x] Back
- [x] OK
- [x] DPad Up
- [x] DPad Down
- [x] DPad Left
- [x] DPad Right
- [x] Volume +
- [x] Volume -
- [x] Mute
- [x] Power (if supported)

## Bloc

- [x] RemoteBloc
- [x] Connection status
- [x] Error handling

## UI

- [x] Remote page
- [x] DPad
- [x] Volume bar
- [x] Home button
- [x] Back button
- [x] Channel buttons
- [x] Touchpad widget

---

# Phase 5 — Keyboard

- [ ] Text input UI
- [x] Send text use case
- [ ] IME support

---

# Phase 6 — Touchpad

- [x] TouchEvent entity
- [x] Send touch use case
- [x] Touchpad widget (scaffolded)
- [ ] Real gesture handling

---

# Phase 7 — Polish

- [x] Favorites BLoC
- [x] Favorites page
- [x] Favorites datasource
- [x] Remember paired TVs (scaffolded)
- [ ] Auto reconnect
- [ ] Better animations
- [ ] Material 3 polish
- [ ] Tablet layout
- [ ] Error handling pass
- [ ] Logging cleanup

---

# Release

- [ ] Works on Xiaomi TV
- [ ] Works on Google TV
- [ ] Stable discovery
- [ ] Stable pairing
- [ ] Stable remote
- [ ] No analyzer errors
- [ ] No TODO
- [ ] Production Ready
