import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

Future<void> startBackgroundTracking() async {
  await [
    Permission.locationAlways,
    Permission.locationWhenInUse,
    Permission.notification,
  ].request();

  const platform = MethodChannel('com.example.jessy_cabs/background');
  try {
    await platform.invokeMethod('startService');
  } catch (e) {
    print("Failed to start background service: $e");
  }
}
