import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';
import '../services/api_service.dart';

class AppUpdateChecker {
  final ApiService _apiService = ApiService();

  Future<AppUpdateInfo> checkForUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = Version.parse(packageInfo.version);

      final response = await _apiService.get('/api/app/update-check');
      final updateData = response['data'];

      final latestVersion = Version.parse(updateData['latest_version']);
      final isForceUpdate = updateData['force_update'] ?? false;
      final releaseNotes = updateData['release_notes'] ?? '';
      final storeUrl = updateData['store_url'] ?? '';

      return AppUpdateInfo(
        currentVersion: currentVersion,
        latestVersion: latestVersion,
        isUpdateAvailable: latestVersion > currentVersion,
        isForceUpdate: isForceUpdate,
        releaseNotes: releaseNotes,
        storeUrl: storeUrl,
      );
    } catch (e) {
      return AppUpdateInfo(
        currentVersion: Version(0, 0, 0),
        latestVersion: Version(0, 0, 0),
        isUpdateAvailable: false,
        isForceUpdate: false,
        releaseNotes: '',
        storeUrl: '',
      );
    }
  }
}

class AppUpdateInfo {
  final Version currentVersion;
  final Version latestVersion;
  final bool isUpdateAvailable;
  final bool isForceUpdate;
  final String releaseNotes;
  final String storeUrl;

  const AppUpdateInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.isUpdateAvailable,
    required this.isForceUpdate,
    required this.releaseNotes,
    required this.storeUrl,
  });

  String get currentVersionString => currentVersion.toString();
  String get latestVersionString => latestVersion.toString();
}
