import 'package:jessy_cabs/Screens/CustomerLocationReached/CustomerLocationReached.dart';
import 'package:jessy_cabs/Screens/HomeScreen/HomeScreen.dart';
import 'package:jessy_cabs/Screens/LoginScreen/Login_Screen.dart';
import 'package:jessy_cabs/Screens/TollParkingUpload/TollParkingUpload.dart';
import 'package:jessy_cabs/Screens/TrackingPage/TrackingPage.dart';
import 'package:jessy_cabs/Screens/TripDetailsPreview/TripDetailsPreview.dart';
import 'package:jessy_cabs/Screens/TripDetailsUpload/TripDetailsUpload.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:jessy_cabs/Networks/Api_Service.dart';
import 'dart:convert'; // Add this import at the top of your file
import 'package:jessy_cabs/Bloc/AppBloc_State.dart';
import 'package:jessy_cabs/Bloc/AppBloc_Events.dart';
import 'package:jessy_cabs/Bloc/App_Bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../NoInternetBanner/NoInternetBanner.dart';
import 'package:provider/provider.dart';
import '../network_manager.dart';


import 'package:jessy_cabs/Screens/VerifyOtp/VerifyOtp.dart';
import 'package:jessy_cabs/Screens/MenuListScreens/Notifications/NotificationScreen.dart';

class Signatureendride extends StatefulWidget {
  final String tripId; // Accept tripid here
  const Signatureendride({super.key,required this.tripId});

  @override
  State<Signatureendride> createState() => _SignatureendrideState();
}

class _SignatureendrideState extends State<Signatureendride>  {
  String guestMobileNumber = '';

  String guestEmail = '';

  String guestName = '';

  bool _isLoading = false;
  bool isClearDisabled = false;
  String hybridata = '';



  String? senderEmail;
  String?senderPass;

  // Controller for the signature pad
  final SignatureController _signatureController = SignatureController(
    penColor: Colors.black,
    penStrokeWidth: 3,
  );


  @override
  void initState() {
    super.initState();
    saveScreenData();
    context.read<SenderInfoBloc>().add(FetchSenderInfo());
    _loadTripDetailsData();
    // Trigger API call when drawing ends
    _signatureController.onDrawEnd = () async {
      if (_signatureController.isNotEmpty) {
        final String dateSignature = DateTime.now().toIso8601String().split('T')[0] + ' ' + DateTime.now().toIso8601String().split('T')[1].split('.')[0];
        // final String signTime = TimeOfDay.now().format(context);
        final DateTime now = DateTime.now();
        final String signTime = '${now.hour.toString().padLeft(2, '0')}:'
            '${now.minute.toString().padLeft(2, '0')}:'
            '${now.second.toString().padLeft(2, '0')}';

        try {
          await ApiService.sendSignatureDetails(
            tripId: widget.tripId,
            dateSignature: dateSignature,
            signTime: signTime,
            status: "OnSign",
          );

          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text("Signature data uploaded successfully")),
          // );
          showInfoSnackBar(context, "Signature Status uploading");
        } catch (error) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text("Error uploading signature data: $error")),
          // );
          showFailureSnackBar(context, "Error uploading signature data: $error");
        }
      }
    };
  }

  Future<void> _onRefresh() async{

    _loadTripDetailsData();
    context.read<SenderInfoBloc>().add(FetchSenderInfo());


  }

  Future<void> _loadTripDetailsData() async {

    print('i try trigger 6.00');

    print('i am sender tripID ${widget.tripId}');

    try {

      final tripDetails = await ApiService.fetchTripDetails(widget.tripId);

      print('Trip details values: $tripDetails');



      if (tripDetails != null) {

        guestMobileNumber = tripDetails['guestmobileno'];

        guestEmail = tripDetails['email'];

        guestName = tripDetails['guestname'];




        hybridata = tripDetails['Hybriddata'].toString();

        print('hybriddata datatype ${hybridata.runtimeType}');


        print("guest in signaturepage ${guestMobileNumber}");

        print('guest in signaturepage ${guestEmail}');

        print('guest in signaturepage ${guestName}');


      }

    } catch (e) {
print("${e}");


    }

  }

  Future<void> saveScreenData() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('last_screen', 'signpagescreen');

    await prefs.setString('trip_id', widget.tripId);





    print('Saved screen data:');

    print('last_screen: signpagescreen');

    print('trip_id: ${widget.tripId}');



  }

  Future<void> _refreshdignatureScreen() async {
    _onRefresh();
    // Trigger API call when drawing ends
    _signatureController.onDrawEnd = () async {
      if (_signatureController.isNotEmpty) {
        final String dateSignature = DateTime.now().toIso8601String().split('T')[0] + ' ' + DateTime.now().toIso8601String().split('T')[1].split('.')[0];
        // final String signTime = TimeOfDay.now().format(context);
        final DateTime now = DateTime.now();
        final String signTime = '${now.hour.toString().padLeft(2, '0')}:'
            '${now.minute.toString().padLeft(2, '0')}:'
            '${now.second.toString().padLeft(2, '0')}';

        try {
          await ApiService.sendSignatureDetails(
            tripId: widget.tripId,
            dateSignature: dateSignature,
            signTime: signTime,
            status: "OnSign",
          );

          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text("Signature data uploaded successfully")),
          // );
          showInfoSnackBar(context, "Signature Status uploading");
        } catch (error) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text("Error uploading signature data: $error")),
          // );
          showFailureSnackBar(context, "Error uploading signature data: $error");
        }
      }
    };
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  void _handleClear() {
    _signatureController.clear();
  }


  // void _handleSubmit() async {
  //   //first api for signature image upload
  //   final tripId = widget.tripId; // Retrieve the trip ID from your state or context
  //   if (_signatureController.isNotEmpty) {
  //     final signature = await _signatureController.toPngBytes();
  //     if (signature != null) {
  //       String base64Signature = 'data:image/png;base64,' + base64Encode(signature);
  //
  //       final DateTime now = DateTime.now();
  //       final String endtrip = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  //       final String endtime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  //
  //       try {
  //         await ApiService.saveSignature(
  //           tripId: tripId,
  //           signatureData: base64Signature,
  //           imageName: 'signature-${now.millisecondsSinceEpoch}.png',
  //           endtrip: endtrip,
  //           endtime: endtime,
  //         );
  //         //first api compled
  //
  //         //second api for inserting the values in signature times table
  //         final String dateSignature = DateTime.now().toIso8601String().split('T')[0] + ' ' + DateTime.now().toIso8601String().split('T')[1].split('.')[0];
  //         final String signTime = TimeOfDay.now().format(context);
  //         // Second API call to upload signature details (datesignature, signtime, status = 'Updated')
  //         await ApiService.sendSignatureDetailsUpdated(
  //           tripId: tripId,
  //           dateSignature: dateSignature,
  //           signTime: signTime,
  //           status: "Updated", // Status set to "Updated"
  //         );
  //         // /second api compled
  //
  //         // third api for updated closed in trip sheet
  //         await ApiService.updateTripStatusCompleted(
  //           tripId: tripId,
  //           apps: "Closed", // Set apps status to "Closed"
  //         );
  //         //third api completed
  //
  //
  //         showSuccessSnackBar(context, "Signature and ride data uploaded successfully!");
  //
  //         // showSuccessSnackBar(context, "Signature saved successfully!");
  //         _handleSubmitModal();
  //         _handleClear();
  //       } catch (e) {
  //         showFailureSnackBar(context, "Failed to save signature. Error: $e");
  //       }
  //     }
  //   } else {
  //     showFailureSnackBar(context, "Please provide a signature.");
  //   }
  //
  //
  // }

  void handleSubmitclear() {
    setState(() {
      isClearDisabled = true;  // Disable the Clear button
    });
  }


  void _handleSubmit(BuildContext context) async {

    handleSubmitclear();
    if (_signatureController.isNotEmpty) {
      final signature = await _signatureController.toPngBytes();
      if (signature != null) {
        String base64Signature = 'data:image/png;base64,' + base64Encode(signature);
        final DateTime now = DateTime.now();
        final String endtrip = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
        final String endtime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
        final String dateSignature = now.toIso8601String().split('T')[0] + ' ' + now.toIso8601String().split('T')[1].split('.')[0];
        final String signTime = TimeOfDay.now().format(context);

        setState(() {
          _isLoading = true;
        });

        if(hybridata == '1'){
          context.read<LastOtBloc>().add(OtpVerifyEvent(guestNumber: guestMobileNumber, guestEmail: guestEmail, guestName: guestName, senderEmail: senderEmail!, senderPass: senderPass!,));
        }

        // Dispatch first API call
        BlocProvider.of<TripSignatureBloc>(context).add(
          SaveSignatureEvent(
            tripId: widget.tripId,
            base64Signature: base64Signature,
            imageName: 'signature-${now.millisecondsSinceEpoch}.png',
            endtrip: endtrip,
            endtime: endtime,
          ),
        );
      }
      // _handleNavNextpage();


    } else {
      showFailureSnackBar(context, "Please provide a signature.");
    }
  }

//local storage of username
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


  void _handleNavNextpage() {
    if (hybridata == '0') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => TripDetailsUpload(tripId: widget.tripId)),
            (route) => false,
      );
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => VerifyDeBoardimgOtp(tripId: widget.tripId)),
          (route) => false,
    );
  }

  void _handleSubmitModal() {
    // Show the popup dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'End Ride',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to submit and end the ride?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop(); // Close the dialog
                _loadLoginDetails();              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // _handleUpload();
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>TripDetailsPreview(tripId: widget.tripId,)));
                // Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text(
                'Uploaddd',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    bool isConnected = Provider.of<NetworkManager>(context).isConnected;

    return MultiBlocListener(
      listeners: [
        BlocListener<TripSignatureBloc, TripSignatureState>(
        listener: (context, state) {
    if (state is SaveSignatureSuccess) {
    final String dateSignature = DateTime.now().toIso8601String().split('T')[0] + ' ' + DateTime.now().toIso8601String().split('T')[1].split('.')[0];
    // final String signTime = TimeOfDay.now().format(context);
    final DateTime now = DateTime.now();
    final String signTime = '${now.hour.toString().padLeft(2, '0')}:'
    '${now.minute.toString().padLeft(2, '0')}:'
    '${now.second.toString().padLeft(2, '0')}';

    // Dispatch second API call after first one succeeds
    BlocProvider.of<TripSignatureBloc>(context).add(
    SendSignatureDetailsEvent(
    tripId: widget.tripId,
    dateSignature: dateSignature,
    signTime: signTime,
    status: "Updated",
    ),
    );
    } else if (state is SendSignatureDetailsSuccess) {
    // Dispatch third API call after second one succeeds
    BlocProvider.of<TripSignatureBloc>(context).add(
    UpdateTripStatusEvent(
    tripId: widget.tripId,
    apps: "Closed",
    ),
    );
    showSuccessSnackBar(context, 'Trip Closed Successfully');
    } else if (state is UpdateTripStatusSuccess) {
    showSuccessSnackBar(context, "Signature and ride data uploaded successfully!");
    setState(() {
    _isLoading = false;
    });
    _handleClear();
    // _handleSubmitModal();
    _handleNavNextpage();
    } else if (state is TripSignatureFailure) {
    showFailureSnackBar(context, state.error);
    setState(() {
    _isLoading = false;
    });
    }
    },
        ),


        BlocListener<SenderInfoBloc, SenderInfoState>(
          listener: (context, state) {
            if (state is SenderInfoSuccess) {
              setState(() {
                senderEmail = state.senderMail;
                senderPass = state.senderPass;
              });
            }
          },
        ),

        ],


       child:  Scaffold(
        appBar: AppBar(
          title: Text("End Ride"),
          automaticallyImplyLeading: false, // 👈 disables the default back icon

        ),
        body:Stack(
          children: [

        RefreshIndicator(
          onRefresh: _refreshdignatureScreen,
          child:SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Please sign below to End ride:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                height: 500,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Signature(
                  controller: _signatureController,
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed:  isClearDisabled ? null : _handleClear ,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text("Clear" ,style: TextStyle(color: Colors.white, fontSize: 18.0),),
                  ),


                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _handleSubmit(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Submit", style: TextStyle(color: Colors.white, fontSize: 18.0)),
                  ),


                  // ElevatedButton(
                  //   onPressed: (){},
                  //   // onPressed: _handleSubmit,
                  //   style: ElevatedButton.styleFrom(backgroundColor: Colors.green, ),
                  //   child: Text("Submit & End Ride", style: TextStyle(color: Colors.white, fontSize: 18.0),),
                  // ),
                ],
              ),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //
              //     onPressed: () {
              //       _showLogoutDialog(context);
              //
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.red,
              //       padding: EdgeInsets.symmetric(vertical: 16),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //     ),
              //     child: Text(
              //       'logout',
              //       style: TextStyle(fontSize: 20.0, color: Colors.white),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),),),
            Positioned(
              top: 15,
              left: 0,
              right: 0,
              child: NoInternetBanner(isConnected: isConnected),
            ),
          ],
        )
      ),
      );
  }
}
