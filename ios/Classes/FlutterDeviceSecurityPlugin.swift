import Flutter
import LocalAuthentication
import UIKit

public class FlutterDeviceSecurityPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "flutter_device_security", binaryMessenger: registrar.messenger())
    let instance = FlutterDeviceSecurityPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getHasPasscode":
      hasPasscode(result: result)
    case "getPlatformVersion":
      result(UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func hasPasscode(result: @escaping FlutterResult) {
    let context = LAContext()
    var error: NSError?

    let canAuthenticate = context.canEvaluatePolicy(
      .deviceOwnerAuthentication,
      error: &error
    )

    result(canAuthenticate)
  }
}
