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

- [ ] Entities (TvDevice, TvConnection, PairingSession, TouchEvent)
- [ ] Enums (RemoteCommand, ConnectionState, DiscoveryState)
- [ ] Repository interfaces
- [ ] Use cases

## Milestone 4 - Driver System

- [ ] TvDriver abstract interface
- [ ] DriverRegistry
- [ ] AndroidTvDriver, Samsung, LG, Coocaa stubs

## Milestone 5 - Discovery Engine

- [ ] DiscoveryProvider abstraction
- [ ] mDNS, SSDP, Manual providers
- [ ] DiscoveryService
- [ ] DiscoveryRepository

## Milestone 6 - Discovery Feature

- [ ] BLoC
- [ ] UI (Loading, Empty, Error states)

## Milestone 7 - Android TV Driver

- [ ] Real connection, pairing, command sending

## Milestone 8 - Pairing Feature

- [ ] PIN flow, BLoC, UI

## Milestone 9 - Remote Feature

- [ ] Volume, Power, DPad, etc.

## Milestone 10 - Favorites

- [ ] Hive storage, favorites UI

## Milestone 11 - Keyboard

- [ ] Send text, keyboard UI

## Milestone 12 - Touchpad

- [ ] Gestures, touch events

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
