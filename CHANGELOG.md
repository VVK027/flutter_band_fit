## 0.0.4

- Added dartdoc comments across `FlutterBandFit`, model classes, and `BandFitConstants` for improved API discoverability on pub.dev.
- Expanded unit tests for models, constants, and method-channel request/response handling.
- Added `debug_print_i` helper for opt-in plugin debug logging.
- README: GloryFit SDK context, example-app screenshots, BLE workflow diagram, and pub.dev install instructions.
- Example app: UI optimization and refactoring, auto-reconnect after unexpected GATT disconnects, activity sync fixes, and widget test keys.
- Removed the example macOS runner (Android and iOS remain supported).

## 0.0.3

- Documentation restructure for pub.dev: UTE/GloryFit SDK context, BLE workflow diagram, full implementation guide.
- Linked integration and API workflow guides from root README; removed internal example checklists.
- Added `homepage`, `repository`, `issue_tracker`, `documentation`, and `topics` to `pubspec.yaml`.

## 0.0.2

- Improved listener safety by guarding nullable subscriptions and adding plugin-level `dispose()` cleanup.
- Added a typo-safe alias `checkConnectionStatus()` while retaining `checkConectionStatus()` for compatibility.
- Hardened map decoding to safely handle both raw maps and JSON strings from platform channels.
- Refined model classes under `lib/src/models` to immutable, consistent `fromJson`/`toJson` patterns.
- Expanded example documentation with plugin integration and API workflow guides.

## 0.0.1

- Initial plugin implementation for UTE smart band connectivity and sync flows.
