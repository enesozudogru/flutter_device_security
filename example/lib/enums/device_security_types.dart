import 'dart:io';

import 'package:flutter/material.dart';

enum DeviceSecurityTypes {
  passcode(label: 'Device Lock (PIN/Pattern/Password)', icon: Icons.lock),
  biometric(label: 'Biometric Authentication', icon: Icons.fingerprint),
  usbDebugging(label: 'USB Debugging', icon: Icons.usb),
  version(label: 'Device Version Updated', icon: Icons.system_update);

  final String label;
  final IconData icon;
  const DeviceSecurityTypes({required this.label, required this.icon});

  bool get show {
    switch (this) {
      case DeviceSecurityTypes.biometric:
      case DeviceSecurityTypes.usbDebugging:
        return Platform.isAndroid;
      default:
        return true;
    }
  }
}
