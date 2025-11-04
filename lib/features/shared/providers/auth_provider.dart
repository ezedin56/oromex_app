import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/local_storage.dart';
import '../../auth/domain/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final LocalStorage _localStorage;

  AuthProvider()
      : _authService = AuthService(),
        _localStorage = LocalStorage();

  User? _user;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String email, String password) async {
    try {
      _setLoading(true);
      _error = null;

      final user = await _authService.login(email, password);
      _user = user;
      _isAuthenticated = true;

      await _localStorage.saveUserData(user.toJson());
      await _localStorage.saveToken(user.token);

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String region,
    required String? languageStream,
    required String grade,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _error = null;

      final user = await _authService.register(
        name: name,
        email: email,
        phone: phone,
        region: region,
        languageStream: languageStream,
        grade: grade,
        password: password,
      );
      _user = user;
      _isAuthenticated = true;

      await _localStorage.saveUserData(user.toJson());
      await _localStorage.saveToken(user.token);

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      _setLoading(true);
      await _authService.logout();
      await _localStorage.clearAll();
      _user = null;
      _isAuthenticated = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      final token = await _localStorage.getToken();
      if (token != null) {
        final userData = await _localStorage.getUserData();
        if (userData != null) {
          _user = User.fromJson(userData);
          _isAuthenticated = true;
          notifyListeners();
        }
      }
    } catch (e) {
      await _localStorage.clearAll();
    }
  }

  Future<void> requestDeviceMigration() async {
    try {
      _setLoading(true);
      _error = null;

      // TODO: Implement actual device migration logic
      await Future.delayed(const Duration(seconds: 2));

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      _setLoading(true);
      _error = null;

      // TODO: Implement actual forgot password logic
      await Future.delayed(const Duration(seconds: 2));

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
