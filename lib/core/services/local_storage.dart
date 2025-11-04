import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  LocalStorage()
    : _prefs = SharedPreferences.getInstance() as SharedPreferences;

  // Secure Storage Methods
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _secureStorage.write(key: 'user_data', value: jsonEncode(userData));
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final userData = await _secureStorage.read(key: 'user_data');
    if (userData != null) {
      return jsonDecode(userData) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> saveDeviceFingerprint(String fingerprint) async {
    await _secureStorage.write(key: 'device_fingerprint', value: fingerprint);
  }

  Future<String?> getDeviceFingerprint() async {
    return await _secureStorage.read(key: 'device_fingerprint');
  }

  // Shared Preferences Methods
  Future<void> saveThemeMode(String themeMode) async {
    await _prefs.setString('theme_mode', themeMode);
  }

  Future<String?> getThemeMode() async {
    return _prefs.getString('theme_mode');
  }

  Future<void> saveLanguage(String language) async {
    await _prefs.setString('app_language', language);
  }

  Future<String?> getLanguage() async {
    return _prefs.getString('app_language');
  }

  Future<void> saveExamProgress(
    String examId,
    Map<String, dynamic> progress,
  ) async {
    await _prefs.setString('exam_$examId', jsonEncode(progress));
  }

  Future<Map<String, dynamic>?> getExamProgress(String examId) async {
    final progress = _prefs.getString('exam_$examId');
    if (progress != null) {
      return jsonDecode(progress) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> savePaymentStatus(String status) async {
    await _prefs.setString('payment_status', status);
  }

  Future<String?> getPaymentStatus() async {
    return _prefs.getString('payment_status');
  }

  // Clear all data
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    await _prefs.clear();
  }

  // Specific clear methods
  Future<void> clearAuthData() async {
    await _secureStorage.delete(key: 'auth_token');
    await _secureStorage.delete(key: 'user_data');
  }

  Future<void> clearDeviceFingerprint() async {
    await _secureStorage.delete(key: 'device_fingerprint');
  }
}
