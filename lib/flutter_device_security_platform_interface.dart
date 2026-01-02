import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_device_security_method_channel.dart';

/// Platform interface for Flutter Device Security plugin.
///
/// Defines the common interface for platform-specific implementations
/// of device security checking functionality.
abstract class FlutterDeviceSecurityPlatform extends PlatformInterface {
  /// Constructs a FlutterDeviceSecurityPlatform.
  FlutterDeviceSecurityPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterDeviceSecurityPlatform _instance =
      MethodChannelFlutterDeviceSecurity();

  /// The default instance of [FlutterDeviceSecurityPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterDeviceSecurity].
  static FlutterDeviceSecurityPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterDeviceSecurityPlatform] when
  /// they register themselves.
  static set instance(FlutterDeviceSecurityPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Checks the current device OS version.
  ///
  /// Returns the device OS version as a string.
  /// Returns empty string if version cannot be determined.
  Future<String> checkDeviceVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Checks if device has passcode/lock screen protection.
  ///
  /// Returns true if device has PIN, pattern, password or biometric lock.
  /// Returns false if device has no lock screen protection.
  Future<bool> getHasPasscode() {
    throw UnimplementedError('getHasPasscode() has not been implemented.');
  }

  /// Checks if biometric authentication is available (Android only).
  ///
  /// Returns true if fingerprint, face or other biometric authentication
  /// is available and can be used.
  /// Returns false if no biometric authentication is available.
  Future<bool> getHasBiometric() {
    throw UnimplementedError('getHasBiometric() has not been implemented.');
  }

  /// Checks if USB debugging is enabled (Android only).
  ///
  /// Returns true if USB debugging is enabled in developer options.
  /// Returns false if USB debugging is disabled.
  Future<bool> getHasUsbDebugging() {
    throw UnimplementedError('getHasUsbDebugging() has not been implemented.');
  }
}
