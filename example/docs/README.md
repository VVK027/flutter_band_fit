# Example app documentation

Documentation for the `flutter_band_fit` **plugin** and the **example** reference app (`flutter_band_fit_app`).

## About the plugin

- Targets **UTE smart band / fitness watch** devices over BLE.
- Wraps the native **UTE SDK** (the same SDK family as **GloryFit** on many OEM bands).
- Provides a **single Flutter API** over separate Android (`ute_sdk`) and iOS (`UTESmartBandApi`) implementations.

A **full reference implementation** (pairing, sync, vitals UI, settings, dial, firmware, health export) ships in the `example/` package — not only API stubs.

## Plugin integration (start here)

| Document | Description |
| -------- | ----------- |
| [Full implementation guide](plugin/full-implementation-guide.md) | End-to-end workflow, architecture, example app map |
| [Plugin integration guide](plugin/plugin-integration-guide.md) | Step-by-step integration for new apps |
| [Plugin API workflow reference](plugin/plugin-api-workflow.md) | `FlutterBandFit` methods by category |

## Example app architecture

| Document | Description |
| -------- | ----------- |
| [Feature-first clean architecture](architecture/clean-architecture.md) | Layers and feature layout |
| [Dependency rules](architecture/dependency-rules.md) | Import and boundary rules |
| [Feature template](architecture/feature-template.md) | Scaffold for new features |
| [ARCHITECTURE.md](../ARCHITECTURE.md) | High-level example overview |

## Changelog

- [CHANGELOG.md](../../CHANGELOG.md) — plugin version history

## Recommended reading order

1. [Full implementation guide](plugin/full-implementation-guide.md)
2. [Plugin integration guide](plugin/plugin-integration-guide.md)
3. [Plugin API workflow reference](plugin/plugin-api-workflow.md)
4. Run and explore `example/` (see [example/README.md](../README.md))
5. [ARCHITECTURE.md](../ARCHITECTURE.md) when extending the demo app
