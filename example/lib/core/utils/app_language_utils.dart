import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Locale helpers for band language and OpenWeather `lang` query param.
class AppLanguageUtils {
  AppLanguageUtils._();

  static String get languageCode {
    final locale = Get.locale ?? const Locale('en');
    final code = locale.languageCode.trim();
    return code.isEmpty ? 'en' : code;
  }

  static String get bandLanguageCode => languageCode;

  static Future<String> getLanguage() async => languageCode;
}
