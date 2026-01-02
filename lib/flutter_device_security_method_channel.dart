import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_device_security_platform_interface.dart';

/// An implementation of [FlutterDeviceSecurityPlatform] that uses method channels.
class MethodChannelFlutterDeviceSecurity extends FlutterDeviceSecurityPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_device_security');

  @override
  Future<String> checkDeviceVersion() async {
    return await methodChannel.invokeMethod<String>('getPlatformVersion') ?? "";
  }

  @override
  Future<bool> getHasPasscode() async {
    return await methodChannel.invokeMethod<bool?>('getHasPasscode') ?? false;
  }

  @override
  Future<bool> getHasBiometric() async {
    return await methodChannel.invokeMethod<bool?>('getHasBiometric') ?? false;
  }

  @override
  Future<bool> getHasUsbDebugging() async {
    return await methodChannel.invokeMethod<bool?>('getHasUsbDebugging') ??
        false;
  }
}
