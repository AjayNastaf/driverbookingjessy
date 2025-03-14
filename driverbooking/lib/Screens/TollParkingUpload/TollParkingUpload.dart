import 'package:driverbooking/Screens/HomeScreen/HomeScreen.dart';
import 'package:driverbooking/Utils/AllImports.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:driverbooking/Networks/Api_Service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driverbooking/Bloc/AppBloc_Events.dart';
import 'package:driverbooking/Bloc/AppBloc_State.dart';
import 'package:driverbooking/Bloc/App_Bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';





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
  String? username;
  String? userId;
  @override
  void initState() {
    super.initState();
    // _loadLoginDetailss();
  }

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

  // void _loadLoginDetailss() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     username = prefs.getString('username') ?? "Guest";
  //     userId = prefs.getString('userId') ?? "N/A";
  //   });
  //
  //   // Debugging print statements
  //   print("Local Storage - username: $username");
  //   print("Local Storage - userId: $userId");
  // }


  void _loadLoginDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String storedUsername = prefs.getString('username') ?? "Guest";
    String storedUserId = prefs.getString('userId') ?? "N/A";

    // Debugging print statements
    print("Local Storage - username: $storedUsername");
    print("Local Storage - userId: $storedUserId");

    // Navigate to Homescreen with stored values
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Homescreen(userId: storedUserId, username: storedUsername),
      ),
    );
  }


  // Future<void> _handleSubmitButton() async {
  //   // Validate fields
  //   // if (tollController.text.isEmpty) {
  //   //   ScaffoldMessenger.of(context).showSnackBar(
  //   //     SnackBar(content: Text('Please enter the toll amount.')),
  //   //   );
  //   //   return;
  //   // }
  //   //
  //   // if (tollFile == null) {
  //   //   ScaffoldMessenger.of(context).showSnackBar(
  //   //     SnackBar(content: Text('Please upload a file or take a photo for Toll.')),
  //   //   );
  //   //   return;
  //   // }
  //   //
  //   // if (parkingController.text.isEmpty) {
  //   //   ScaffoldMessenger.of(context).showSnackBar(
  //   //     SnackBar(content: Text('Please enter the parking amount.')),
  //   //   );
  //   //   return;
  //   // }
  //   //
  //   // if (parkingFile == null) {
  //   //   ScaffoldMessenger.of(context).showSnackBar(
  //   //     SnackBar(content: Text('Please upload a file or take a photo for Parking.')),
  //   //   );
  //   //   return;
  //   // }
  //
  //   bool result = await ApiService.updateTripDetailsTollParking(
  //     tripid: widget.tripId, // Pass the trip ID
  //     toll: tollController.text,
  //     parking: parkingController.text,
  //   );
  //
  //   bool result1 = await ApiService.uploadParkingFile(
  //     tripid: widget.tripId, // Replace with actual trip ID
  //     documenttype: 'Parking',
  //     parkingFile: parkingFile!,
  //   );
  //
  //   // Call the API to upload the Toll file
  //   bool result2 = await ApiService.uploadTollFile(
  //     tripid: widget.tripId, // Replace with actual trip ID
  //     documenttype: 'Toll',
  //     tollFile: tollFile!,
  //   );
  //
  //   // If all validations pass, call the functions
  //   // _handleTollSubmit();
  //   // _handleParkingSubmit();
  //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Homescreen(userId: '', username: '',)));
  //
  // }


  void _handleSubmit(BuildContext context) {
    final tripId = widget.tripId;

    if (tollController.text.isEmpty) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Please enter the toll amount.')),
      // );
      showWarningSnackBar(context, 'Please enter the toll amount.');
      return;
    }

    // if (tollFile == null) {
    //   showWarningSnackBar(context, 'Please upload a file or take a photo for Toll.');
    //   return;
    // }

    if (parkingController.text.isEmpty) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Please enter the parking amount.')),
      // );
      showWarningSnackBar(context, 'Please enter the parking amount.');

      return;
    }

    // if (parkingFile == null) {
    //
    //   showWarningSnackBar(context, 'Please upload a file or take a photo for Parking.');
    //
    //   return;
    // }


    context.read<TollParkingDetailsBloc>().add(UpdateTollParking(
      tripId: tripId,
      toll: tollController.text,
      parking: parkingController.text,
    ));

    if (parkingFile != null) {
      context.read<TollParkingDetailsBloc>().add(UploadParkingFile(
        tripId: tripId,
        parkingFile: parkingFile!,
      ));
    }

    if (tollFile != null) {
      context.read<TollParkingDetailsBloc>().add(UploadTollFile(
        tripId: tripId,
        tollFile: tollFile!,
      ));
    }
    // if ((parkingController.text.isNotEmpty) && (tollController.text.isNotEmpty) && (tollFile != null) && (parkingFile != null)) {
    if ((parkingController.text.isNotEmpty) && (tollController.text.isNotEmpty)) {
      _loadLoginDetails();
    }

  }

  @override
  Widget build(BuildContext context) {
    return  BlocListener<TollParkingDetailsBloc, TollParkingDetailsState>(
        listener: (context, state) {
      if (state is TollParkingUpdated) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Toll & Parking updated successfully!")),
        // );
        showSuccessSnackBar(context, "Toll & Parking updated successfully!");

      } else if (state is ParkingFileUploaded) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Parking file uploaded successfully!")),
        // );
        showSuccessSnackBar(context, "Parking file uploaded successfully!");

      } else if (state is TollFileUploaded) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Toll file uploaded successfully!")),
        // );
        showSuccessSnackBar(context, "Toll file uploaded successfully!");


        // Navigate to HomeScreen after success
        // Navigator.pushReplacement(context, MaterialPageRoute(
        //   builder: (context) => Homescreen(userId: '', username: ''),
        // ));
      } else if (state is TollParkingDetailsError) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(state.message)),
        // );
        showFailureSnackBar(context, state.message);
      }
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text('Toll and Parking'),
      ),
      // appBar: AppBar(title: Text("Welcome, $username")),

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
              Column(
                children: [
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
                  // Image Preview inside a card
                  if (tollFile != null)
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                tollFile!,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Selected Image",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Center(
                      child: Text(
                        "No file selected",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),

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
              Column(
                children: [
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
                            SizedBox(height: 24),


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
                  // Image Preview inside a card
                  if (parkingFile != null)
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                parkingFile!,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Selected Image",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Center(
                      child: Text(
                        "No file selected",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),

                ],
              ),
              SizedBox(height: 30.0,),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add your button action here
                    // _handleSubmitButton();
                    _handleSubmit(context);
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
              )
            ],
          ),
        ),
      ),
    ),
    );
  }
}
