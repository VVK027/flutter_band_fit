import 'package:flutter_band_fit_app/common/common_imports.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  //final _key = 'isDarkMode';

  ThemeMode get theme => _loadTheme() ? ThemeMode.dark : ThemeMode.light;

  bool _loadTheme() => _box.read(darkModeKey) ?? false;

  void saveTheme(bool isDarkMode) => _box.write(darkModeKey, isDarkMode);

  void changeTheme(ThemeData theme) => Get.changeTheme(theme);

  void changeThemeMode(ThemeMode themeMode) => Get.changeThemeMode(themeMode);
}