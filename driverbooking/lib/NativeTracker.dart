import 'package:flutter/services.dart';

class NativeTracker {
  static const MethodChannel _channel = MethodChannel('com.example.jessy_cabs/background');

  static Future<void> startTracking() async {
    try {
      final result = await _channel.invokeMethod('startTrackingForCurrentPage');
      print("✅ startTracking result: $result");
    } catch (e) {
      print("❌ Failed to call startTracking: $e");
    }
  }

  static Future<void> stopTracking() async {
    try {
      final result = await _channel.invokeMethod('stopTrackingForCurrentPage');
      print("✅ stopTracking result: $result");
    } catch (e) {
      print("❌ Failed to call stopTracking: $e");
    }
  }


  static Future<void> setTrackingMetadata({required String tripId, required String vehicleNumber}) async {
    try {
      final result = await _channel.invokeMethod('setTrackingMetadata', {
        'tripId': tripId,
        'vehicleNumber': vehicleNumber,
      });
      print("✅ setTrackingMetadata result: $result");
    } catch (e) {
      print("❌ Failed to send tracking metadata: $e");
    }
  }

}
