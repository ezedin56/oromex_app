// import 'api_service.dart';
// import 'local_storage.dart';
// import 'device_binding_service.dart';
// import '../../features/auth/domain/models/user_model.dart';

// class AuthService {
//   final ApiService _apiService = ApiService();
//   final LocalStorage _localStorage = LocalStorage();
//   final DeviceBindingService _deviceBindingService = DeviceBindingService();

//   Future<User> login(String email, String password) async {
//     final deviceFingerprint =
//         await _deviceBindingService.getDeviceFingerprint();

//     final response = await _apiService.post('/api/auth/login', {
//       'email': email,
//       'password': password,
//       'device_fingerprint': deviceFingerprint,
//     });

//     final user = User.fromJson(response['data']['user']);
//     user.token = response['data']['token'];

//     // Store device fingerprint
//     await _deviceBindingService.storeDeviceFingerprint(deviceFingerprint);

//     return user;
//   }

//   Future<User> register({
//     required String name,
//     required String email,
//     required String phone,
//     required String region,
//     required String? languageStream,
//     required String grade,
//     required String password,
//   }) async {
//     final deviceFingerprint =
//         await _deviceBindingService.getDeviceFingerprint();

//     final response = await _apiService.post('/api/auth/register', {
//       'name': name,
//       'email': email,
//       'phone': phone,
//       'region': region,
//       'language_stream': languageStream,
//       'grade': grade,
//       'password': password,
//       'device_fingerprint': deviceFingerprint,
//     });

//     final user = User.fromJson(response['data']['user']);
//     user.token = response['data']['token'];

//     // Store device fingerprint
//     await _deviceBindingService.storeDeviceFingerprint(deviceFingerprint);

//     return user;
//   }

//   Future<void> logout() async {
//     try {
//       await _apiService.post('/api/auth/logout', {});
//     } finally {
//       await _localStorage.clearAll();
//       await _deviceBindingService.clearDeviceFingerprint();
//     }
//   }

//   Future<void> forgotPassword(String email) async {
//     await _apiService.post('/api/auth/forgot-password', {'email': email});
//   }

//   Future<void> resetPassword(String token, String newPassword) async {
//     await _apiService.post('/api/auth/reset-password', {
//       'token': token,
//       'password': newPassword,
//     });
//   }

//   Future<bool> verifyDevice(String deviceFingerprint) async {
//     try {
//       await _apiService.post('/api/auth/verify-device', {
//         'device_fingerprint': deviceFingerprint,
//       });
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<void> requestDeviceMigration() async {
//     await _apiService.post('/api/auth/request-device-migration', {});
//   }
// }

import 'api_service.dart';
import 'local_storage.dart';
import 'device_binding_service.dart';
import '../../features/auth/domain/models/user_model.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final LocalStorage _localStorage = LocalStorage();
  final DeviceBindingService _deviceBindingService = DeviceBindingService();

  Future<User> login(String email, String password) async {
    try {
      final deviceFingerprint =
          await _deviceBindingService.getDeviceFingerprint();

      final response = await _apiService.post('/api/auth/login', {
        'email': email.trim(),
        'password': password,
        'device_fingerprint': deviceFingerprint,
      });

      // Merge token into user data before creating User object
      final userData = Map<String, dynamic>.from(response['data']['user']);
      userData['token'] = response['data']['token'];

      final user = User.fromJson(userData);

      // Store device fingerprint and user data
      await _deviceBindingService.storeDeviceFingerprint(deviceFingerprint);
      await _storeUserData(user);

      return user;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<User> register({
    required String name,
    required String email,
    required String phone,
    required String region,
    required String? languageStream,
    required String grade,
    required String password,
  }) async {
    try {
      final deviceFingerprint =
          await _deviceBindingService.getDeviceFingerprint();

      final response = await _apiService.post('/api/auth/register', {
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'region': region,
        'language_stream': languageStream,
        'grade': grade,
        'password': password,
        'device_fingerprint': deviceFingerprint,
      });

      // Merge token into user data before creating User object
      final userData = Map<String, dynamic>.from(response['data']['user']);
      userData['token'] = response['data']['token'];

      final user = User.fromJson(userData);

      // Store device fingerprint and user data
      await _deviceBindingService.storeDeviceFingerprint(deviceFingerprint);
      await _storeUserData(user);

      return user;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      final token = await _localStorage.getString('user_token');
      if (token != null && token.isNotEmpty) {
        await _apiService.post(
          '/api/auth/logout',
          {},
          headers: {'Authorization': 'Bearer $token'},
        );
      }
    } catch (e) {
      print('Logout API call failed: $e');
    } finally {
      await _localStorage.clearAll();
      await _deviceBindingService.clearDeviceFingerprint();
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _apiService.post('/api/auth/forgot-password', {
        'email': email.trim(),
      });
    } catch (e) {
      throw Exception('Password reset request failed: ${e.toString()}');
    }
  }

  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await _apiService.post('/api/auth/reset-password', {
        'token': token,
        'password': newPassword,
      });
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  Future<bool> verifyDevice(String deviceFingerprint) async {
    try {
      await _apiService.post('/api/auth/verify-device', {
        'device_fingerprint': deviceFingerprint,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> requestDeviceMigration() async {
    try {
      final token = await _localStorage.getString('user_token');
      if (token != null && token.isNotEmpty) {
        await _apiService.post(
          '/api/auth/request-device-migration',
          {},
          headers: {'Authorization': 'Bearer $token'},
        );
      } else {
        throw Exception('No authentication token found');
      }
    } catch (e) {
      throw Exception('Device migration request failed: ${e.toString()}');
    }
  }

  // Token and user data management
  Future<void> _storeUserData(User user) async {
    try {
      await _localStorage.saveString('user_token', user.token);
      await _localStorage.saveString('user_data', json.encode(user.toJson()));
    } catch (e) {
      throw Exception('Failed to store user data: ${e.toString()}');
    }
  }

  Future<User?> getStoredUser() async {
    try {
      final token = await _localStorage.getString('user_token');
      final userData = await _localStorage.getString('user_data');

      if (token == null || token.isEmpty || userData == null) return null;

      final userJson = json.decode(userData);
      return User.fromJson(userJson);
    } catch (e) {
      print('Error parsing stored user data: $e');
      // Clear corrupted data
      await _localStorage.remove('user_token');
      await _localStorage.remove('user_data');
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final token = await _localStorage.getString('user_token');
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getToken() async {
    try {
      return await _localStorage.getString('user_token');
    } catch (e) {
      return null;
    }
  }
}
