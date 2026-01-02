/// A Flutter plugin for checking device security features.
///
/// This library provides functionality to verify various security aspects
/// of the user's device including device lock, biometric authentication,
/// USB debugging status, and OS version validation.
library;

import 'dart:io';

import 'package:flutter_device_security/src/models/device_security.dart';
import 'package:flutter_device_security/src/services/api_service.dart';
import 'package:flutter_device_security/src/utils/version_utils.dart';

import 'flutter_device_security_platform_interface.dart';

/// Main class for performing device security checks.
///
/// Provides methods to verify device lock status, biometric availability,
/// USB debugging status (Android), and OS version compliance.
class FlutterDeviceSecurity {
  /// Platform interface instance for accessing native security features.
  final deviceSecurityInstance = FlutterDeviceSecurityPlatform.instance;

  /// Performs comprehensive device security checks.
  ///
  /// Returns [AndroidDeviceSecurity] on Android devices with additional
  /// checks for biometric authentication and USB debugging.
  /// Returns [IOSDeviceSecurity] on iOS devices with basic security checks.
  ///
  /// [minimumVersion] - Optional minimum OS version to validate against.
  /// If not provided, uses the latest version from remote API.
  ///
  /// Throws [Exception] if security check fails or network error occurs.
  Future<DeviceSecurity> checkDeviceSecurity({String? minimumVersion}) async {
    final hasPasscode = await deviceSecurityInstance.getHasPasscode();
    final versionChecked = await _checkDeviceVersion(
      minimumVersion: minimumVersion,
    );

    if (Platform.isAndroid) {
      final hasBiometric = await deviceSecurityInstance.getHasBiometric();
      final hasUsbDebugging = await deviceSecurityInstance.getHasUsbDebugging();
      return AndroidDeviceSecurity(
        passcode: hasPasscode,
        biometric: hasBiometric,
        usbDebugging: hasUsbDebugging,
        version: versionChecked,
      );
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

    return VersionUtils.isVersionAtLeast(
      currentVersion,
      minimumVersion ?? latestVersion,
    );
  }
}
