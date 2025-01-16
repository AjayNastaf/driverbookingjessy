import 'package:driverbooking/Screens/TollParkingUpload/TollParkingUpload.dart';
import 'package:driverbooking/Utils/AllImports.dart';
import 'package:flutter/material.dart';
import 'package:driverbooking/Screens/SignatureEndRide/SignatureEndRide.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';




class TripDetailsPreview extends StatefulWidget {
  final String tripId;
  const TripDetailsPreview({super.key, required this.tripId});

  @override
  State<TripDetailsPreview> createState() => _TripDetailsPreviewState();
}

class _TripDetailsPreviewState extends State<TripDetailsPreview> {

  DateTime? startingDate;
  DateTime? closingDate;
  bool isStartKmEnabled = true; // Only Start KM and Close KM are enabled
  bool isCloseKmEnabled = true;

  final TextEditingController tripIdController = TextEditingController();
  final TextEditingController guestNameController = TextEditingController();
  final TextEditingController guestMobileController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController startKmController = TextEditingController();
  final TextEditingController closeKmController = TextEditingController();

  String? startingImageUrl;
  String? endingImageUrl;
  bool isLoading = true;


  Future<void> _pickDate(BuildContext context, bool isStartingDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartingDate) {
          startingDate = pickedDate;
        } else {
          closingDate = pickedDate;
        }
      });
    }
  }

  void _openCameraOrFiles() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Open Camera'),
              onTap: () {
                Navigator.pop(context);
                // Add camera logic
              },
            ),
            ListTile(
              leading: Icon(Icons.file_upload),
              title: Text('Upload File'),
              onTap: () {
                Navigator.pop(context);
                // Add file upload logic
              },
            ),
          ],
        );
      },
    );
  }




  Future<void> fetchImages() async {
    final String apiUrll = 'http://192.168.0.114:3000/get-images'; // Your server URL

    try {
      final response = await http.get(Uri.parse(apiUrll));
      print('Request URL: $apiUrll');
      print('Response received, Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print("Ajay");
        final data = json.decode(response.body);

        // Print the full response for debugging
        print('Fetched Data: $data');

        // Ensure 'images' exists and is not empty
        if (data['images'] != null && data['images'].isNotEmpty) {
          setState(() {
            // startingImageUrl = data['images'][0]['startingimage'] ?? null;
            // endingImageUrl = data['images'][0]['endingimage'] ?? null;
            startingImageUrl = '${data['images'][0]['startingimage']}';
            endingImageUrl = '${data['images'][0]['endingimage']}';

          });
          print("${AppConstants.baseUrl}/backend/uploads/$startingImageUrl");
        } else {
          print('No images found in the response');
        }
      } else {
        print('Failed to load images, Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchImages(); // Make sure fetchImages is being called
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip Preview"),
      ),
      body:

      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Trip ID
              TextField(
                controller: tripIdController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Trip ID",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Guest Name
              TextField(
                controller: guestNameController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Guest Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Guest Mobile Number
              TextField(
                controller: guestMobileController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Guest Mobile Number",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Vehicle Type
              TextField(
                controller: vehicleTypeController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Vehicle Type",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Starting Date
              TextField(
                readOnly: true,
                enabled: false,
                decoration: InputDecoration(
                  hintText: startingDate == null
                      ? "Select Starting Date"
                      : "${startingDate!.toLocal()}".split(' ')[0],
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Closing Date
              TextField(
                readOnly: true,
                enabled: false,
                decoration: InputDecoration(
                  hintText: closingDate == null
                      ? "Select Closing Date"
                      : "${closingDate!.toLocal()}".split(' ')[0],
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Starting Kilometer

                  TextField(
                      readOnly: true,
                      enabled: false,
                      controller: startKmController,
                      // enabled: isStartKmEnabled,
                      decoration: const InputDecoration(
                        labelText: "Starting Kilometer",
                        border: OutlineInputBorder(),
                      ),
                    ),
              Image.asset(
                AppConstants.intro_one, // Replace with your image path
                height: 100, // Set the desired height
                width: 100, // Set the desired width
                fit: BoxFit.cover, // Adjust the image's box fit
              ),


              const SizedBox(height: 16),

              // Closing Kilometer
            TextField(
                      controller: closeKmController,
                      // enabled: isCloseKmEnabled,
                        readOnly: true,
                        enabled: false,
                      decoration: const InputDecoration(
                        labelText: "Closing Kilometer",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    Image.asset(
                      AppConstants.intro_one, // Replace with your image path
                      height: 100, // Set the desired height
                      width: 100, // Set the desired width
                      fit: BoxFit.cover, // Adjust the image's box fit
                    ),

              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      // Add your logic for toll and parking upload
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TollParkingUpload(tripId:widget.tripId ,)));
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Signatureendride()));
                    },
                    child: const Text(
                      "Upload Toll and Parking",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),


      // SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.all(16.0),
      //     child: Column(
      //       children: [
      //         // Trip ID (disabled)
      //         TextField(
      //           enabled: false,
      //           decoration: const InputDecoration(
      //             labelText: "Trip ID",
      //             border: OutlineInputBorder(),
      //           ),
      //         ),
      //         const SizedBox(height: 16),
      //
      //         // Starting Image
      //         startingImageUrl == null
      //             ? const CircularProgressIndicator()  // Show a loading spinner if the image is not loaded yet
      //             :
      //         Image.network(
      //           startingImageUrl ?? '', // Full URL from the API
      //           height: 100,
      //           width: 100,
      //           fit: BoxFit.cover,
      //           errorBuilder: (context, error, stackTrace) {
      //             return const Text("Failed to load image");
      //           },
      //         ),
      //         // Display the URL for debugging
      //         Text(startingImageUrl ?? 'URL not available'),
      //         const SizedBox(height: 16),
      //
      //         // Closing Image
      //         endingImageUrl == null
      //             ? const CircularProgressIndicator()  // Show a loading spinner if the image is not loaded yet
      //             :
      //         Image.network(
      //           '$endingImageUrl', // Image path fetched from API
      //           height: 100,
      //           width: 100,
      //           fit: BoxFit.cover,
      //           errorBuilder: (context, error, stackTrace) {
      //             return const Text("Failed to load image");
      //           },
      //         ),
      //         const SizedBox(height: 16),
      //
      //         // Other Fields (Guest Name, Vehicle Type, etc.)
      //         TextField(
      //           enabled: false,
      //           decoration: const InputDecoration(
      //             labelText: "Guest Name",
      //             border: OutlineInputBorder(),
      //           ),
      //         ),
      //         const SizedBox(height: 16),
      //
      //         // You can add other fields here...
      //       ],
      //     ),
      //   ),
      // ),

    );
  }
}
