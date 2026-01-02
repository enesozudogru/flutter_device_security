package com.enesozudogru.flutter_device_security

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterDeviceSecurityPlugin */
class FlutterDeviceSecurityPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_device_security")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
        "getHasPasscode" -> {
          result.success(isDevicePasscodeEnabled())
        }
        "getHasBiometric" -> {
            result.success(isBiometricEnabled())
        }
        "getHasUsbDebugging" -> {
            result.success(isUsbDebuggingEnabled())
        }
        "getPlatformVersion" -> {
            result.success(Build.VERSION.RELEASE)
        }
        else -> {
            result.notImplemented()
        }
    }

    
  }


      // Device passcode enabled check using KeyguardManager
    private fun isDevicePasscodeEnabled(): Boolean {
        val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
        return keyguardManager.isDeviceSecure
    }

    // Biometric authentication enrolled check using BiometricManager
    private fun isBiometricEnabled(): Boolean {
        val biometricManager = BiometricManager.from(this)
        return biometricManager.canAuthenticate(BiometricManager.Authenticators.BIOMETRIC_WEAK) == BiometricManager.BIOMETRIC_SUCCESS
    }

    // USB debugging enabled check using Settings.Global
    private fun isUsbDebuggingEnabled(): Boolean {
        return try {
            Settings.Global.getInt(contentResolver, Settings.Global.ADB_ENABLED, 0) == 1
        } catch (e: Exception) {
            false
        }
    }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

}
