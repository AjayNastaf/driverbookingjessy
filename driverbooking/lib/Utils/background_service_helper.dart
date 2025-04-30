import 'package:flutter/services.dart';

class BackgroundServiceHelper {
  static const platform = MethodChannel('com.example.jessy_cabs/background');

  static Future<void> startBackgroundService() async {
    try {
      final result = await platform.invokeMethod('startService');
      print('Background service result: $result');
    } on PlatformException catch (e) {
      print("Failed to start service: '${e.message}'.");
    }
  }
}


