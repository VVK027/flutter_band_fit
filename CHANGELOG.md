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
