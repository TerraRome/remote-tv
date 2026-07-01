# Roadmap

## Milestone 1 - Project Audit

- [x] Analyze existing project
- [x] Document current state
- [x] Generate PROJECT_AUDIT.md

## Milestone 2 - Infrastructure Setup

- [x] Add dependencies
- [x] Create folder structure
- [x] Configure DI, Logger, Storage, Network
- [x] Update main.dart

## Milestone 3 - Domain Layer

- [x] Entities (TvDevice, TvConnection, PairingSession, TouchEvent)
- [x] Enums (RemoteCommand, ConnectionState, DiscoveryState)
- [x] Repository interfaces
- [x] Use cases

## Milestone 4 - Driver System

- [x] TvDriver abstract interface
- [x] DriverRegistry
- [x] AndroidTvDriver, Samsung, LG, Coocaa stubs

## Milestone 5 - Discovery Engine

- [x] DiscoveryProvider abstraction
- [x] mDNS, SSDP, Manual providers
- [x] DiscoveryService
- [x] DiscoveryRepository

## Milestone 6 - Discovery Feature

- [x] BLoC
- [x] UI (Loading, Empty, Error states)

## Milestone 7 - Android TV Driver

### M7.1 - Core Connection Transport ✅

- [x] SecureSocketTransport: `onBadCertificate` for TV self-signed certs
- [x] Proper error mapping (SocketException, HandshakeException, TimeoutException)
- [x] Dispose guard, permanent teardown
- [x] Connection state stream (`TvConnectionState`)

### M7.2a - Protocol Verification ✅

- [x] Binary framing verified (type+length header match)
- [x] Message types verified (all 9 codes present)
- [x] Key event format verified (uint32 keycode + uint32 action)
- [x] Touch event format: action wrong (uint32 vs uint16), coords wrong (scaled vs native pixels)

### M7.2b - Transport Reliability ✅

- [x] TCP reassembly (BytesBuilder, multi-frame, fragmented packets, buffer overflow guard)
- [x] sendAndWait race condition fixed (subscribe before send, cleanup on send error)

### M7.3 - Complete Driver

- [x] AndroidTvDriver: default port 6466 (remote protocol, not ADB)
- [x] Retry-safe connect (3 attempts, 2s delay)
- [x] Key event sending
- [x] Touch event sending
- [x] Text sending (char → keyCode)
- [x] DI registration order fix (split-cycle: `@lazySingleton` in `DriversModule`)

## Milestone 8 - Pairing Feature

- [ ] Pairing flow: missing server ack step + option/config exchange after confirm
- [ ] Certificate storage: missing cert pinning (onBadCertificate: true bypass)
- [ ] PIN flow (scaffolded)
- [ ] UI (scaffolded, needs real TLS)

## Milestone 9 - Remote Feature

- [x] BLoC
- [x] Volume, Power, DPad widgets (scaffolded, needs real connection)

## Milestone 10 - Favorites

- [ ] Hive storage, favorites UI

## Milestone 11 - Keyboard

- [ ] Send text, keyboard UI

## Milestone 12 - Touchpad

- [ ] Gestures, touch events (touch format needs fix first)

## Milestone 13 - LG Driver

- [ ] Stub → real implementation

## Milestone 14 - Samsung Driver

- [ ] Stub → real implementation

## Milestone 15 - Coocaa Driver

- [ ] Stub → real implementation

## Milestone 16 - Polish

- [ ] Performance, responsive, accessibility
- [ ] Animations, error handling
- [ ] Release preparation
