import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _themeKey = 'theme_mode';
  static ValueNotifier<ThemeMode> themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);
  
  /// Initialize theme service - load saved theme
  static Future<void> initialize() async {
    final themeMode = await getThemeMode();
    themeNotifier.value = themeMode;
  }
  
  /// Get the saved theme mode from SharedPreferences
  static Future<ThemeMode> getThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeString = prefs.getString(_themeKey);
      
      if (themeModeString == null) {
        return ThemeMode.system; // Default to system theme
      }
      
      switch (themeModeString) {
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        case 'system':
        default:
          return ThemeMode.system;
      }
    } catch (e) {
      print('Error getting theme mode: $e');
      return ThemeMode.system;
    }
  }
  
  /// Save the theme mode to SharedPreferences and notify listeners
  static Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String themeModeString;
      
      switch (themeMode) {
        case ThemeMode.light:
          themeModeString = 'light';
          break;
        case ThemeMode.dark:
          themeModeString = 'dark';
          break;
        case ThemeMode.system:
        default:
          themeModeString = 'system';
          break;
      }
      
      await prefs.setString(_themeKey, themeModeString);
      themeNotifier.value = themeMode;
      print('✅ Theme mode saved: $themeModeString');
    } catch (e) {
      print('Error saving theme mode: $e');
    }
  }
}

