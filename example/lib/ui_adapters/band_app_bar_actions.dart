import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/core/constants/widget_keys.dart';
import 'package:flutter_band_fit_app/core/widgets/theme_toggle_button.dart';

List<Widget> bandAppBarActions() {
  return const [
    ThemeToggleButton(key: Key(WidgetKeys.themeToggleButton)),
  ];
}
