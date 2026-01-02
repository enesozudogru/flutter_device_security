import 'dart:io';

import 'package:flutter_device_security/src/models/device_security.dart';
import 'package:flutter_device_security/src/services/api_service.dart';
import 'package:flutter_device_security/src/utils/version_utils.dart';

import 'flutter_device_security_platform_interface.dart';

class FlutterDeviceSecurity {
  final deviceSecurityInstance = FlutterDeviceSecurityPlatform.instance;
  Future<DeviceSecurity> checkDeviceSecurity({String? minimumVersion}) async {
    final hasPasscode = await deviceSecurityInstance.getHasPasscode();
    final versionChecked = await _checkDeviceVersion(minimumVersion: minimumVersion);

    if (Platform.isAndroid) {
      final hasBiometric = await deviceSecurityInstance.getHasBiometric();
      final hasUsbDebugging = await deviceSecurityInstance.getHasUsbDebugging();
      return AndroidDeviceSecurity(passcode: hasPasscode, biometric: hasBiometric, usbDebugging: hasUsbDebugging, version: versionChecked);
    }

    return IOSDeviceSecurity(passcode: hasPasscode, version: versionChecked);
  }

  Future<bool> _checkDeviceVersion({String? minimumVersion}) async {
    final apiService = ApiService();
    final currentVersion = await deviceSecurityInstance.checkDeviceVersion();
    if (currentVersion.isEmpty) {
      return true;
    }
    final latestVersion = await apiService.fetchLatestVersion();

    return VersionUtils.isVersionAtLeast(currentVersion, minimumVersion ?? latestVersion);
  }
}
