import 'package:http/http.dart' as http;
import 'package:jessy_cabs/Utils/AllImports.dart';

Future<void> sendLocationToDatabase({
  required double latitude,
  required double longitude,
  required String vehicleNo,
  required String tripId,
  required String tripStatus,
}) async {
  if (latitude == 0.0 && longitude == 0.0) {
    print("⚠ Invalid background location (0.0, 0.0) - Not sending.");
    return;
  }

  final response = await http.post(
    Uri.parse("${AppConstants.baseUrl}/save-location"), // 🔁 Use your actual endpoint
    body: {
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "vehicleNo": vehicleNo,
      "tripId": tripId,
      "tripStatus": tripStatus,
    },
  );

  print("✅ Location sent! Response: ${response.statusCode}");
}
