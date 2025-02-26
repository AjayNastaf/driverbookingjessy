import 'dart:io';

import 'package:driverbooking/Screens/HomeScreen/HomeScreen.dart';
import 'package:driverbooking/Utils/AllImports.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:driverbooking/Networks/Api_Service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart'; // Import this for DateFormat

import '../../../../Bloc/AppBloc_Events.dart';
import '../../../../Bloc/AppBloc_State.dart';
import '../../../../Bloc/App_Bloc.dart';

class EditTripDetails extends StatefulWidget {

  final String tripId;
  const EditTripDetails({super.key, required this.tripId});

  @override
  State<EditTripDetails> createState() => _EditTripDetailsState();
}

class _EditTripDetailsState extends State<EditTripDetails> {
  bool isEditable = false;
  File? tollFile;
  File? parkingFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = false;
  bool isDisabled = false;
  String closedDateFromDB = ''; // Class-level variable
  DateTime? closedDate; // This will store the closed date from the database

  // Controllers for input fields
  final TextEditingController tripSheetNumberController = TextEditingController();
  final TextEditingController tripDateController = TextEditingController();
  final TextEditingController reportTimeController = TextEditingController();
  final TextEditingController dutyTypeController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController guestNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dropLocationController = TextEditingController();
  final TextEditingController tollAmountController = TextEditingController();
  final TextEditingController parkingAmountController = TextEditingController();

  final SignatureController _signatureController = SignatureController(
    penColor: Colors.black,
    penStrokeWidth: 2.0,
    exportBackgroundColor: Colors.white,
  );
  @override
  void initState() {
    super.initState();
    _loadTripDetails();
    print('Received tripId: ${widget.tripId}'); // Print the tripId for debugging


  }





  Future<void> _loadTripDetails() async {
    try {
      // Fetch trip details from the API
      final tripDetails = await ApiService.fetchTripDetails(widget.tripId);
      print('Trip details fetchedd: $tripDetails');
      if (tripDetails != null) {

        var tripIdvalue = tripDetails['tripid'].toString();
        var tripdatevalue = tripDetails['tripsheetdate'].toString();
        var reporttimevalue = tripDetails['reporttime'].toString();;
        var dutyvalue = tripDetails['duty'].toString();
        var vectypeValue = tripDetails['vehType'].toString();
        var guestnamevalue = tripDetails['guestname'].toString();
        var guestmobilenovalue = tripDetails['guestmobileno'].toString();
        var 	pickupvalue = tripDetails['address1'].toString();
        var droplocationvalue = tripDetails['useage'].toString();
        var parkingvalue = tripDetails['parking'].toString();
        var tollvalue = tripDetails['toll'].toString();

        String closedDateString= tripDetails['closedate'] ?? '';

        print("dutyyyy: ${tripIdvalue}");
        setState(() {
          // Update the controllers with the values
          tripSheetNumberController.text = tripIdvalue ?? '';
          tripDateController.text = tripdatevalue ?? '';
          reportTimeController.text = reporttimevalue?? '';
          vehicleTypeController.text = vectypeValue ?? '';
          dutyTypeController.text = dutyvalue ?? '';
          guestNameController.text = guestnamevalue ?? '';
          contactNumberController.text = guestmobilenovalue ?? '';
          addressController.text = pickupvalue ?? '';
          dropLocationController.text = droplocationvalue ?? '';
          tollAmountController.text = tollvalue ?? '';
          parkingAmountController.text = parkingvalue ?? '';
          // closedDateFromDB = closedDateString ??'';
          closedDate = DateTime.parse(closedDateString);

        });

      } else {
        print('No trip details found.');
      }
    } catch (e) {
      print('Error loading trip details: $e');
    }
  }

  bool isFieldEnabled() {
    if (closedDate == null) return false; // Disable if closedDate is null
    DateTime today = DateTime.now();
    return closedDate!.year == today.year &&
        closedDate!.month == today.month &&
        closedDate!.day == today.day;
  }


  // bool _isSameDay() {
  //   if (tripDateController.text.isEmpty) return false; // Disable by default if no date is set
  //
  //   try {
  //     DateTime tripDate = DateTime.parse(tripDateController.text);
  //     DateTime now = DateTime.now();
  //
  //     return tripDate.year == now.year &&
  //         tripDate.month == now.month &&
  //         tripDate.day == now.day;
  //   } catch (e) {
  //     print("Error parsing date: $e");
  //     return false; // Disable if parsing fails
  //   }
  // }

  // bool _isSameDay() {
  //   if (tripDateController.text.isEmpty) return false; // Disable by default if no date is set
  //
  //   try {
  //     DateTime tripDate = DateTime.parse(tripDateController.text);
  //
  //     // Set both dates to 12:00 AM for an accurate day-only comparison
  //     DateTime now = DateTime.now();
  //     DateTime todayAtMidnight = DateTime(now.year, now.month, now.day, 0, 0, 0);
  //     DateTime tripDateAtMidnight = DateTime(tripDate.year, tripDate.month, tripDate.day, 0, 0, 0);
  //
  //     return tripDateAtMidnight == todayAtMidnight;
  //   } catch (e) {
  //     print("Error parsing date: $e");
  //     return false; // Disable if parsing fails
  //   }
  // }


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


  Future<void> _saveSignature() async {
    if (_signatureController.isNotEmpty) {
      final signature = await _signatureController.toPngBytes();
      // Save or upload signature here
      print("Signature saved.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signature saved successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide a signature first.")),
      );
    }
  }

  Future<void> _uploadFile(String purpose) async {
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
    );  }

  void _submitDetails() {
    // Your logic to handle submit (e.g., saving the data, calling API)
    print("Details submitted");
    // For now, just showing a message as an example
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Details Submitted")));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Homescreen(userId: "",username: '',)));
  }

  // Widget _buildInputField(String label, TextEditingController controller ,{bool isEnabled = true}) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: TextField(
  //       controller: controller,
  //       enabled: isEnabled, // Controls whether the field is enabled or not
  //       decoration: InputDecoration(
  //         labelText: label,
  //         filled: true,
  //         fillColor: isEnabled ? Colors.white : Colors.grey[200], // Adjusts the color based on enabled state
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(8.0),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  // Widget _buildInputField(String label, TextEditingController controller, {bool alwaysDisabled = false}) {
  //   bool isEnabled = isFieldEnabled(); // Check if field should be enabled
  //
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: TextField(
  //       controller: controller,
  //       enabled: isEnabled,
  //       decoration: InputDecoration(
  //         labelText: label,
  //         filled: true,
  //         fillColor: isEnabled ? Colors.white : Colors.grey[200],
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(8.0),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget _buildInputField(String label, TextEditingController controller, {bool alwaysDisabled = false}) {
    bool isEnabled = alwaysDisabled ? false : isFieldEnabled(); // Ensure certain fields are always disabled

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        enabled: isEnabled,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: isEnabled ? Colors.white : Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

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


  // void _handleSubmit(BuildContext context) {
  //   final tripId = widget.tripId;
  //
  //   context.read<TollParkingDetailsBloc>().add(UpdateTollParking(
  //     tripId: tripId,
  //     toll: tollAmountController.text,
  //     parking: parkingAmountController.text,
  //   ));
  //
  //   if (parkingFile != null) {
  //     context.read<TollParkingDetailsBloc>().add(UploadParkingFile(
  //       tripId: tripId,
  //       parkingFile: parkingFile!,
  //     ));
  //   }
  //
  //   if (tollFile != null) {
  //     context.read<TollParkingDetailsBloc>().add(UploadTollFile(
  //       tripId: tripId,
  //       tollFile: tollFile!,
  //     ));
  //   }
  //   _loadLoginDetails();
  //
  //
  // }


  // void _handleSubmit(BuildContext context) async {
  //   if ((_signatureController.isNotEmpty) && (_signatureController.isEmpty) ) {
  //     final signature = await _signatureController.toPngBytes();
  //     if (signature != null) {
  //       String base64Signature = 'data:image/png;base64,' + base64Encode(signature);
  //       final DateTime now = DateTime.now();
  //       final String endtrip = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  //       final String endtime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  //
  //       setState(() {
  //         _isLoading = true;
  //       });
  //
  //       // Dispatch signature saving event
  //       context.read<TripSignatureBloc>().add(
  //         SaveSignatureEvent(
  //           tripId: widget.tripId,
  //           base64Signature: base64Signature,
  //           imageName: 'signature-${now.millisecondsSinceEpoch}.png',
  //           endtrip: endtrip,
  //           endtime: endtime,
  //         ),
  //       );
  //
  //       // Dispatch toll & parking update event
  //       context.read<TollParkingDetailsBloc>().add(
  //         UpdateTollParking(
  //           tripId: widget.tripId,
  //           toll: tollAmountController.text,
  //           parking: parkingAmountController.text,
  //         ),
  //       );
  //
  //       // Upload parking file if selected
  //       if (parkingFile != null) {
  //         context.read<TollParkingDetailsBloc>().add(
  //           UploadParkingFile(
  //             tripId: widget.tripId,
  //             parkingFile: parkingFile!,
  //           ),
  //         );
  //       }
  //
  //       // Upload toll file if selected
  //       if (tollFile != null) {
  //         context.read<TollParkingDetailsBloc>().add(
  //           UploadTollFile(
  //             tripId: widget.tripId,
  //             tollFile: tollFile!,
  //           ),
  //         );
  //       }
  //
  //       // Show success message
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Details Submitted Successfully!")),
  //       );
  //
  //       // Navigate to HomeScreen after success
  //       _loadLoginDetails();
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Please provide a signature.")),
  //     );
  //   }
  // }


  void _handleSubmit(BuildContext context) async {
    final tripId = widget.tripId;
    bool dataSubmitted = false;

    // Handle Signature Submission
    if (_signatureController.isNotEmpty) {
      final signature = await _signatureController.toPngBytes();
      if (signature != null) {
        String base64Signature = 'data:image/png;base64,' + base64Encode(signature);
        final DateTime now = DateTime.now();
        final String endtrip = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
        final String endtime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

        context.read<TripSignatureBloc>().add(
          SaveSignatureEvent(
            tripId: tripId,
            base64Signature: base64Signature,
            imageName: 'signature-${now.millisecondsSinceEpoch}.png',
            endtrip: endtrip,
            endtime: endtime,
          ),
        );

        dataSubmitted = true;
      }
    }

    // Handle Toll & Parking Details Submission
    if (tollAmountController.text.isNotEmpty || parkingAmountController.text.isNotEmpty) {
      context.read<TollParkingDetailsBloc>().add(
        UpdateTollParking(
          tripId: tripId,
          toll: tollAmountController.text,
          parking: parkingAmountController.text,
        ),
      );

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

      dataSubmitted = true;
    }

    // Show appropriate message
    if (dataSubmitted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Details submitted successfully!")),
      );
      _loadLoginDetails(); // Navigate after submission
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please provide either a signature or toll/parking details.")),
      );
    }
  }


  void checkDate() {

    DateTime currentDate = DateTime.now();
    DateTime closedDate = DateTime.parse(closedDateFromDB);

    // Format dates to compare only year, month, and day
    String formattedCurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);
    String formattedClosedDate = DateFormat('yyyy-MM-dd').format(closedDate);

    if (formattedCurrentDate != formattedClosedDate) {
      setState(() {
        isDisabled = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<TollParkingDetailsBloc, TollParkingDetailsState>(
        listener: (context, state) {
          if (state is TollParkingUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Toll & Parking updated successfully!")),
            );
          } else if (state is ParkingFileUploaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Parking file uploaded successfully!")),
            );
          } else if (state is TollFileUploaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Toll file uploaded successfully!")),
            );

            // Navigate to HomeScreen after success
            // Navigator.pushReplacement(context, MaterialPageRoute(
            //   builder: (context) => Homescreen(userId: '', username: ''),
            // ));
          } else if (state is TollParkingDetailsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Edit Trip Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ElevatedButton(
            //   onPressed: () {
            //     setState(() {
            //       isEditable = !isEditable;
            //       if (!isEditable) {
            //         _signatureController.clear();
            //       }
            //     });
            //   },
            //   style: ElevatedButton.styleFrom(
            //     minimumSize: const Size(double.infinity, 48),
            //     backgroundColor: Colors.red, // Button color changes based on isEditable state
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Icon(Icons.edit, color: AppTheme.white1),
            //       SizedBox(width: 8.0),
            //       Text(
            //         "Edit Details",
            //         style: TextStyle(color: AppTheme.white1, fontSize: 20.0),
            //       ),
            //     ],
            //   ),
            // ),

            const SizedBox(height: 16),
            buildSectionTitle("Trip Information"),
            _buildInputField("Trip Sheet Number", tripSheetNumberController, alwaysDisabled: true ),
            _buildInputField("Trip Date", tripDateController,  alwaysDisabled: true),
            _buildInputField("Report Time", reportTimeController,alwaysDisabled: true ),
            const SizedBox(height: 16),
            buildSectionTitle("Duty Information"),
            _buildInputField("Duty Type", dutyTypeController,alwaysDisabled: true),
            _buildInputField("Vehicle Type", vehicleTypeController,alwaysDisabled: true),
            const SizedBox(height: 16),
            buildSectionTitle("Guest Information"),
            _buildInputField("Guest Name", guestNameController,alwaysDisabled: true),
            _buildInputField("Contact Number", contactNumberController,alwaysDisabled: true),
            const SizedBox(height: 16),
            buildSectionTitle("Locations"),
            _buildInputField("Pickup Location ", addressController,alwaysDisabled: true),
            _buildInputField("Drop Location", dropLocationController,alwaysDisabled: true),
            const SizedBox(height: 16),
            buildSectionTitle("Toll and Parking"),
            _buildInputField("Enter Toll Amount", tollAmountController,),
            // ElevatedButton.icon(
            //   onPressed: () => _uploadFile("Toll"),
            //   icon: const Icon(Icons.upload),
            //   label: const Text("Upload Toll"),
            // ),
            Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      // onPressed: () => _showUploadOptions(true),
                      onPressed: isFieldEnabled() ? () => _showUploadOptions(true) : null, // Disable button if condition is not met

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
            const SizedBox(height: 16),
            _buildInputField("Enter Parking Amount", parkingAmountController),
            // ElevatedButton.icon(
            //   onPressed: () => _uploadFile("Parking"),
            //   icon: const Icon(Icons.upload),
            //   label: const Text("Upload Parking"),
            // ),
            Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      // onPressed: () => _showUploadOptions(false),
                      onPressed: isFieldEnabled() ? () => _showUploadOptions(false) : null, // Disable button if condition is not met

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

            const SizedBox(height: 16),
            buildSectionTitle("Signature"),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
                color: isFieldEnabled() ? Colors.white : Colors.grey[200], // Change background color when disabled

              ),
                child: AbsorbPointer( // Prevents user interaction when disabled
                  absorbing: !isFieldEnabled(),
                  child: Signature(
                    controller: _signatureController,
                    height: 150,
                    backgroundColor: Colors.white,
                  ),
                ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed:  () => _signatureController.clear() ,
                  child: const Text("Clear Signature"),

                ),
                ElevatedButton(
                  onPressed: _saveSignature,
                  child: const Text("Save Signature"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // onPressed:  _submitDetails,
                onPressed: () { _handleSubmit(context); },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.darkgreen, // Set the background color here
                  foregroundColor: Colors.white, // Set the text color here
                ),
                child: Text("Submit Details", style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    ),


    );
  }
}
