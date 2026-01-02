import 'package:flutter/services.dart';
import 'package:flutter_device_security/flutter_device_security_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFlutterDeviceSecurity platform = MethodChannelFlutterDeviceSecurity();
  const MethodChannel channel = MethodChannel('flutter_device_security');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'getPlatformVersion':
          return '15.0.0';
        case 'getHasPasscode':
          return true;
        case 'getHasBiometric':
          return true;
        case 'getHasUsbDebugging':
          return false;
        default:
          throw PlatformException(code: 'Unimplemented', message: 'Method ${methodCall.method} is not implemented');
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  group('MethodChannelFlutterDeviceSecurity', () {
    test('checkDeviceVersion returns platform version', () async {
      expect(await platform.checkDeviceVersion(), '15.0.0');
    });

    test('getHasPasscode returns true when passcode is set', () async {
      expect(await platform.getHasPasscode(), true);
    });

    test('getHasBiometric returns true when biometric is available', () async {
      expect(await platform.getHasBiometric(), true);
    });

    test('getHasUsbDebugging returns false when USB debugging is disabled', () async {
      expect(await platform.getHasUsbDebugging(), false);
    });

    test('handles null responses gracefully', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        return null; // Return null to test default values
      });

      expect(await platform.checkDeviceVersion(), '');
      expect(await platform.getHasPasscode(), false);
      expect(await platform.getHasBiometric(), false);
      expect(await platform.getHasUsbDebugging(), false);
    });

    test('handles platform exceptions', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        throw PlatformException(code: 'UNAVAILABLE', message: 'Platform feature not available');
      });

      expect(() => platform.checkDeviceVersion(), throwsA(isA<PlatformException>()));
      expect(() => platform.getHasPasscode(), throwsA(isA<PlatformException>()));
      expect(() => platform.getHasBiometric(), throwsA(isA<PlatformException>()));
      expect(() => platform.getHasUsbDebugging(), throwsA(isA<PlatformException>()));
    });
  });
}
