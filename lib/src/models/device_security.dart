abstract class DeviceSecurity {
  final bool? passcode;
  final bool? version;

  const DeviceSecurity({this.passcode, this.version});
}

class IOSDeviceSecurity extends DeviceSecurity {
  const IOSDeviceSecurity({super.passcode, super.version});

  @override
  String toString() {
    return 'IOSDeviceSecurity{passcode: $passcode, version: $version}';
  }
}

class AndroidDeviceSecurity extends DeviceSecurity {
  final bool? biometric;
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
