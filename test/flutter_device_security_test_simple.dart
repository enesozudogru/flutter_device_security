import 'package:flutter_device_security/flutter_device_security.dart';
import 'package:flutter_device_security/flutter_device_security_method_channel.dart';
import 'package:flutter_device_security/flutter_device_security_platform_interface.dart';
import 'package:flutter_device_security/src/models/device_security.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterDeviceSecurityPlatform with MockPlatformInterfaceMixin implements FlutterDeviceSecurityPlatform {
  final Map<String, dynamic> _responses = {};

  void setMockResponse(String method, dynamic value) {
    _responses[method] = value;
  }

  @override
  Future<String> checkDeviceVersion() => Future.value(_responses['checkDeviceVersion'] ?? '15.0.0');

  @override
  Future<bool> getHasBiometric() => Future.value(_responses['getHasBiometric'] ?? true);

  @override
  Future<bool> getHasPasscode() => Future.value(_responses['getHasPasscode'] ?? true);

  @override
  Future<bool> getHasUsbDebugging() => Future.value(_responses['getHasUsbDebugging'] ?? false);
}

void main() {
  final FlutterDeviceSecurityPlatform initialPlatform = FlutterDeviceSecurityPlatform.instance;

  setUp(() {
    FlutterDeviceSecurityPlatform.instance = MockFlutterDeviceSecurityPlatform();
  });

  tearDown(() {
    FlutterDeviceSecurityPlatform.instance = initialPlatform;
  });

  group('FlutterDeviceSecurity', () {
    late FlutterDeviceSecurity flutterDeviceSecurity;
    late MockFlutterDeviceSecurityPlatform mockPlatform;

    setUp(() {
      flutterDeviceSecurity = FlutterDeviceSecurity();
      mockPlatform = FlutterDeviceSecurityPlatform.instance as MockFlutterDeviceSecurityPlatform;
    });

    test('default instance is MethodChannelFlutterDeviceSecurity', () {
      expect(initialPlatform, isInstanceOf<MethodChannelFlutterDeviceSecurity>());
    });

    group('Platform Tests', () {
      setUp(() {
        mockPlatform.setMockResponse('checkDeviceVersion', '14.0');
        mockPlatform.setMockResponse('getHasPasscode', true);
        mockPlatform.setMockResponse('getHasBiometric', true);
        mockPlatform.setMockResponse('getHasUsbDebugging', false);
      });

      test('returns DeviceSecurity with correct data', () async {
        final result = await flutterDeviceSecurity.checkDeviceSecurity();

        expect(result, isA<DeviceSecurity>());
        expect(result.passcode, true);
        expect(result.version, true);
      });
    });

    group('Version Checking', () {
      test('passes version check with valid minimum version', () async {
        mockPlatform.setMockResponse('checkDeviceVersion', '15.0');

        final result = await flutterDeviceSecurity.checkDeviceSecurity(minimumVersion: '14.0');

        expect(result.version, true);
      });

      test('version check without minimum specified', () async {
        mockPlatform.setMockResponse('checkDeviceVersion', '');

        final result = await flutterDeviceSecurity.checkDeviceSecurity();

        expect(result.version, true); // Empty version should return true
      });
    });

    group('Security Features', () {
      test('detects when passcode is disabled', () async {
        mockPlatform.setMockResponse('getHasPasscode', false);

        final result = await flutterDeviceSecurity.checkDeviceSecurity();

        expect(result.passcode, false);
      });
    });

    group('Model Type Safety', () {
      test('IOSDeviceSecurity can be instantiated with correct properties', () {
        const ios = IOSDeviceSecurity(passcode: true, version: true);
        expect(ios.passcode, true);
        expect(ios.version, true);
        expect(ios, isA<DeviceSecurity>());
        expect(ios, isA<IOSDeviceSecurity>());
      });

      test('AndroidDeviceSecurity can be instantiated with correct properties', () {
        const android = AndroidDeviceSecurity(passcode: true, version: true, biometric: true, usbDebugging: false);

        expect(android.passcode, true);
        expect(android.version, true);
        expect(android.biometric, true);
        expect(android.usbDebugging, false);
        expect(android, isA<DeviceSecurity>());
        expect(android, isA<AndroidDeviceSecurity>());
      });

      test('toString methods work correctly', () {
        const ios = IOSDeviceSecurity(passcode: true, version: false);
        const android = AndroidDeviceSecurity(passcode: false, version: true, biometric: true, usbDebugging: true);

        expect(ios.toString(), 'IOSDeviceSecurity{passcode: true, version: false}');
        expect(android.toString(), 'AndroidDeviceSecurity{passcode: false, version: true, biometric: true, usbDebugging: true}');
      });
    });
  });
}
