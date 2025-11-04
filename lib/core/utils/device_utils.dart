import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // Add this import
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class DeviceUtils {
  static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  static Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      if (kIsWeb) {
        final webInfo = await deviceInfo.webBrowserInfo;
        return {
          'platform': 'web',
          'browser': '${webInfo.browserName}',
          'userAgent': webInfo.userAgent,
        };
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return {
          'platform': 'android',
          'deviceId': androidInfo.id,
          'model': androidInfo.model,
          'brand': androidInfo.brand,
          'version': androidInfo.version.release,
          'sdkVersion': androidInfo.version.sdkInt.toString(),
        };
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return {
          'platform': 'ios',
          'deviceId': iosInfo.identifierForVendor,
          'model': iosInfo.model,
          'systemVersion': iosInfo.systemVersion,
          'name': iosInfo.name,
        };
      }
    } catch (e) {
      print('Error getting device info: $e');
    }
    return {'platform': 'unknown'};
  }

  static Future<String> generateDeviceFingerprint() async {
    final deviceInfo = await getDeviceInfo();

    final fingerprintData = {
      'platform': deviceInfo['platform'],
      'deviceId': deviceInfo['deviceId'],
      'model': deviceInfo['model'],
      'brand': deviceInfo['brand'],
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    return fingerprintData.toString().hashCode.toString();
  }

  static bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide > 600;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }
}
