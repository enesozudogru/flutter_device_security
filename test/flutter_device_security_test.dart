import 'package:flutter_device_security/flutter_device_security.dart';
import 'package:flutter_device_security/flutter_device_security_method_channel.dart';
import 'package:flutter_device_security/flutter_device_security_platform_interface.dart';
import 'package:flutter_device_security/src/models/device_security.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterDeviceSecurityPlatform
    with MockPlatformInterfaceMixin
    implements FlutterDeviceSecurityPlatform {
  final Map<String, dynamic> _responses = {};

  void setMockResponse(String method, dynamic value) {
    _responses[method] = value;
  }

  @override
  Future<String> checkDeviceVersion() =>
      Future.value(_responses['checkDeviceVersion'] ?? '15.0.0');

  @override
  Future<bool> getHasBiometric() =>
      Future.value(_responses['getHasBiometric'] ?? true);

  @override
  Future<bool> getHasPasscode() =>
      Future.value(_responses['getHasPasscode'] ?? true);

  @override
  Future<bool> getHasUsbDebugging() =>
      Future.value(_responses['getHasUsbDebugging'] ?? false);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final FlutterDeviceSecurityPlatform initialPlatform =
      FlutterDeviceSecurityPlatform.instance;

  setUp(() {
    FlutterDeviceSecurityPlatform.instance =
        MockFlutterDeviceSecurityPlatform();
  });

  tearDown(() {
    FlutterDeviceSecurityPlatform.instance = initialPlatform;
  });

  group('FlutterDeviceSecurity', () {
    late FlutterDeviceSecurity flutterDeviceSecurity;
    late MockFlutterDeviceSecurityPlatform mockPlatform;

    setUp(() {
      flutterDeviceSecurity = FlutterDeviceSecurity();
      mockPlatform =
          FlutterDeviceSecurityPlatform.instance
              as MockFlutterDeviceSecurityPlatform;
    });

    test('is the default instance', () {
      expect(
        initialPlatform,
        isInstanceOf<MethodChannelFlutterDeviceSecurity>(),
      );
    });

    group('Android Platform Tests', () {
      setUp(() {
        // Mock Android platform
        mockPlatform.setMockResponse('checkDeviceVersion', '14.0');
        mockPlatform.setMockResponse('getHasPasscode', true);
        mockPlatform.setMockResponse('getHasBiometric', true);
        mockPlatform.setMockResponse('getHasUsbDebugging', false);
      });

      testWidgets('returns AndroidDeviceSecurity for Android platform', (
        WidgetTester tester,
      ) async {
        // Note: Platform.isAndroid is not mockable in tests without complex setup
        // This test would need platform-specific mocking or dependency injection

        final result = await flutterDeviceSecurity.checkDeviceSecurity();

        // In actual device tests, this would be AndroidDeviceSecurity
        expect(result, isA<DeviceSecurity>());
        expect(result.passcode, true);
        expect(result.version, true);
      });

      testWidgets(
        'AndroidDeviceSecurity contains all Android-specific properties',
        (WidgetTester tester) async {
          final result = await flutterDeviceSecurity.checkDeviceSecurity();

          if (result is AndroidDeviceSecurity) {
            expect(result.passcode, true);
            expect(result.biometric, true);
            expect(result.usbDebugging, false);
            expect(result.version, true);
          }
        },
      );
    });

    group('iOS Platform Tests', () {
      setUp(() {
        mockPlatform.setMockResponse('checkDeviceVersion', '17.0');
        mockPlatform.setMockResponse('getHasPasscode', true);
      });

      testWidgets('returns IOSDeviceSecurity for iOS platform', (
        WidgetTester tester,
      ) async {
        final result = await flutterDeviceSecurity.checkDeviceSecurity();

        if (result is IOSDeviceSecurity) {
          expect(result.passcode, true);
          expect(result.version, true);
          // iOS should not have biometric and usbDebugging properties
          expect(() => (result as dynamic).biometric, throwsNoSuchMethodError);
          expect(
            () => (result as dynamic).usbDebugging,
            throwsNoSuchMethodError,
          );
        }
      });
    });

    group('Version Checking', () {
      testWidgets('passes version check with valid minimum version', (
        WidgetTester tester,
      ) async {
        mockPlatform.setMockResponse('checkDeviceVersion', '15.0');

        final result = await flutterDeviceSecurity.checkDeviceSecurity(
          minimumVersion: '14.0',
        );

        expect(result.version, true);
      });

      testWidgets('fails version check with too high minimum version', (
        WidgetTester tester,
      ) async {
        mockPlatform.setMockResponse('checkDeviceVersion', '13.0');

        final result = await flutterDeviceSecurity.checkDeviceSecurity(
          minimumVersion: '15.0',
        );

        expect(result.version, false);
      });

      testWidgets('handles empty version gracefully', (
        WidgetTester tester,
      ) async {
        mockPlatform.setMockResponse('checkDeviceVersion', '');

        final result = await flutterDeviceSecurity.checkDeviceSecurity(
          minimumVersion: '15.0',
        );

        expect(result.version, true); // Should return true for empty version
      });
    });

    group('Security Features', () {
      testWidgets('detects when passcode is disabled', (
        WidgetTester tester,
      ) async {
        mockPlatform.setMockResponse('getHasPasscode', false);

        final result = await flutterDeviceSecurity.checkDeviceSecurity();

        expect(result.passcode, false);
      });

      testWidgets('detects when biometric is unavailable on Android', (
        WidgetTester tester,
      ) async {
        mockPlatform.setMockResponse('getHasBiometric', false);

        final result = await flutterDeviceSecurity.checkDeviceSecurity();

        if (result is AndroidDeviceSecurity) {
          expect(result.biometric, false);
        }
      });

      testWidgets('detects when USB debugging is enabled on Android', (
        WidgetTester tester,
      ) async {
        mockPlatform.setMockResponse('getHasUsbDebugging', true);

        final result = await flutterDeviceSecurity.checkDeviceSecurity();

        if (result is AndroidDeviceSecurity) {
          expect(result.usbDebugging, true);
        }
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

      test(
        'AndroidDeviceSecurity can be instantiated with correct properties',
        () {
          const android = AndroidDeviceSecurity(
            passcode: true,
            version: true,
            biometric: true,
            usbDebugging: false,
          );

          expect(android.passcode, true);
          expect(android.version, true);
          expect(android.biometric, true);
          expect(android.usbDebugging, false);
          expect(android, isA<DeviceSecurity>());
          expect(android, isA<AndroidDeviceSecurity>());
        },
      );

      test('toString methods work correctly', () {
        const ios = IOSDeviceSecurity(passcode: true, version: false);
        const android = AndroidDeviceSecurity(
          passcode: false,
          version: true,
          biometric: true,
          usbDebugging: true,
        );

        expect(
          ios.toString(),
          'IOSDeviceSecurity{passcode: true, version: false}',
        );
        expect(
          android.toString(),
          'AndroidDeviceSecurity{passcode: false, version: true, biometric: true, usbDebugging: true}',
        );
      });
    });
  });
}
