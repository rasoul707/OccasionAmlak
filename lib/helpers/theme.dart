import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_mode_handler/theme_mode_manager_interface.dart';

import '../data/colors.dart';

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
  static const fontFamily = 'Vazir';

  static final textTheme = const TextTheme(
    bodyLarge: TextStyle(),
    bodyMedium: TextStyle(),
    bodySmall: TextStyle(),
    //
    headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
    titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700),

    headlineMedium: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700),
    titleMedium: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
    labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
    labelMedium: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
  ).apply(
    bodyColor: textColor,
    displayColor: textColor,
    fontFamily: fontFamily,
  );

  static const inputDecTheme = InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    filled: true,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(50),
      ),
    ),
    fillColor: textFieldBgColor,
    focusColor: textColor,
    labelStyle: TextStyle(
      color: textColor,
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 25),
  );

  static final cardTheme = CardTheme(
    color: textFieldBgColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    fontFamily: fontFamily,
    brightness: Brightness.light,
    primarySwatch: Colors.amber,
    primaryColor: brandColor,
    scaffoldBackgroundColor: bgColor,
    textTheme: textTheme,
    inputDecorationTheme: inputDecTheme,
    cardTheme: cardTheme,
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: fontFamily,
    brightness: Brightness.light,
    primarySwatch: Colors.amber,
    primaryColor: brandColor,
    scaffoldBackgroundColor: bgColor,
    textTheme: textTheme,
    inputDecorationTheme: inputDecTheme,
    cardTheme: cardTheme,
  );
}
