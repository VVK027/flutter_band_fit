## 0.0.2

- Improved listener safety by guarding nullable subscriptions and adding plugin-level `dispose()` cleanup.
- Added a typo-safe alias `checkConnectionStatus()` while retaining `checkConectionStatus()` for compatibility.
- Hardened map decoding to safely handle both raw maps and JSON strings from platform channels.
- Refined model classes under `lib/src/models` to immutable, consistent `fromJson`/`toJson` patterns.
- Expanded example documentation with plugin integration, API workflow, and optimization/maintenance guides.

## 0.0.1

- Initial plugin implementation for UTE smart band connectivity and sync flows.
