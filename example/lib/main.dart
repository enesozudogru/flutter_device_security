import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_device_security/flutter_device_security.dart';
import 'package:flutter_device_security/src/models/device_security.dart';
import 'package:flutter_device_security_example/enums/device_security_types.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Security Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DeviceSecurityScreen(),
    );
  }
}

class DeviceSecurityScreen extends StatefulWidget {
  const DeviceSecurityScreen({super.key});

  @override
  State<DeviceSecurityScreen> createState() => _DeviceSecurityScreenState();
}

class _DeviceSecurityScreenState extends State<DeviceSecurityScreen> {
  final ValueNotifier<DeviceSecurity?> deviceSecurityNotifier =
      ValueNotifier<DeviceSecurity?>(null);
  final ValueNotifier<bool> loadingNotifier = ValueNotifier<bool>(false);
  final flutterDeviceSecurity = FlutterDeviceSecurity();
  Future<void> checkDeviceSecurity() async {
    try {
      loadingNotifier.value = true;
      deviceSecurityNotifier.value =
          await flutterDeviceSecurity.checkDeviceSecurity();
    } catch (e) {
      debugPrint('Device security check error: $e');
    } finally {
      loadingNotifier.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Security')),
      body: ValueListenableBuilder(
        valueListenable: loadingNotifier,
        builder: (context, isLoading, child) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder<DeviceSecurity?>(
                valueListenable: deviceSecurityNotifier,
                builder: (context, deviceSecurity, child) {
                  if (deviceSecurity != null) {
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        DeviceSecurityTile(
                          type: DeviceSecurityTypes.passcode,
                          value: deviceSecurity.passcode,
                        ),
                        DeviceSecurityTile(
                          type: DeviceSecurityTypes.version,
                          value: deviceSecurity.version,
                        ),
                        if (deviceSecurity is AndroidDeviceSecurity) ...[
                          DeviceSecurityTile(
                            type: DeviceSecurityTypes.biometric,
                            value: deviceSecurity.biometric,
                          ),
                          DeviceSecurityTile(
                            type: DeviceSecurityTypes.usbDebugging,
                            value: !(deviceSecurity.usbDebugging ?? false),
                          ),
                        ],
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(
                  onPressed: checkDeviceSecurity,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Start Scan'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class DeviceSecurityTile extends StatelessWidget {
  const DeviceSecurityTile({super.key, required this.type, this.value});

  final DeviceSecurityTypes type;
  final bool? value;

  @override
  Widget build(BuildContext context) {
    if (!type.show) {
      return const SizedBox.shrink();
    }
    return ListTile(
      leading: Icon(
        type.icon,
        color: value == true ? Colors.green : Colors.red,
      ),
      title: Text(
        type.label,
        style: TextStyle(color: value == true ? Colors.green : Colors.red),
      ),
    );
  }
}
