import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_device_security_method_channel.dart';

abstract class FlutterDeviceSecurityPlatform extends PlatformInterface {
  /// Constructs a FlutterDeviceSecurityPlatform.
  FlutterDeviceSecurityPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterDeviceSecurityPlatform _instance = MethodChannelFlutterDeviceSecurity();

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

  Future<String> checkDeviceVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> getHasPasscode() {
    throw UnimplementedError('getHasPasscode() has not been implemented.');
  }

  Future<bool> getHasBiometric() {
    throw UnimplementedError('getHasBiometric() has not been implemented.');
  }

  Future<bool> getHasUsbDebugging() {
    throw UnimplementedError('getHasUsbDebugging() has not been implemented.');
  }
}
