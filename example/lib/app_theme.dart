import 'common/common_imports.dart';

class Themes {
  static final lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: AppColors.lavender,
      onPrimary: Colors.black,
      secondary: AppColors.spaceBlue,
      onSecondary: AppColors.spaceCadet,
      background: AppColors.babyPink,
    ),
  );

  static final darkTheme = ThemeData(
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkGrey,
        secondary: AppColors.lightGrey,
        onSecondary: AppColors.lightGrey,
        background: AppColors.lightGrey,
      ));
}