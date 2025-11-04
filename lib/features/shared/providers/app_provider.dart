import 'package:flutter/material.dart';
import '../../../core/services/local_storage.dart';

class AppProvider with ChangeNotifier {
  final LocalStorage _localStorage = LocalStorage();

  String _currentLanguage = 'en';
  bool _isInitialized = false;
  String? _error;

  String get currentLanguage => _currentLanguage;
  bool get isInitialized => _isInitialized;
  String? get error => _error;

  Future<void> initializeApp() async {
    try {
      // Load saved preferences
      final savedLanguage = await _localStorage.getLanguage();
      if (savedLanguage != null) {
        _currentLanguage = savedLanguage;
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    _currentLanguage = languageCode;
    await _localStorage.saveLanguage(languageCode);
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
