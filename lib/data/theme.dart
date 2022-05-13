import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_mode_handler/theme_mode_manager_interface.dart';

import 'colors.dart';

class ThemeModeManager implements IThemeModeManager {
  static const themeKey = 'theme_mode';

  @override
  Future<String?> loadThemeMode() async {
    final pref = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(milliseconds: 500));
    return pref.getString(themeKey);
  }

  @override
  Future<bool> saveThemeMode(String value) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(themeKey, value);
  }
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Vazir',
    brightness: Brightness.light,
    primarySwatch: Colors.amber,
    primaryColor: brandColor,
    scaffoldBackgroundColor: bgColor,
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Vazir',
    brightness: Brightness.dark,
    primarySwatch: Colors.amber,
    primaryColor: brandColor,
    scaffoldBackgroundColor: bgColor,
  );
}
