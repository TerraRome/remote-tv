# Architecture

## Overview

Feature-First Clean Architecture for Smart TV Remote application.

## Layer Structure

```
lib/
├── app/           # Application shell (bootstrap, router, theme)
├── core/          # Cross-cutting concerns (constants, errors, network, storage, logger, discovery, drivers)
├── di/            # Dependency injection (get_it + injectable)
├── features/      # Feature modules (discovery, pairing, remote, favorites, settings)
│   ├── data/      # Data sources, repositories, DTOs
│   ├── domain/    # Entities, use cases, repository interfaces
│   └── presentation/ # BLoC, pages, widgets
└── shared/        # Shared widgets, dialogs, models
```

## State Management

- flutter_bloc (one BLoC per feature)
- Cubit for simple state, Bloc for complex flows

## Dependency Injection

- get_it (service locator)
- injectable (code generation)
- All services annotated with @singleton, @lazySingleton, @factoryParam

## Routing

- go_router with declarative route configuration

## Local Storage

- Hive CE (Community Edition)
- Boxes: settings, paired_tvs, favorites, last_connected, tokens

## TV Driver System

- `abstract interface class TvDriver` — core driver contract
- `DriverRegistry` — resolves driver for a device, lists supported drivers
- `DriverRegistryImpl` — injectable implementation registered via `drivers_module`
- `AndroidTvDriver` — skeleton with capabilities declared, methods throw `DriverNotImplementedException`
- Driver models: `DriverCapability` (enum), `DriverInfo`, `DriverDevice`, `DriverConnection`, `DriverPairingSession`, `DriverTouchInput` (all freezed)
- `DriverException` hierarchy: `DriverNotImplementedException`, `DriverConnectionException`, `DriverPairingException`, `DriverCommandException`, `DriverDiscoveryException`
- SamsungTizenDriver (stub), LgWebOsDriver (stub), CoocaaDriver (stub) — planned

## Discovery

- `abstract interface class DiscoveryProvider` — abstraction for TV discovery
- `MdnsDiscoveryProvider`, `SsdpDiscoveryProvider`, `ManualDiscoveryProvider` — planned implementations
- `DiscoveryService` — merges all providers (planned)

## DI

- `@module` classes for each subsystem
- `drivers_module.dart` — registers `AndroidTvDriver`, driver list, and `DriverRegistry`
- `auto_register: false` in build.yaml — explicit module registration required
- `injection.dart` contains `@InjectableInit` entry point

## Code Generation

- injectable_generator (DI)
- freezed (immutable models)
- json_serializable (serialization)
- hive_ce_generator (type adapters)

## Theme

- Material 3
- Light + Dark mode
- Responsive (phone, tablet, landscape, portrait)
