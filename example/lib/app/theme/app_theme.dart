import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/app/theme/app_colors.dart';
import 'package:flutter_band_fit_app/app/theme/app_theme_extension.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _base(Brightness.light);
  static ThemeData get dark => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = isDark
        ? const ColorScheme.dark(
            primary: AppColors.primaryTealDark,
            onPrimary: AppColors.slate900,
            secondary: AppColors.accentBlue,
            onSecondary: Colors.white,
            surface: AppColors.lightGrey,
            onSurface: Color(0xFFE2E8F0),
            surfaceContainerHighest: Color(0xFF363A4F),
          )
        : const ColorScheme.light(
            primary: AppColors.primaryTeal,
            onPrimary: Colors.white,
            secondary: AppColors.slate800,
            onSecondary: Colors.white,
            surface: Colors.white,
            onSurface: AppColors.slate900,
            surfaceContainerHighest: AppColors.slate100,
          );

    final textTheme = Typography.material2021().black.apply(
          bodyColor: isDark ? const Color(0xFFCBD5E1) : AppColors.gunMetal,
          displayColor: isDark ? Colors.white : AppColors.slate900,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? AppColors.darkGrey : AppColors.slate50,
      cardColor: isDark ? AppColors.lightGrey : Colors.white,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: isDark ? AppColors.lightGrey : Colors.white,
        foregroundColor: isDark ? Colors.white : AppColors.slate900,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : AppColors.slate900,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: isDark ? 0 : 1,
        color: isDark ? AppColors.lightGrey : Colors.white,
        margin: const EdgeInsets.all(4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerColor: isDark ? Colors.white24 : const Color(0xFFE2E8F0),
      textTheme: textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.55),
        indicatorColor: colorScheme.primary,
        indicatorSize: TabBarIndicatorSize.label,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        modalBackgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return isDark ? Colors.grey.shade400 : Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary.withValues(alpha: 0.45);
          }
          return isDark ? Colors.white24 : Colors.black12;
        }),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      extensions: [isDark ? AppThemeExtension.dark : AppThemeExtension.light],
    );
  }
}

/// Back-compat alias used by legacy imports.
typedef Themes = AppTheme;
