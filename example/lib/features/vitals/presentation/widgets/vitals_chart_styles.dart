import 'package:flutter/material.dart';

/// Theme-aware Syncfusion chart label styles for vitals detail screens.
abstract final class VitalsChartStyles {
  static TextStyle axisLabel(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 12,
      );

  /// Chart identity for a calendar day. [pointCount] forces Syncfusion to
  /// rebuild when async day data arrives or new readings are persisted.
  static String chartDayKey(String prefix, DateTime day, int pointCount) =>
      '$prefix-${day.year}-${day.month}-${day.day}-$pointCount';
}
