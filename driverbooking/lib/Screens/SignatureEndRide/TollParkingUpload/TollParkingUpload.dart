import 'package:driverbooking/Utils/AllImports.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TollParkingUpload extends StatefulWidget {
  const TollParkingUpload({super.key});

  @override
  State<TollParkingUpload> createState() => _TollParkingUploadState();
}

class _TollParkingUploadState extends State<TollParkingUpload> {
  final TextEditingController tollController = TextEditingController();
  final TextEditingController parkingController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  // Method to open file picker for uploading files
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      print("File selected: ${file.path}");
      // Add logic to upload the file
    } else {
      print("File selection canceled");
    }
  }

  // Method to open the camera
  Future<void> _openCamera() async {
    XFile? photo = await _imagePicker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      print("Photo captured: ${photo.path}");
      // Add logic to upload the captured photo
    } else {
      print("Camera canceled");
    }
  }

  // Method to show file picker and camera options
  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.upload_file),
              title: Text('Upload from device'),
              onTap: () {
                Navigator.pop(context); // Close the modal
                _pickFile();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Open Camera'),
              onTap: () {
                Navigator.pop(context); // Close the modal
                _openCamera();
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
        title: Text('Toll and Parking'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Enter Toll Amount Section
              SizedBox(height: 18),

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
              Center(
                child: ElevatedButton(
                  onPressed: _showUploadOptions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Ensures the button shrinks to fit content
                    children: [
                      Icon(Icons.upload_file, color: Colors.white), // Add your desired icon
                      SizedBox(width: 8), // Space between the icon and text
                      Text(
                        'Upload Toll',
                        style: TextStyle(color: Colors.white,fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),

              // Enter Parking Amount Section
              Text(
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
              Center(
                child: ElevatedButton(
                  onPressed: _showUploadOptions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.upload_file, color: Colors.white), // Add your desired icon
                      SizedBox(width: 8),
                       Text(
                        'Upload Parking',
                         style: TextStyle(color: Colors.white,fontSize: 18.0),
                      ),
                    ],
                  ),

                ),
              ),

              SizedBox(height: 36),
              Container(
                width: double.infinity,
                height:50.0,
                child: ElevatedButton(

                  onPressed: _showUploadOptions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.darkgreen,
                  ),
                  child: Text(
                    'Submit Details',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
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
