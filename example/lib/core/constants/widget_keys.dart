import 'package:flutter/widgets.dart';

/// Stable keys for stateful widgets that must keep state across rebuilds.
abstract final class WidgetKeys {
  static const batteryIndicator = ValueKey<String>('device_settings_battery_indicator');
}
