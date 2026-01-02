/// Abstract base class for device security information.
///
/// Contains common security properties available on all platforms.
abstract class DeviceSecurity {
  /// Whether the device has a lock screen protection (PIN, pattern, password).
  final bool? passcode;

  /// Whether the device OS version meets the minimum requirements.
  final bool? version;

  const DeviceSecurity({this.passcode, this.version});
}

/// iOS-specific device security information.
///
/// Contains security properties specific to iOS devices.
class IOSDeviceSecurity extends DeviceSecurity {
  const IOSDeviceSecurity({super.passcode, super.version});

  @override
  String toString() {
    return 'IOSDeviceSecurity{passcode: $passcode, version: $version}';
  }
}

/// Android-specific device security information.
///
/// Contains additional security properties available on Android devices
/// including biometric authentication and developer options.
class AndroidDeviceSecurity extends DeviceSecurity {
  /// Whether biometric authentication (fingerprint, face, etc.) is available.
  final bool? biometric;

  /// Whether USB debugging is enabled in developer options.
  final bool? usbDebugging;

  const AndroidDeviceSecurity({
    super.passcode,
    super.version,
    this.biometric,
    this.usbDebugging,
  });

  @override
  String toString() {
    return 'AndroidDeviceSecurity{passcode: $passcode, version: $version, biometric: $biometric, usbDebugging: $usbDebugging}';
  }
}
