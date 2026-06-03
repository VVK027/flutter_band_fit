import 'package:flutter/material.dart';

/// Theme extension for vitals/chart colors that stay consistent in light & dark.
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.cardElevation,
    required this.vitalIconSize,
    required this.chartBackground,
    required this.subtitleColor,
  });

  final double cardElevation;
  final double vitalIconSize;
  final Color chartBackground;
  final Color subtitleColor;

  static const light = AppThemeExtension(
    cardElevation: 1,
    vitalIconSize: 40,
    chartBackground: Color(0xFFF1F5F9),
    subtitleColor: Color(0xFF64748B),
  );

  static const dark = AppThemeExtension(
    cardElevation: 0,
    vitalIconSize: 40,
    chartBackground: Color(0xFF252836),
    subtitleColor: Color(0xFF94A3B8),
  );

  @override
  AppThemeExtension copyWith({
    double? cardElevation,
    double? vitalIconSize,
    Color? chartBackground,
    Color? subtitleColor,
  }) {
    return AppThemeExtension(
      cardElevation: cardElevation ?? this.cardElevation,
      vitalIconSize: vitalIconSize ?? this.vitalIconSize,
      chartBackground: chartBackground ?? this.chartBackground,
      subtitleColor: subtitleColor ?? this.subtitleColor,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      cardElevation: cardElevation,
      vitalIconSize: vitalIconSize,
      chartBackground: Color.lerp(chartBackground, other.chartBackground, t)!,
      subtitleColor: Color.lerp(subtitleColor, other.subtitleColor, t)!,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>() ?? AppThemeExtension.light;
}
