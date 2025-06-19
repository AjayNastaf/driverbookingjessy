//
// import 'dart:io';
// import 'package:jessy_cabs/Utils/AllImports.dart';
// import 'package:jessy_cabs/Networks/Api_Service.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:jessy_cabs/Screens/SignatureEndRide/SignatureEndRide.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
//
// class TripDetailsUpload extends StatefulWidget {
//   final String tripId;
//   const TripDetailsUpload({Key? key, required this.tripId}) : super(key: key);
//
//   @override
//   State<TripDetailsUpload> createState() => _TripDetailsUploadState();
// }
//
// class _TripDetailsUploadState extends State<TripDetailsUpload> {
//   // DateTime? startingDate;
//   // DateTime? closingDate;
//   bool isStartKmEnabled = true; // Only Start KM and Close KM are enabled
//   bool isCloseKmEnabled = true;
//
//   final TextEditingController startKmController = TextEditingController();
//   final TextEditingController closeKmController = TextEditingController();
//
//   TextEditingController guestNameController = TextEditingController();
//   TextEditingController tripIdController = TextEditingController();
//   TextEditingController guestMobileController = TextEditingController();
//   TextEditingController vehicleTypeController = TextEditingController();
//   TextEditingController startDateController = TextEditingController();
//   TextEditingController closeDateController = TextEditingController();
//
//
//   // File? _selectedImage1;
//   File? _selectedImage2;
//   int? _lastSelectedButton; // Tracks which button was last used
//   final ImagePicker _picker = ImagePicker();
//   Map<String, dynamic>? tripDetails;
//   String? duty;
//   int? hcl;
//
//   Future<void> _fetchTripDetails() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     String? tripDetailsJson = prefs.getString('tripDetails');
//
//     if (tripDetailsJson != null) {
//       Map<String, dynamic> tripDetails = json.decode(tripDetailsJson);
//
//       // Print out the entire fetched data to check if all values are present
//       print("Fetched trip details: $tripDetails");
//
//       // Check each value individually
//       print("guestname: ${tripDetails['guestname']}");
//       print("tripid: ${tripDetails['tripid']}");
//       print("guestmobileno: ${tripDetails['guestmobileno']}");
//       print("vehType: ${tripDetails['vehType']}");
//       print("startdate: ${tripDetails['startdate']}");
//       print("closeDate: ${tripDetails['closeDate']}");
//       print("dutyyyy: ${tripDetails['duty']}");
//       print("Hybriddata: ${tripDetails['Hybriddata']}");
//
//       hcl = tripDetails['Hybriddata']; // Assuming `hcl` is part of the trip details
//       duty = tripDetails['duty']; // Assuming `duty` is part of the trip details
//       // print("dutyyyy: ${tripDetails['hcl']}");
//       setState(() {
//         // Update the controllers with the values
//         guestMobileController.text = tripDetails['guestmobileno'] ?? 'Not available';
//         guestNameController.text = tripDetails['guestname'] ?? 'Not available';
//         tripIdController.text = tripDetails['tripid'].toString()  ?? 'Not available';
//         vehicleTypeController.text = tripDetails['vehType'] ?? 'Not available';
//         startDateController.text = tripDetails['startdate'] ?? 'Not available';
//         closeDateController.text = tripDetails['closeDate'] ?? 'Not available';
//
//         // Print after setting the text to controllers to verify
//         print("Updated guestNameController text: ${guestNameController.text}");
//         print("Updated tripIdController text: ${tripIdController.text}");
//         print("Updated guestMobileController text: ${guestMobileController.text}");
//         print("Updated vehicleTypeController text: ${vehicleTypeController.text}");
//         print("Updated startDateController text: ${startDateController.text}");
//         print("Updated closeDateController text: ${closeDateController.text}");
//       });
//     } else {
//       print('No trip details found in shared preferences.');
//     }
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     // _loadTripDetails();
//     _fetchTripDetails();
//   }
//
//   // Function to choose an image for a specific button
//   Future<void> _chooseOption(BuildContext context, int buttonId) async {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.camera_alt),
//                 title: const Text("Open Camera"),
//                 onTap: () async {
//                   Navigator.of(context).pop();
//                   final XFile? image =
//                   await _picker.pickImage(source: ImageSource.camera);
//                   if (image != null) {
//                     setState(() {
//                       _lastSelectedButton = buttonId;
//                       // if (buttonId == 1) {
//                       //   _selectedImage1 = File(image.path);
//                       // } else
//                         if (buttonId == 2) {
//                         _selectedImage2 = File(image.path);
//                       }
//                     });
//                   }
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text("Upload File"),
//                 onTap: () async {
//                   Navigator.of(context).pop();
//                   final XFile? image =
//                   await _picker.pickImage(source: ImageSource.gallery);
//                   if (image != null) {
//                     setState(() {
//                       _lastSelectedButton = buttonId;
//                       // if (buttonId == 1) {
//                       //   _selectedImage1 = File(image.path);
//                       // } else
//                         if (buttonId == 2) {
//                         _selectedImage2 = File(image.path);
//                       }
//                     });
//                   }
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // Future<void> _uploadImage() async {
//   //   if (_selectedImage1 == null || _selectedImage2 == null) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(content: Text("Please select images for both buttons")),
//   //     );
//   //     return;
//   //   }
//   //
//   //   // Call the API service to upload images
//   //   final result = await ApiService.uploadImage(_selectedImage1!, _selectedImage2!);
//   //
//   //   if (result['success'] == true) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text(" Message: ${result['message']}")),
//   //     );
//   //
//   //
//   //     // Clear selected images
//   //     setState(() {
//   //       _selectedImage1 = null;
//   //       _selectedImage2 = null;
//   //     });
//   //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Signatureendride(tripId: widget.tripId,)));
//   //
//   //   } else {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text("Failed to upload images: ${result['message']}")),
//   //     );
//   //   }
//   // }
//
//   // Future<void> _handleStartingKmSubmit() async {
//   //   // Call the API to upload the Toll file
//   //   bool result = await ApiService.uploadstartingkm(
//   //     tripid: widget.tripId, // Replace with actual trip ID
//   //     documenttype: 'StartingKm',
//   //     startingkilometer: _selectedImage1!,
//   //   );
//   //
//   // }
//
//   Future<void> _handleClosingKmSubmit() async {
//     // Call the API to upload the Toll file
//     bool result = await ApiService.uploadClosingkm(
//       tripid: widget.tripId, // Replace with actual trip ID
//       documenttype: 'ClosingKm',
//       closingkilometer: _selectedImage2!,
//     );
//
//   }
//
//   Future<void> _handleSubmitStartClose() async {
//     bool result = await ApiService.updateTripDetailsStartandClosekm(
//       tripid: widget.tripId, // Pass the trip ID
//       startingkm: startKmController.text,
//       closigkm: closeKmController.text,
//     );
//
//     // _handleStartingKmSubmit();
//     _handleClosingKmSubmit();
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Signatureendride(tripId: widget.tripId,)));
//
//   }
//
//
//
//   Future<void> _loadTripDetails() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     // Retrieve the JSON string
//     String? tripDetailsJson = prefs.getString('tripDetails');
//
//     if (tripDetailsJson != null) {
//       setState(() {
//         // Decode the JSON string into a Dart map
//         tripDetails = json.decode(tripDetailsJson);
//         // tripIdController.text = tripDetails['tripid'] ?? 'Not available';
//
//       });
//     } else {
//       print('No trip details found in local storage.');
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Trip Details Upload"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               // Trip ID
//
//               TextField(
//                 controller: tripIdController,
//                 enabled: false,
//                 decoration: const InputDecoration(
//                   // labelText: "Trip ID",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Guest Name
//               TextField(
//                 controller: guestNameController,
//                 enabled: false,
//                 decoration: const InputDecoration(
//                   labelText: "Guest Name",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Guest Mobile Number
//               TextField(
//                 controller: guestMobileController,
//                 enabled: false,
//                 decoration: const InputDecoration(
//                   labelText: "Guest Mobile Number",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Vehicle Type
//               TextField(
//                 controller: vehicleTypeController,
//                 enabled: false,
//                 decoration: const InputDecoration(
//                   labelText: "Vehicle Type",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Starting Date
//               TextField(
//                 readOnly: true,
//                 enabled: false,
//                 controller: startDateController,
//                 decoration: const InputDecoration(
//                   labelText: "Starting Date",
//                   border: OutlineInputBorder(),
//                 ),
//                 // decoration: InputDecoration(
//                 //   hintText: startingDate == null
//                 //       ? "Select Starting Date"
//                 //       : "${startingDate!.toLocal()}".split(' ')[0],
//                 //   border: const OutlineInputBorder(),
//                 // ),
//               ),
//               const SizedBox(height: 16),
//
//               // Closing Date
//               TextField(
//                 readOnly: true,
//                 enabled: false,
//                 controller: closeDateController,
//                 decoration: const InputDecoration(
//                   labelText: "Closing Date",
//                   border: OutlineInputBorder(),
//                 ),
//
//                 // decoration: InputDecoration(
//                 //   hintText: closingDate == null
//                 //       ? "Select Closing Date"
//                 //       : "${closingDate!.toLocal()}".split(' ')[0],
//                 //   border: const OutlineInputBorder(),
//                 // ),
//               ),
//               const SizedBox(height: 16),
//
//               // Starting Kilometer
//               // Row(
//               //   children: [
//               //     Expanded(
//               //       child: TextField(
//               //         controller: startKmController,
//               //         enabled: isStartKmEnabled,
//               //         decoration: const InputDecoration(
//               //           labelText: "Starting Kilometer",
//               //           border: OutlineInputBorder(),
//               //         ),
//               //       ),
//               //     ),
//               //     const SizedBox(width: 8),
//               //
//               //     ElevatedButton(
//               //       style: ElevatedButton.styleFrom(
//               //         shape: RoundedRectangleBorder(
//               //           borderRadius: BorderRadius.circular(8),
//               //         ),
//               //       ),
//               //       onPressed: () => _chooseOption(context, 1),
//               //       child: const Text("Upload Image"),
//               //     ),
//               //     const SizedBox(height: 16),
//               //
//               //   ],
//               // ),
//               // const SizedBox(height: 16),
//               // _selectedImage1 != null
//               //     ? Image.file(
//               //   _selectedImage1!,
//               //   width: 200,
//               //   height: 200,
//               //   fit: BoxFit.cover,
//               // )
//               //     : const Text("No image selected for Button 1"),
//               // const SizedBox(height: 16),
//
//               // Closing Kilometer
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: closeKmController,
//                       enabled: isCloseKmEnabled,
//                       decoration: const InputDecoration(
//                         labelText: "Closing Kilometer",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     onPressed: () => _chooseOption(context, 2),
//                     child: const Text("Upload Image"),
//                   ),
//                 ],
//               ),
//               _selectedImage2 != null
//                   ? Image.file(
//                 _selectedImage2!,
//                 width: 200,
//                 height: 200,
//                 fit: BoxFit.cover,
//               )
//                   : const Text("No image selected for Button 2"),
//               const SizedBox(height: 16),
//
//
//               Padding(
//                 padding: const EdgeInsets.only(top: 16.0),
//                 child: SizedBox(
//                   width: double.infinity,
//                   // child:ElevatedButton(
//                   //   style: ElevatedButton.styleFrom(
//                   //     backgroundColor: Colors.green,
//                   //     shape: RoundedRectangleBorder(
//                   //       borderRadius: BorderRadius.circular(8),
//                   //     ),
//                   //     padding: const EdgeInsets.symmetric(vertical: 16),
//                   //   ),
//                   //   onPressed: ()  {
//                   //
//                   //     // Add your logic for toll and parking upload
//                   //     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TollParkingUpload()));
//                   //
//                   //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Signatureendride(tripId: widget.tripId,)));
//                   //   },
//                   //   // onPressed: _uploadImage,
//                   //
//                   //   child: const Text(
//                   //     "Upload Signature",
//                   //     style: TextStyle(fontSize: 16, color: Colors.white),
//                   //   ),
//                   // ),
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       // Validate the Starting Kilometer and Closing Kilometer fields and images
//
//
//                       // if (_selectedImage1 == null) {
//                       //   ScaffoldMessenger.of(context).showSnackBar(
//                       //     const SnackBar(content: Text("Please upload an image for Starting Kilometer")),
//                       //   );
//                       //   return;
//                       // }
//
//                       if (closeKmController.text.isEmpty) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Please enter the Closing Kilometer")),
//                         );
//                         return;
//                       }
//
//                       if (_selectedImage2 == null) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Please upload an image for Closing Kilometer")),
//                         );
//                         return;
//                       }
//
//
//                       final String dateSignature = DateTime.now().toIso8601String().split('T')[0] + ' ' + DateTime.now().toIso8601String().split('T')[1].split('.')[0];
//                       final String signTime = TimeOfDay.now().format(context); // Current time
//
//                       try {
//                         await ApiService.sendSignatureDetails(
//                           tripId: widget.tripId,
//                           dateSignature: dateSignature,
//                           signTime: signTime,
//                           status: "Accept",
//                         );
//
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text("Data uploaded successfully")),
//                         );
//
//
//
//                         // bool result = await ApiService.uploadstartingkm(
//                         //   tripid: widget.tripId, // Replace with actual trip ID
//                         //   documenttype: 'StartingKm',
//                         //   startingkilometer: _selectedImage1!,
//                         // );
//                         _handleSubmitStartClose();
//
//
//                       } catch (error) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text("Error uploading dataaaaaaaaaa: $error")),
//                         );
//                       }
//
//                       // Extract values from the controller and other sources
//                       final closeKm = closeKmController.text;
//                       final dutyValue = duty ?? ""; // Use the fetched duty value (default to "Local" if null)
//                       final hclValue = hcl ?? 0; // Use the fetched hcl value (default to 0 if null)
//
//                       try {
//                         // Call the API service
//                         await ApiService.updateCloseKMToTripDetailsUploadScreen(
//                           tripId: widget.tripId,
//                           closeKm: closeKm,
//                           hcl: hclValue,
//                           duty: dutyValue,
//                         );
//
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Closing Kilometer details updated successfully")),
//                         );
//                       } catch (error) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text("Error updating data: $error")),
//                         );
//                       }
//                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Signatureendride(tripId: widget.tripId,)));
//
//                     },
//                     child: Text("Upload Toll and Parking Data"),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }






















import 'dart:io';
import 'package:jessy_cabs/Screens/TripDetailsPreview/TripDetailsPreview.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:jessy_cabs/Networks/Api_Service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jessy_cabs/Screens/SignatureEndRide/SignatureEndRide.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:jessy_cabs/Bloc/App_Bloc.dart';
import 'package:jessy_cabs/Bloc/AppBloc_State.dart';
import 'package:jessy_cabs/Bloc/AppBloc_Events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jessy_cabs/GlobalVariable/global_variable.dart' as globals;
import 'package:jessy_cabs/Utils/AllImports.dart';

class TripDetailsUpload extends StatefulWidget {
  final String tripId;
  const TripDetailsUpload({Key? key, required this.tripId}) : super(key: key);

  @override
  State<TripDetailsUpload> createState() => _TripDetailsUploadState();
}

class _TripDetailsUploadState extends State<TripDetailsUpload> {

  bool isStartKmEnabled = true; // Only Start KM and Close KM are enabled
  bool isCloseKmEnabled = true;

  double? distance;
  String? timeDuration;

  final TextEditingController startKmController = TextEditingController();
  // final TextEditingController closeKmController = TextEditingController();

  TextEditingController guestNameController = TextEditingController();
  TextEditingController tripIdController = TextEditingController();
  TextEditingController guestMobileController = TextEditingController();
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController closeDateController = TextEditingController();
  TextEditingController closeKmController = TextEditingController();

  // late TextEditingController closeKmController;

  // File? _selectedImage1;
  File? _selectedImage2;
  int? _lastSelectedButton; // Tracks which button was last used
  final ImagePicker _picker = ImagePicker();
  Map<String, dynamic>? tripDetails;
  String? duty;
  int? hcl;
  late TripUploadBloc _tripUploadBloc;
  bool _isLoading = false; // Add this in your state
  bool _hasLoadedOnce = false;
  String? fetchedHybridData;
  String? startkmvalue;
  String? fetchdestination;
  String? fetchGuestEail;
  String? senderEmail;
  String? senderPass;
  String? fetchVechName;
  String? fetchVechNum;
  String? fetchdutyType;
  String? fetchaddress;
  String? fetchStart;
  String? fetchClose;




  String setFormattedDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "Not available"; // Handle null case

    try {
      DateTime parsedDate = DateTime.parse(dateStr); // Parse the date from DB
      return DateFormat('dd-MM-yyyy').format(parsedDate); // Format to dd/MM/yyyy
    } catch (e) {
      return "Invalid date"; // Handle errors
    }
  }
  @override
  void initState() {
    super.initState();
    _fetchTripDetails();
    closeKmController = TextEditingController();
    context.read<SenderInfoBloc>().add(FetchSenderInfo());
    _tripUploadBloc = TripUploadBloc();
    BlocProvider.of<GettingClosingKilometerBloc>(context).add(FetchClosingKilometer(widget.tripId));
    _loadTripSheetDetailsByTripId();
    context.read<GetDurationBloc>().add(FetchDuration(tripId: widget.tripId));
    saveScreenData();

    _reloadScreen();



  }





  void _reloadScreen() {
    if (!_hasLoadedOnce) {
      // Perform the reload or initialization logic here
      print("Screen reloaded one time!");
      // Simulate data fetching or any necessary operation
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _hasLoadedOnce = true;
        });
      });
    }
  }


  Future<void> saveScreenData() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('last_screen', 'TripDetailsUpload');

    await prefs.setString('trip_id', widget.tripId);





    print('Saved screen data:');

    print('last_screen: TripDetailsUpload');

    print('trip_id: ${widget.tripId}');



  }


  Future<void> _fetchTripDetails() async {
    BlocProvider.of<GettingClosingKilometerBloc>(context).add(FetchClosingKilometer(widget.tripId));
    _loadTripSheetDetailsByTripId();
    _StartCloseKm();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? tripDetailsJson = prefs.getString('tripDetails');

    if (tripDetailsJson != null) {
      Map<String, dynamic> tripDetails = json.decode(tripDetailsJson);

      hcl = tripDetails['Hybriddata']; // Assuming `hcl` is part of the trip details
      duty = tripDetails['duty']; // Assuming `duty` is part of the trip details
      setState(() {
        // Update the controllers with the values
        // guestMobileController.text = tripDetails['guestmobileno'] ?? 'Not available';
        // guestNameController.text = tripDetails['guestname'] ?? 'Not available';
        // tripIdController.text = tripDetails['tripid'].toString()  ?? 'Not available';
        // vehicleTypeController.text = tripDetails['vehicleName'] ?? 'Not available';
        // // startDateController.text = tripDetails['startdate'] ?? 'Not available';
        // startDateController.text = setFormattedDate(tripDetails['startdate']); // Assuming 'startdate' is from the database;
        // // closeDateController.text = tripDetails['closeDate'] ?? 'Not available';
        // closeDateController.text = setFormattedDate(tripDetails['closedate']);

      });
    } else {
      print('No trip details found in shared preferences.');
    }
  }


  // @override
  // void initState() {
  //   super.initState();
  //   _StartCloseKm();
  //   _fetchTripDetails();
  //   closeKmController = TextEditingController();
  //
  //   _tripUploadBloc = TripUploadBloc();
  //   BlocProvider.of<GettingClosingKilometerBloc>(context).add(FetchClosingKilometer(widget.tripId));
  //   _loadTripSheetDetailsByTripId();
  //   _StartCloseKm();
  //
  // }

  Future<void> _loadTripSheetDetailsByTripId() async {
    try {
      // Fetch trip details from the API
      final tripDetails = await ApiService.fetchTripDetails(widget.tripId);
      print('Trip details fetchedddd: $tripDetails');
      if (tripDetails != null) {

        fetchedHybridData = tripDetails['Hybriddata'].toString();
        var fetchedStartkmvalue = tripDetails['startkm'].toString();
        var fetcheddestination = tripDetails['useage'].toString();
        var fetchedtripid = tripDetails['tripid'].toString();

        var fetchedguestname = tripDetails['guestname'].toString();

        var fetchedguestmobile = tripDetails['guestmobileno'].toString();

        var fetchedvechtype = tripDetails['vehicleName'].toString();

        var fetchedStartdate = tripDetails['startdate'].toString();

        var fetchedClosedate = tripDetails['closedate'].toString();

        var fetchedClosedkm = tripDetails['closekm'].toString();
        var fetchedGuestemail = tripDetails['email'].toString();
        var fetchedVechName = tripDetails['vehicleName'].toString();
        var fetchedVechNum = tripDetails['vehRegNo'].toString();
        var fetchedDutyType = tripDetails['duty'].toString();
        var fetchedAddress = tripDetails['address1'].toString();
        var fetchedstarttime = tripDetails['starttime'].toString();
        var fetchedclosetime = tripDetails['closetime'].toString();


        print('Fetched startkmvalue: $fetchedStartkmvalue');
        if (!mounted) return;
        setState(() {
          print('aaaaaaaaaaaaaaaaaaaaa');


           // startkmvalue = fetchedStartkmvalue;
           //
           // double startKm = double.parse(fetchedStartkmvalue);
           // double endKm = double.parse(fetchedClosedkm);
           //
           // distance = startKm - endKm;

          try {
            double startKm = double.tryParse(fetchedStartkmvalue) ?? 0;
            double endKm = double.tryParse(fetchedClosedkm) ?? 0;
            distance = startKm - endKm;
            print('Distance: $distance');
          } catch (e) {
            print('❌ Error parsing km values: $e');
          }




          // print('between distance${distance}');


            fetchGuestEail = fetchedGuestemail ?? '';
            fetchdestination = fetcheddestination ?? '';
            fetchVechName = fetchedVechName ?? '';
           fetchVechNum = fetchedVechNum ?? '';
           fetchdutyType = fetchedDutyType ?? '';
           fetchaddress = fetchedAddress ?? '';
           fetchStart = fetchedstarttime ?? '';
           fetchClose = fetchedclosetime ?? '';

           print('between distance${fetchGuestEail}');
           print('between distance${fetchdestination}');
           print('between distance${fetchVechName}');
           print('between distance${fetchVechNum}');
           print('between distance${fetchdutyType}');

           print('between distance${fetchaddress}');
           print('between distance${fetchStart}');
           print('between distance${fetchClose}');



           tripIdController.text = fetchedtripid ?? '';

           guestNameController.text = fetchedguestname ?? '';

           guestMobileController.text = fetchedguestmobile ?? '';

           vehicleTypeController.text = fetchedvechtype ?? '';

           // startDateController.text = fetchedStartdate ?? '';

           // closeDateController.text = fetchedguestmobile ?? '';

           closeKmController.text = fetchedClosedkm ?? '';
          // Populate the form fields with the fetched data

          // startKmController.text = startkmvalue ?? '';

           var fetchStartDate = fetchedStartdate ?? '';

           List<String> parts = fetchStartDate.split('-');

           final formStartDate = "${parts[2]}-${parts[1]}-${parts[0]}";

           startDateController.text = formStartDate;

           print("FormDate Start $formStartDate");

           var fetchCloseDate = fetchedClosedate ?? '';

           List<String> partss = fetchCloseDate.split('-');

           final formCloseDate = "${partss[2]}-${partss[1]}-${partss[0]}";

           closeDateController.text = formCloseDate;



        });
        _StartCloseKm();


      } else {
        print('No trip details found.');
      }
    } catch (e) {
      print('Error loading trip details: $e');
    }
  }

  Future<void> _StartCloseKm() async {
    int roundedDistance = globals.savedTripDistance.round();
    // int roundedDistance = 13;
    print('Rounded Trip Distance: $roundedDistance');

    if (startkmvalue != null) {
      // Use startkmvalue as needed
      print('Using startkmvalue in another function: $startkmvalue');

      int startKmInt = int.parse(startkmvalue!); // Convert string to int
      int totalDistance = startKmInt + roundedDistance;
      print('Total Distance (start + rounded): $totalDistance');
      closeKmController.text = totalDistance.toString();

      // closeKmController = TextEditingController(text: totalDistance.toString());
    } else {
      print('startkmvalue is not available.');
    }
  }

  // Future<void> _refresh

  // Function to choose an image for a specific button
  Future<void> _chooseOption(BuildContext context, int buttonId) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Open Camera"),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image =
                  await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      _lastSelectedButton = buttonId;
                      // if (buttonId == 1) {
                      //   _selectedImage1 = File(image.path);
                      // } else
                      if (buttonId == 2) {
                        _selectedImage2 = File(image.path);
                      }
                    });
                  }
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.photo_library),
              //   title: const Text("Upload File"),
              //   onTap: () async {
              //     Navigator.of(context).pop();
              //     final XFile? image =
              //     await _picker.pickImage(source: ImageSource.gallery);
              //     if (image != null) {
              //       setState(() {
              //         _lastSelectedButton = buttonId;
              //         // if (buttonId == 1) {
              //         //   _selectedImage1 = File(image.path);
              //         // } else
              //         if (buttonId == 2) {
              //           _selectedImage2 = File(image.path);
              //         }
              //       });
              //     }
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }


  Future<void> _handleClosingKmSubmit() async {
    // Call the API to upload the Toll file
    bool result = await ApiService.uploadClosingkm(
      tripid: widget.tripId, // Replace with actual trip ID
      documenttype: 'ClosingKm',
      closingkilometer: _selectedImage2!,
    );

  }

  Future<void> _handleClosingKmTextSubmit() async {
    final String dateSignature = DateTime.now().toIso8601String().split('T')[0] + ' ' + DateTime.now().toIso8601String().split('T')[1].split('.')[0];
    final String signTime = TimeOfDay.now().format(context); // Current time

    try {
      await ApiService.sendSignatureDetails(
        tripId: widget.tripId,
        dateSignature: dateSignature,
        signTime: signTime,
        status: "Accept",
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data uploaded successfully")),
      );

      // _handleSubmitStartClose();

    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading dataaaaaaaaaa: $error")),
      );
    }
  }
  Future<void> _handleSignatureStatus() async {
    // Extract values from the controller and other sources
    final closeKm = closeKmController.text;
    final dutyValue = duty ?? ""; // Use the fetched duty value (default to "Local" if null)
    final hclValue = hcl ?? 0; // Use the fetched hcl value (default to 0 if null)

    try {
      // Call the API service
      await ApiService.updateCloseKMToTripDetailsUploadScreen(
        tripId: widget.tripId,
        closeKm: closeKm,
        hcl: hclValue,
        duty: dutyValue,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Closing Kilometer details updated successfully")),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating data: $error")),
      );
    }
  }


  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    closeKmController.dispose();
    super.dispose();
  }

    // Future<void> _handleSubmitStartClose() async {
  //   bool result = await ApiService.updateTripDetailsStartandClosekm(
  //     tripid: widget.tripId, // Pass the trip ID
  //     startingkm: startKmController.text,
  //     closigkm: closeKmController.text,
  //   );
  //
  //   // _handleStartingKmSubmit();
  //   _handleClosingKmSubmit();
  //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Signatureendride(tripId: widget.tripId,)));
  //
  // }


  //
  // Future<void> _loadTripDetails() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   // Retrieve the JSON string
  //   String? tripDetailsJson = prefs.getString('tripDetails');
  //
  //   if (tripDetailsJson != null) {
  //     setState(() {
  //       // Decode the JSON string into a Dart map
  //       tripDetails = json.decode(tripDetailsJson);
  //       // tripIdController.text = tripDetails['tripid'] ?? 'Not available';
  //
  //     });
  //   } else {
  //     print('No trip details found in local storage.');
  //   }
  // }






  // @override
  // Widget build(BuildContext context) {
  //   return BlocProvider(
  //       create: (context) => _tripUploadBloc,
  //       child:
  //     Scaffold(
  //     appBar: AppBar(
  //       title: const Text("Trip Details Upload"),
  //     ),
  //       body: BlocListener<TripUploadBloc, TripUploadState>(
  //           listener: (context, state) {
  //             if (state is TripUploadSuccess) {
  //
  //               showSuccessSnackBar(context, state.message);
  //             } else if (state is TripUploadFailure) {
  //
  //               showFailureSnackBar(context, state.error);
  //             }
  //           },
  //           child:
  //            RefreshIndicator(
  //           onRefresh: _fetchTripDetails, // Calls the function to reload data
  //           child: SingleChildScrollView(
  //             physics: const AlwaysScrollableScrollPhysics(), // Enables scroll even when content is less
  //
  //             child: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           children: [
  //             // Trip ID
  //
  //             TextField(
  //               controller: tripIdController,
  //               enabled: false,
  //               decoration: const InputDecoration(
  //                 // labelText: "Trip ID",
  //                 border: OutlineInputBorder(),
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //
  //             // Guest Name
  //             TextField(
  //               controller: guestNameController,
  //               enabled: false,
  //               decoration: const InputDecoration(
  //                 labelText: "Guest Name",
  //                 border: OutlineInputBorder(),
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //
  //             // Guest Mobile Number
  //             TextField(
  //               controller: guestMobileController,
  //               enabled: false,
  //               decoration: const InputDecoration(
  //                 labelText: "Guest Mobile Number",
  //                 border: OutlineInputBorder(),
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //
  //             // Vehicle Type
  //             TextField(
  //               controller: vehicleTypeController,
  //               enabled: false,
  //               decoration: const InputDecoration(
  //                 labelText: "Vehicle Type",
  //                 border: OutlineInputBorder(),
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //
  //             // Starting Date
  //             TextField(
  //               readOnly: true,
  //               enabled: false,
  //               controller: startDateController,
  //               decoration: const InputDecoration(
  //                 labelText: "Starting Date",
  //                 border: OutlineInputBorder(),
  //               ),
  //
  //             ),
  //             const SizedBox(height: 16),
  //
  //             // Closing Date
  //             TextField(
  //               readOnly: true,
  //               enabled: false,
  //               controller: closeDateController,
  //               decoration: const InputDecoration(
  //                 labelText: "Closing Date",
  //                 border: OutlineInputBorder(),
  //               ),
  //
  //
  //             ),
  //             const SizedBox(height: 16),
  //
  //             // Closing Kilometer
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: TextField(
  //                     controller: closeKmController,
  //                     enabled: isCloseKmEnabled,
  //                     decoration: const InputDecoration(
  //                       labelText: "Closing Kilometer",
  //                       border: OutlineInputBorder(),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 8),
  //                 ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(8),
  //                     ),
  //                   ),
  //                   onPressed: () => _chooseOption(context, 2),
  //                   child: const Text("Upload Image"),
  //                 ),
  //               ],
  //             ),
  //             _selectedImage2 != null
  //                 ? Image.file(
  //               _selectedImage2!,
  //               width: 200,
  //               height: 200,
  //               fit: BoxFit.cover,
  //             )
  //                 : const Text("No image selected for Button 2"),
  //             const SizedBox(height: 16),
  //
  //
  //             Padding(
  //               padding: const EdgeInsets.only(top: 16.0),
  //               child: SizedBox(
  //                 width: double.infinity,
  //                 child: ElevatedButton(
  //                   // onPressed: () async {
  //                   //   // Validate the Starting Kilometer and Closing Kilometer fields and images
  //                   //
  //                   //
  //                   //   // if (closeKmController.text.isEmpty) {
  //                   //   //   ScaffoldMessenger.of(context).showSnackBar(
  //                   //   //     const SnackBar(content: Text("Please enter the Closing Kilometer")),
  //                   //   //   );
  //                   //   //   return;
  //                   //   // }
  //                   //   //
  //                   //   // if (_selectedImage2 == null) {
  //                   //   //   ScaffoldMessenger.of(context).showSnackBar(
  //                   //   //     const SnackBar(content: Text("Please upload an image for Closing Kilometer")),
  //                   //   //   );
  //                   //   //   return;
  //                   //   // }
  //                   //
  //                   //
  //                   //   _handleClosingKmTextSubmit();
  //                   //   _handleClosingKmSubmit();
  //                   //   _handleSignatureStatus();
  //                   //
  //                   //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Signatureendride(tripId: widget.tripId,)));
  //                   //
  //                   // },
  //                   onPressed: () {
  //                     // if (closeKmController.text.isEmpty || _selectedImage2 == null) {
  //                     //
  //                     //   showWarningSnackBar(context, 'Please upload closing kilometer and image');
  //                     //   return;
  //                     // }
  //                     //
  //                     // _tripUploadBloc.add(UploadClosingKmText(tripId: widget.tripId));
  //                     // _tripUploadBloc.add(UploadClosingKmImage(tripId: widget.tripId, image: _selectedImage2!));
  //                     // final dutyValue = duty ?? ""; // Use the fetched duty value (default to "Local" if null)
  //                     // final hclValue = hcl ?? 0; //
  //                     // _tripUploadBloc.add(UpdateSignatureStatus(
  //                     //   tripId: widget.tripId,
  //                     //   closeKm: closeKmController.text,
  //                     //   duty: dutyValue,
  //                     //   hcl: hclValue,
  //                     // ));
  //
  //
  //                     _tripUploadBloc.add(UploadClosingKmText(tripId: widget.tripId));
  //
  //                                               if (_selectedImage2 != null) {
  //                                                 _tripUploadBloc.add(UploadClosingKmImage(tripId: widget.tripId, image: _selectedImage2!));
  //                                               }
  //
  //                                               final dutyValue = duty ?? "";
  //                                               final hclValue = hcl ?? 0;
  //
  //                                               _tripUploadBloc.add(UpdateSignatureStatus(
  //                                                 tripId: widget.tripId,
  //                                                 closeKm: closeKmController.text,
  //                                                 duty: dutyValue,
  //                                                 hcl: hclValue,
  //                                               ));
  //
  //                        Navigator.push(context, MaterialPageRoute(builder: (context)=>TripDetailsPreview(tripId: widget.tripId,)));
  //
  //
  //                   },
  //                   child: Text("Upload Toll and Parking Data"),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ))),
  //   )
  //   );
  // }

  // Function to pick image from camera or gallery
  Future<void> _pickFile(ImageSource source) async {
    final XFile? file = await _picker.pickImage(source: source);
    if (file != null) {
      setState(() {
        _selectedImage2 = File(file.path);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _tripUploadBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Uploading Closing Kilometers"),
          automaticallyImplyLeading: false,

        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<TripUploadBloc, TripUploadState>(
              listener: (context, state) {
                if (state is TripUploadSuccess) {
                  showSuccessSnackBar(context, state.message);
                } else if (state is TripUploadFailure) {
                  showFailureSnackBar(context, state.error);
                }
              },
            ),
            BlocListener<GettingClosingKilometerBloc, GettingClosingKilometerState>(
              listener: (context, state) {
                if (state is ClosingKilometerLoaded) {
                  print("object is coming inside");

                } else if (state is ClosingKilometerError) {
                  print("Error fetching closing kilometerrrs: ${state.error}");
                }
              },
            ),
            BlocListener<EmailBloc, EmailState>(
              listener: (context, state) {
                if (state is EmailSent) {
                  print("yeeeee");
                  showSuccessSnackBar(context, "✅ Email Sent Successfully");
                } else if (state is EmailFailed) {
                  print("neeeee");

                  showFailureSnackBar(context, "❌ Email Sending Failed");
                }
              },
            ),
            BlocListener<SenderInfoBloc, SenderInfoState>(
              listener: (context, state) {
                if (state is SenderInfoSuccess) {
                  setState(() {
                    senderEmail = state.senderMail;
                    senderPass = state.senderPass;
                    print('In tracking page setState ${state.senderMail}');
                    print('In tracking page setState ${state.senderPass}');
                  });
                }
                },
            ),

            BlocListener<GetDurationBloc, GetDurationState>(
                listener: (context, state){
                  if(state is GetDurationSuccess){
                    print("Duration is: ${state.data}");
                    setState(() {
                      timeDuration = state.data;
                    });
                  }
                })

          ],
          child: RefreshIndicator(
            onRefresh: _fetchTripDetails, // Calls the function to reload data
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: tripIdController,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: "Trip Id",


                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: guestNameController,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: "Guest Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: guestMobileController,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: "Guest Mobile Number",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: vehicleTypeController,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: "Vehicle Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      readOnly: true,
                      enabled: false,
                      controller: startDateController,
                      decoration: const InputDecoration(
                        labelText: "Starting Date",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      readOnly: true,
                      enabled: false,
                      controller: closeDateController,
                      decoration: const InputDecoration(
                        labelText: "Closing Date",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    //  Text(
                    //   "Stored Distance: ${globals.savedTripDistance.toStringAsFixed(2)} km",
                    //   style: TextStyle(fontSize: 18),
                    // ),
                    // const SizedBox(height: 16),
                    //
                    // Text(
                    //   "Rounded Distance : ${globals.savedTripDistance.round()} km",
                    //   style: TextStyle(fontSize: 18),
                    // ),


                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            readOnly: fetchedHybridData !='1' ? false : true,  // is this value will be 0 we can write
                            enabled: fetchedHybridData != '1',  // expected : enable = 0;
                            controller: closeKmController,
                            // enabled: isCloseKmEnabled,
                            decoration: const InputDecoration(
                              labelText: "Closing Kilometer",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          // onPressed: () => _chooseOption(context, 2),
                          onPressed: () => _pickFile(ImageSource.camera),

                          child: const Text("Upload Image"),
                        ),
                      ],
                    ),
                    // _selectedImage2 != null
                    //     ? Image.file(
                    //   _selectedImage2!,
                    //   width: 200,
                    //   height: 200,
                    //   fit: BoxFit.cover,
                    // )
                    //     : const Text("No image selected for Button 2"),

                    if (_selectedImage2 != null)
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
                                  _selectedImage2!,
                                  height: 200,
                                  width: double.infinity,
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
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.Navblue1, // Navy blue
                            foregroundColor: Colors.white, // Text color
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _isLoading ? null : () {
                            setState(() {
                              _isLoading = true;
                            });

                            // if (closeKmController.text.isEmpty || _selectedImage2 == null) {
                            //
                            //   showWarningSnackBar(context, 'Please upload closing kilometer and image');
                            //   return;
                            // }
                            // _tripUploadBloc.add(UploadClosingKmText(tripId: widget.tripId));
                            // _tripUploadBloc.add(UploadClosingKmImage(tripId: widget.tripId, image: _selectedImage2!));
                            // final dutyValue = duty ?? "";
                            // final hclValue = hcl ?? 0;
                            // _tripUploadBloc.add(UpdateSignatureStatus(
                            //   tripId: widget.tripId,
                            //   closeKm: closeKmController.text,
                            //   duty: dutyValue,
                            //   hcl: hclValue,
                            // ));

                            context.read<EmailBloc>().add(SendEmailEvent(
                              guestName: "${guestNameController.text}",
                              guestMobileNo: "${fetchdestination}",
                              email: "${fetchGuestEail}",
                              startKm: "${startkmvalue}",
                              closeKm: "${globals.savedTripDistance.round()}",
                              duration: "${timeDuration}",
                              senderEmail: '${senderEmail}',
                              senderPassword: '${senderPass}',
                              TripId: '${widget.tripId}',
                              dutytype: '${fetchdutyType}',
                              Vechnum: '${fetchVechNum}',
                              Endpoint: '${fetchdestination}',
                              ReleaseDate: '${closeDateController.text}',
                              ReleaseTime: '${fetchClose}',
                              ReportDate: '${startDateController.text}',
                              ReportTime: '${fetchStart}',
                              Startpoint: '${fetchaddress}',
                              Vechname: '${fetchVechName}', // Gmail App Password
                            ));

                            _tripUploadBloc.add(UploadClosingKmText(tripId: widget.tripId));

                            if (_selectedImage2 != null) {
                              _tripUploadBloc.add(UploadClosingKmImage(tripId: widget.tripId, image: _selectedImage2!));
                            }

                            final dutyValue = duty ?? "";
                            final hclValue = hcl ?? 0;

                            _tripUploadBloc.add(UpdateSignatureStatus(
                              tripId: widget.tripId,
                              closeKm: closeKmController.text,
                              duty: dutyValue,
                              hcl: hclValue,
                            ));

                          // ✅ Always navigate, no matter what



                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TripDetailsPreview(tripId: widget.tripId),
                                ),
                              );
                            });

                          },
                          // child: Text("Upload Toll and Parking Data"),
                          child:  _isLoading
                              ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : Text("Next"),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


}