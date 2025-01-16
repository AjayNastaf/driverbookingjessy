import 'package:driverbooking/Screens/HomeScreen/HomeScreen.dart';
import 'package:driverbooking/Utils/AllImports.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:driverbooking/Networks/Api_Service.dart';

class TollParkingUpload extends StatefulWidget {
  final String tripId;
  const TollParkingUpload({super.key, required this.tripId});

  @override
  State<TollParkingUpload> createState() => _TollParkingUploadState();
}

class _TollParkingUploadState extends State<TollParkingUpload> {
  final TextEditingController tollController = TextEditingController();
  final TextEditingController parkingController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  File? tollFile;
  File? parkingFile;

  Future<void> _pickFile(bool isToll) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        if (isToll) {
          tollFile = file;
        } else {
          parkingFile = file;
        }
      });
      print("${isToll ? "Toll" : "Parking"} file selected: ${file.path}");
    } else {
      print("File selection canceled");
    }
  }

  Future<void> _openCamera(bool isToll) async {
    XFile? photo = await _imagePicker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      File file = File(photo.path);
      setState(() {
        if (isToll) {
          tollFile = file;
        } else {
          parkingFile = file;
        }
      });
      print("${isToll ? "Toll" : "Parking"} photo captured: ${photo.path}");
    } else {
      print("Camera canceled");
    }
  }

  void _showUploadOptions(bool isToll) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.upload_file),
              title: Text('Upload from device'),
              onTap: () {
                Navigator.pop(context);
                _pickFile(isToll);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Open Camera'),
              onTap: () {
                Navigator.pop(context);
                _openCamera(isToll);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleTollSubmit() async {
    if (tollController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the toll amount.')),
      );
      return;
    }

    if (tollFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload a file or take a photo for Toll.')),
      );
      return;
    }

    // Call the API to upload the Toll file
    bool result = await ApiService.uploadTollFile(
      tripid: widget.tripId, // Replace with actual trip ID
      documenttype: 'Toll',
      tollFile: tollFile!,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result ? 'Toll details submitted successfully!' : 'Failed to submit toll details.'),
      ),
    );
  }

  Future<void> _handleParkingSubmit() async {
    if (parkingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the parking amount.')),
      );
      return;
    }

    if (parkingFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload a file or take a photo for Parking.')),
      );
      return;
    }

    // Call the API to upload the Parking file
    bool result = await ApiService.uploadParkingFile(
      tripid: widget.tripId, // Replace with actual trip ID
      documenttype: 'Parking',
      parkingFile: parkingFile!,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result ? 'Parking details submitted successfully!' : 'Failed to submit parking details.'),
      ),
    );
  }

  Future<void> _handleSubmitButton() async {
    // Validate fields
    if (tollController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the toll amount.')),
      );
      return;
    }

    if (tollFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload a file or take a photo for Toll.')),
      );
      return;
    }

    if (parkingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the parking amount.')),
      );
      return;
    }

    if (parkingFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload a file or take a photo for Parking.')),
      );
      return;
    }

    bool result = await ApiService.updateTripDetailsTollParking(
      tripid: widget.tripId, // Pass the trip ID
      toll: tollController.text,
      parking: parkingController.text,
    );

    // If all validations pass, call the functions
    _handleTollSubmit();
    _handleParkingSubmit();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Homescreen(userId: '', username: '',)));

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toll and Parking'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enter Toll Amount Section
              const SizedBox(height: 18),
              Text(
                "Enter Toll Amount",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: tollController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter toll amount',
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _showUploadOptions(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.upload_file, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Upload Toll',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  // ElevatedButton(
                  //   onPressed: _handleTollSubmit,
                  //   child: Text("Submit Toll"),
                  // ),
                ],
              ),

              SizedBox(height: 32),

              // Enter Parking Amount Section
              const Text(
                "Enter Parking Amount",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: parkingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter parking amount',
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _showUploadOptions(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.upload_file, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Upload Parking',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  // ElevatedButton(
                  //   onPressed: _handleParkingSubmit,
                  //   child: Text("Submit Parking"),
                  // ),
                ],
              ),
              SizedBox(height: 30.0,),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add your button action here
                    _handleSubmitButton();
                  },
                  child: Text(
                    'Upload Details',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white, // Text color
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Background color
                    padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 12.0), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Border radius
                    ),
                  ),
                ),
              )            ],
          ),
        ),
      ),
    );
  }
}
