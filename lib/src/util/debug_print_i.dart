part of '../../flutter_band_fit.dart';

/// Debug-only logging helper; stripped in release builds via [kDebugMode].
void debugPrintI(Object? message) {
  if (kDebugMode) {
    debugPrint(message?.toString());
  }
}
