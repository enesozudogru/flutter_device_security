# Flutter Device Security

[![pub package](https://img.shields.io/pub/v/flutter_device_security.svg)](https://pub.dev/packages/flutter_device_security)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A comprehensive Flutter plugin for checking device security features across Android and iOS platforms. This plugin helps you verify various security aspects of the user's device to ensure a secure environment for your application.

## Features

- 🔒 **Device Lock Detection**: Check if the device has a passcode, PIN, pattern, or password set
- 👆 **Biometric Authentication** (Android): Verify if biometric authentication is available and enabled
- 🔧 **USB Debugging Detection** (Android): Check if USB debugging is enabled
- 📱 **Device Version Verification**: Validate if the device OS version meets minimum requirements
- 🎯 **Platform-Specific**: Optimized for both Android and iOS with platform-appropriate checks
- 🚀 **Easy Integration**: Simple API with comprehensive error handling

## Supported Platforms

| Feature | Android | iOS |
|---------|---------|-----|
| Device Lock (PIN/Pattern/Password) | ✅ | ✅ |
| Biometric Authentication | ✅ | ❌ |
| USB Debugging Detection | ✅ | ❌ |
| Device Version Verification | ✅ | ✅ |

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_device_security: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Usage

```dart
import 'package:flutter_device_security/flutter_device_security.dart';

class MySecurityCheck {
  final flutterDeviceSecurity = FlutterDeviceSecurity();
  
  Future<void> checkDeviceSecurity() async {
    try {
      final deviceSecurity = await flutterDeviceSecurity.checkDeviceSecurity();
      
      print('Has Passcode: ${deviceSecurity.passcode}');
      print('Version OK: ${deviceSecurity.version}');
      
      // Android-specific checks
      if (deviceSecurity is AndroidDeviceSecurity) {
        print('Has Biometric: ${deviceSecurity.biometric}');
        print('USB Debugging: ${deviceSecurity.usbDebugging}');
      }
    } catch (e) {
      print('Error checking device security: $e');
    }
  }
}
```

### Advanced Usage with Minimum Version

```dart
Future<void> checkDeviceSecurityWithMinVersion() async {
  try {
    final deviceSecurity = await flutterDeviceSecurity.checkDeviceSecurity(
      minimumVersion: "10.0", // Specify minimum OS version
    );
    
    // Handle the results...
  } catch (e) {
    print('Error: $e');
  }
}
```

### Complete Example with UI

```dart
import 'package:flutter/material.dart';
import 'package:flutter_device_security/flutter_device_security.dart';
import 'package:flutter_device_security/src/models/device_security.dart';

class SecurityCheckScreen extends StatefulWidget {
  @override
  _SecurityCheckScreenState createState() => _SecurityCheckScreenState();
}

class _SecurityCheckScreenState extends State<SecurityCheckScreen> {
  final flutterDeviceSecurity = FlutterDeviceSecurity();
  DeviceSecurity? deviceSecurity;
  bool isLoading = false;

  Future<void> performSecurityCheck() async {
    setState(() {
      isLoading = true;
    });

    try {
      final security = await flutterDeviceSecurity.checkDeviceSecurity();
      setState(() {
        deviceSecurity = security;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Device Security Check')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (isLoading) CircularProgressIndicator(),
            if (deviceSecurity != null) ...[
              SecurityTile(
                title: 'Device Lock',
                isSecure: deviceSecurity!.passcode ?? false,
                icon: Icons.lock,
              ),
              SecurityTile(
                title: 'Version Up to Date',
                isSecure: deviceSecurity!.version ?? false,
                icon: Icons.system_update,
              ),
              if (deviceSecurity is AndroidDeviceSecurity) ...[
                SecurityTile(
                  title: 'Biometric Available',
                  isSecure: (deviceSecurity as AndroidDeviceSecurity).biometric ?? false,
                  icon: Icons.fingerprint,
                ),
                SecurityTile(
                  title: 'USB Debugging Off',
                  isSecure: !((deviceSecurity as AndroidDeviceSecurity).usbDebugging ?? false),
                  icon: Icons.usb,
                ),
              ],
            ],
            Spacer(),
            ElevatedButton(
              onPressed: performSecurityCheck,
              child: Text('Check Device Security'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecurityTile extends StatelessWidget {
  final String title;
  final bool isSecure;
  final IconData icon;

  const SecurityTile({
    Key? key,
    required this.title,
    required this.isSecure,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSecure ? Colors.green : Colors.red,
      ),
      title: Text(title),
      trailing: Icon(
        isSecure ? Icons.check_circle : Icons.error,
        color: isSecure ? Colors.green : Colors.red,
      ),
    );
  }
}
```

## API Reference

### FlutterDeviceSecurity

Main class for device security checks.

#### Methods

##### `checkDeviceSecurity({String? minimumVersion})`

Performs a comprehensive device security check.

**Parameters:**
- `minimumVersion` (optional): Minimum OS version to check against

**Returns:** `Future<DeviceSecurity>` - Platform-specific device security information

**Throws:** Exception if security check fails

### DeviceSecurity Models

#### `DeviceSecurity` (Abstract Base Class)

Base class for all device security information.

**Properties:**
- `bool? passcode` - Whether device has lock screen protection
- `bool? version` - Whether device OS version meets requirements

#### `AndroidDeviceSecurity extends DeviceSecurity`

Android-specific security information.

**Additional Properties:**
- `bool? biometric` - Whether biometric authentication is available
- `bool? usbDebugging` - Whether USB debugging is enabled

#### `IOSDeviceSecurity extends DeviceSecurity`

iOS-specific security information (inherits base properties only).

## Security Considerations

This plugin helps identify potential security risks:

### 🔴 High Risk Indicators
- No device lock (passcode/PIN/pattern)
- USB debugging enabled (Android)
- Outdated OS version

### 🟡 Medium Risk Indicators
- No biometric authentication (Android)

### 🟢 Secure Configuration
- Device lock enabled
- USB debugging disabled
- Up-to-date OS version
- Biometric authentication available

## Platform Implementation Details

### Android
- Uses Android Keystore and DevicePolicyManager APIs
- Checks for various lock types (PIN, pattern, password, biometric)
- Detects developer options and USB debugging status
- Validates Android API level and security patch level

### iOS
- Uses LocalAuthentication framework
- Checks for passcode and biometric availability
- Validates iOS version requirements
- Respects iOS privacy and security guidelines

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Made with ❤️ for Flutter developers who prioritize security.

