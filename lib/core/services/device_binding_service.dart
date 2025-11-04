import '../utils/device_utils.dart';
import 'local_storage.dart';

class DeviceBindingService {
  final LocalStorage _localStorage = LocalStorage();

  Future<String> getDeviceFingerprint() async {
    // Try to get stored fingerprint first
    final storedFingerprint = await _localStorage.getDeviceFingerprint();
    if (storedFingerprint != null) {
      return storedFingerprint;
    }

    // Generate new fingerprint
    final newFingerprint = await DeviceUtils.generateDeviceFingerprint();
    await storeDeviceFingerprint(newFingerprint);

    return newFingerprint;
  }

  Future<void> storeDeviceFingerprint(String fingerprint) async {
    await _localStorage.saveDeviceFingerprint(fingerprint);
  }

  Future<void> clearDeviceFingerprint() async {
    await _localStorage.clearDeviceFingerprint();
  }

  Future<bool> verifyCurrentDevice() async {
    try {
      final storedFingerprint = await _localStorage.getDeviceFingerprint();
      if (storedFingerprint == null) return false;

      final currentFingerprint = await DeviceUtils.generateDeviceFingerprint();
      return storedFingerprint == currentFingerprint;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> getDeviceInfo() async {
    return await DeviceUtils.getDeviceInfo();
  }
}
