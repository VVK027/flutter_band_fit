# Plugin optimization and maintenance

This document captures practical guidance for keeping `flutter_band_fit` stable, efficient, and easy to evolve.

## Runtime efficiency checklist

- Use a single `FlutterBandFit` instance per app lifecycle.
- Register stream listeners only when needed, then call `dispose()` or cancel listener subscriptions when views are closed.
- Avoid repetitive sync calls; gate sync by connectivity checks (`checkConnectionStatus()`).
- Cache or persist expensive fetch results in app state rather than refetching every navigation.

## API hygiene checklist

- Keep response parsing centralized in helper methods (for status and JSON map decoding).
- Prefer typed aliases for callback signatures (`BandDataCallback`, `BandErrorCallback`) instead of raw function types.
- Add backward-compatible aliases when fixing public API naming issues.
- Preserve wire-format JSON keys for platform interoperability even if Dart field names are modernized.

## Error-handling checklist

- Treat method-channel results as untrusted runtime values.
- If map parsing fails, return empty maps and fail gracefully in UI/repository layers.
- Handle status responses explicitly: `success`, `failure`, `disconnected`, `canceled`, `initiated`.
- Wrap reconnect-and-retry flows for transient BLE interruptions.

## Release maintenance checklist

Before releasing:

1. Run `dart format lib`.
2. Run `flutter analyze lib`.
3. Update:
   - `CHANGELOG.md` with API and behavior changes.
   - `example/docs/plugin/*` if integration behavior or APIs changed.
   - Root `README.md` if setup/usage changed.
4. Verify Android and iOS example app bootstrap still succeeds.
