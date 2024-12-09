import 'package:driverbooking/Screens/TollParkingUpload/TollParkingUpload.dart';
import 'package:flutter/material.dart';

class TripDetailsUpload extends StatefulWidget {
  const TripDetailsUpload({Key? key}) : super(key: key);

  @override
  State<TripDetailsUpload> createState() => _TripDetailsUploadState();
}

class _TripDetailsUploadState extends State<TripDetailsUpload> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip Details Upload"),
      ),
      body: SingleChildScrollView(
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
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: startKmController,
                      enabled: isStartKmEnabled,
                      decoration: const InputDecoration(
                        labelText: "Starting Kilometer",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: isStartKmEnabled ? _openCameraOrFiles : null,
                    child: const Text("Upload"),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Closing Kilometer
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: closeKmController,
                      enabled: isCloseKmEnabled,
                      decoration: const InputDecoration(
                        labelText: "Closing Kilometer",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: isCloseKmEnabled ? _openCameraOrFiles : null,
                    child: const Text("Upload"),
                  ),
                ],
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
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TollParkingUpload()));
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
    );
  }
}
