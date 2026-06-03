import 'package:flutter/material.dart';
import 'package:flutter_band_fit_app/core/constants/storage_keys.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();

  final Rx<ThemeMode> _themeMode = ThemeMode.light.obs;

  ThemeMode get theme => _themeMode.value;

  bool get isDark => _themeMode.value == ThemeMode.dark;

  @override
  void onInit() {
    super.onInit();
    _themeMode.value = _loadTheme() ? ThemeMode.dark : ThemeMode.light;
  }

  bool _loadTheme() => _box.read(darkModeKey) ?? false;

  void saveTheme(bool isDarkMode) => _box.write(darkModeKey, isDarkMode);

  void toggleTheme() {
    final next = isDark ? ThemeMode.light : ThemeMode.dark;
    setThemeMode(next);
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    saveTheme(mode == ThemeMode.dark);
    Get.changeThemeMode(mode);
  }

  void changeTheme(ThemeData theme) => Get.changeTheme(theme);

  void changeThemeMode(ThemeMode themeMode) => setThemeMode(themeMode);
}
