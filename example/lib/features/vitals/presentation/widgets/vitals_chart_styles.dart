import 'package:flutter/material.dart';

/// Theme-aware Syncfusion chart label styles for vitals detail screens.
abstract final class VitalsChartStyles {
  static TextStyle axisLabel(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 12,
      );
}
