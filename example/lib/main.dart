import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_device_security/flutter_device_security.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String _platformVersion = 'Unknown';
  final _flutterDeviceSecurityPlugin = FlutterDeviceSecurity();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    final isDeviceSecure = await _flutterDeviceSecurityPlugin.checkDeviceSecurity();
    // isDeviceSecure.
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(appBar: AppBar(title: const Text('Plugin example app')), body: Center(child: Text('Running on: $_platformVersion\n'))));
  }
}
