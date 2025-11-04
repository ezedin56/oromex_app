import 'package:flutter/material.dart';
import '../../../core/services/local_storage.dart';

class ThemeProvider with ChangeNotifier {
  final LocalStorage _localStorage = LocalStorage();

  ThemeMode _themeMode = ThemeMode.dark;
  bool _isLoading = false;

  ThemeMode get themeMode => _themeMode;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final savedTheme = await _localStorage.getThemeMode();
      if (savedTheme != null) {
        _themeMode = _parseThemeMode(savedTheme);
      }
    } catch (e) {
      print('Error loading theme: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _localStorage.saveThemeMode(_themeModeToString(mode));
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    await _localStorage.saveThemeMode(_themeModeToString(_themeMode));
    notifyListeners();
  }

  ThemeMode _parseThemeMode(String themeMode) {
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
