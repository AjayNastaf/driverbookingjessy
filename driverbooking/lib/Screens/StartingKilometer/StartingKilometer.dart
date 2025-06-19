import 'dart:io';
import 'package:jessy_cabs/Screens/TrackingPage/TrackingPage.dart';
import 'package:jessy_cabs/Screens/TrackingWithOutHcl/TrackingWithOutHcl.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../PickupScreen/PickupScreen.dart';
import '../NoInternetBanner/NoInternetBanner.dart';
import 'package:provider/provider.dart';
import '../network_manager.dart';
import 'package:flutter/services.dart';
import 'package:jessy_cabs/Bloc/App_Bloc.dart';

import 'package:jessy_cabs/Bloc/AppBloc_Events.dart';

import 'package:jessy_cabs/Bloc/AppBloc_State.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class StartingKilometer extends StatefulWidget {
  final String address;
  final String tripId;

  const StartingKilometer({super.key, required this.tripId, required this.address});

  @override
  State<StartingKilometer> createState() => _StartingKilometerState();
}

class _StartingKilometerState extends State<StartingKilometer>  {


  String guestMobileNumber = '';

  String guestEmail = '';
  // final TextEditingController _startKM = TextEditingController();
  TextEditingController _startKM = TextEditingController(text: "0");

  File? _selectedFile;
  final ImagePicker _picker = ImagePicker();
  String? duty;
  int? hclhybriddata;



  @override
  void initState() {
    super.initState();
    _refreshData();
    _loadTripDetailsData();
    saveScreenData();
  }

  Future<void> _refreshData() async {
    _loadTripDetailsData();

  }

  Future<void> saveScreenData() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('last_screen', 'startingkm');

    await prefs.setString('trip_id', widget.tripId);

    await prefs.setString('address', widget.address);





    print('Saved screen data:');

    print('last_screen: startingkm');

    print('trip_id: ${widget.tripId}');

    print('address: ${widget.address}');



  }



  Future<void> _loadTripDetailsData() async {
    try {
      // Fetch trip details from the API
      final tripDetails = await ApiService.fetchTripDetails(widget.tripId);
      print('Trip details values: $tripDetails');
      if (tripDetails != null) {

        // var tripIdvalue = tripDetails['tripid'].toString();
        // hclhybriddata = tripDetails['Hybriddata'];
        // duty = tripDetails['duty'];
        // print('Trip details guest: $hclhybriddata');
        // print('Trip details guest: $hclhybriddata ');
        setState(() {
          var tripIdvalue = tripDetails['tripid'].toString();
          hclhybriddata = tripDetails['Hybriddata'];
          duty = tripDetails['duty'];
          guestMobileNumber= tripDetails['guestmobileno'];
          guestEmail= tripDetails['email'];

          print("guest ${guestMobileNumber}");
          print('guest ${guestEmail}');
          print('Trip details guest: $duty');
        });

      } else {
        print('No trip details found.');
      }
    } catch (e) {
      print('Error loading trip details: $e');
    }
  }






  // Function to pick image from camera or gallery
  Future<void> _pickFile(ImageSource source) async {
    final XFile? file = await _picker.pickImage(source: source);
    if (file != null) {
      setState(() {
        _selectedFile = File(file.path);
      });
    }
  }

  // Future<void> _handleStartingKmImageSubmit() async {
  //   // Call the API to upload the Toll file
  //   print("inside the function");
  //   bool result = await ApiService.uploadstartingkm(
  //     tripid: widget.tripId, // Replace with actual trip ID
  //     documenttype: 'StartingKm',
  //     startingkilometer: _selectedFile!,
  //   );
  //   print("after the function");
  // }

  // Future<void> _handleStartingKmTextSubmit() async {
  //   // Extract values from the controller and other sources
  //   final startKm = _startKM.text;
  //   final dutyValue = duty ?? ""; // Use the fetched duty value (default to "Local" if null)
  //   final hclValue = hclhybriddata ?? 0; // Use the fetched hcl value (default to 0 if null)
  //
  //   try {
  //     // Call the API service
  //     await ApiService.updateStartinKMToSratingkmScreen(
  //       tripId: widget.tripId,
  //       startKm: startKm,
  //       hcl: hclValue,
  //       duty: dutyValue,
  //     );
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Kilometer details updated successfully")),
  //     );
  //
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => Pickupscreen(
  //           address: widget.address,
  //           tripId: widget.tripId,
  //         ),
  //       ),
  //     );
  //
  //
  //   } catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error updating data: $error")),
  //     );
  //   }
  // }

  // // Navigate to next screen
  Future<void> _goToNextScreen() async {
    print("object");

    if (_selectedFile != null) {
      context.read<StartKmBloc>().add(
        UploadStartingKilometerImage(
          tripId: widget.tripId,
          startingKilometerImage: _selectedFile!,
        ),
      );
    } else {
      print("Error: No image selected");
    }

    context.read<StartKmBloc>().add(
      SubmitStartingKilometerText(
        tripId: widget.tripId,
        startKm: _startKM.text,
        hclValue: hclhybriddata.toString(),
        dutyValue: duty ?? "",
      ),
    );


    if (hclhybriddata == 1) {

      Navigator.pushAndRemoveUntil(

        context,

        MaterialPageRoute(builder: (_) => TrackingPage(address: widget.address, tripId: widget.tripId)),

            (route) => false,

      );

    }

    else {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TrackingWithOutHcl(address: widget.address, tripId: widget.tripId),
      ), (route) => false
  );

}
  }

  @override
  Widget build(BuildContext context) {
    bool isConnected = Provider.of<NetworkManager>(context).isConnected;

    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Starting Kilometer", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, )),
        backgroundColor: AppTheme.Navblue1,
        // iconTheme: IconThemeData(color: AppTheme.white1),
        automaticallyImplyLeading: false,
        elevation: 2,
      ),
      body: Stack(
        children: [

      RefreshIndicator(
        onRefresh: () async {
          await _loadTripDetailsData();
          setState(() {}); // Update UI after refreshing
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),

          child:
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

        // Text Field with better styling
            TextField(
              controller: _startKM,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly, // ✅ allows only digits (0-9)
              ],
              enabled: hclhybriddata != 1, // disable when value is 1
              decoration: InputDecoration(
                hintText: "Starting Kilometer",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
            SizedBox(height: 24),

            // Camera & Upload buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickFile(ImageSource.camera),
                    icon: Icon(Icons.camera_alt),
                    // label: Text("Open Camera"),
                    label: Text("Upload File"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

                    ),
                  ),
                ),
                // ElevatedButton.icon(
                //   onPressed: () => _pickFile(ImageSource.gallery),
                //   icon: Icon(Icons.upload_file),
                //   label: Text("Upload File"),
                //   style: ElevatedButton.styleFrom(
                //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 24),

            // Image Preview inside a card
            if (_selectedFile != null)
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
                          _selectedFile!,
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

            // Spacer(),

            BlocConsumer<StartKmBloc, StartKmState>(
              listener: (context, state) {
                if (state is StartKmTextSubmitted) {
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("KM Submitted Successfully")));
                  showSuccessSnackBar(context, "KM Submitted Successfully");
                } else if (state is StartKmImageUploaded) {
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image Uploaded Successfully")));
                  showSuccessSnackBar(context, "Image Uploaded Successfully");
                } else if (state is StartKmError) {
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                  showFailureSnackBar(context, state.message);
                }
              },
              builder: (context, state) {
                if (state is StartKmTextLoading || state is StartKmImageUploading) {
                  return CircularProgressIndicator();
                }

                return  ElevatedButton(

             onPressed: _goToNextScreen,
             //      onPressed: () {
             //        // if (_startKM.text.isEmpty){
             //        //
             //        //   showWarningSnackBar(context, "Please enter the Starting Kilometer");
             //        //   return;
             //        // }
             //        //
             //        // if(_selectedFile == null){
             //        //
             //        //   showWarningSnackBar(context, "Please Select Starting Kilometer image");
             //        //   return;
             //        //
             //        // }
             //
             //
             //        // if (_selectedFile != null && _startKM.text.isNotEmpty) {
             //        //   context.read<StartKmBloc>().add(
             //        //     UploadStartingKilometerImage(tripId: widget.tripId, startingKilometerImage: _selectedFile!),
             //        //   );
             //        //
             //        //   context.read<StartKmBloc>().add(
             //        //     SubmitStartingKilometerText(
             //        //       tripId: widget.tripId,
             //        //       startKm: _startKM.text,
             //        //       hclValue: hclhybriddata.toString(),
             //        //       dutyValue: duty ?? "",
             //        //     ),
             //        //   );
             //        //
             //        //
             //        //   Navigator.push(
             //        //     context,
             //        //     MaterialPageRoute(
             //        //       builder: (context) => Pickupscreen(
             //        //         address: widget.address,
             //        //         tripId: widget.tripId,
             //        //       ),
             //        //     ),
             //        //   );
             //        //
             //        // }
             //
             //      },



          style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.Navblue1,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            minimumSize: Size(double.infinity, 50), // Full width

          ),
          child: Text(
          "Upload & Next",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );

  },
  ),

          ],
        ),
      ),),
    ),

          Positioned(
            top: 15,
            left: 0,
            right: 0,
            child: NoInternetBanner(isConnected: isConnected),
          ),

        ],
      ),
    );
  }



  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text("Upload File")),
  //     body: Padding(
  //       padding: const EdgeInsets.all(20.0),
  //       child: Column(
  //         children: [
  //           TextField(controller: _startKM, decoration: InputDecoration(hintText: "Enter Kilometer")),
  //           SizedBox(height: 20),
  //
  //           // Buttons for Image Selection
  //           Row(
  //             children: [
  //               ElevatedButton.icon(onPressed: () => _pickFile(ImageSource.camera), icon: Icon(Icons.camera_alt), label: Text("Camera")),
  //               ElevatedButton.icon(onPressed: () => _pickFile(ImageSource.gallery), icon: Icon(Icons.upload_file), label: Text("Gallery")),
  //             ],
  //           ),
  //           SizedBox(height: 20),
  //
  //           // Image Preview
  //           if (_selectedFile != null)
  //             Image.file(_selectedFile!, height: 200),
  //
  //           BlocConsumer<StartKmBloc, StartKmState>(
  //             listener: (context, state) {
  //               if (state is StartKmTextSubmitted) {
  //                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("KM Submitted Successfully")));
  //               } else if (state is StartKmImageUploaded) {
  //                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image Uploaded Successfully")));
  //               } else if (state is StartKmError) {
  //                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
  //               }
  //             },
  //             builder: (context, state) {
  //               if (state is StartKmTextLoading || state is StartKmImageUploading) {
  //                 return CircularProgressIndicator();
  //               }
  //
  //               return ElevatedButton(
  //                 onPressed: () {
  //                   context.read<StartKmBloc>().add(
  //                     SubmitStartingKilometerText(
  //                       tripId: widget.tripId,
  //                       startKm: _startKM.text,
  //                       hclValue: hclhybriddata.toString(),
  //                       dutyValue: duty ?? "",
  //                     ),
  //                   );
  //
  //                   if (_selectedFile != null) {
  //                     context.read<StartKmBloc>().add(
  //                       UploadStartingKilometerImage(tripId: widget.tripId, startingKilometerImage: _selectedFile!),
  //                     );
  //                   }
  //                 },
  //                 child: Text("Submit"),
  //               );
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
