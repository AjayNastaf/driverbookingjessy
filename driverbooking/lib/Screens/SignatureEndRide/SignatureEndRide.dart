import 'package:driverbooking/Screens/HomeScreen/HomeScreen.dart';
import 'package:driverbooking/Screens/TollParkingUpload/TollParkingUpload.dart';
import 'package:driverbooking/Screens/TripDetailsUpload/TripDetailsUpload.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:driverbooking/Utils/AllImports.dart';

class Signatureendride extends StatefulWidget {
  const Signatureendride({super.key});

  @override
  State<Signatureendride> createState() => _SignatureendrideState();
}

class _SignatureendrideState extends State<Signatureendride> {
  // Controller for the signature pad
  final SignatureController _signatureController = SignatureController(
    penColor: Colors.black,
    penStrokeWidth: 3,
  );

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  void _handleClear() {
    _signatureController.clear();
  }

  void _handleSubmit() async {
    if (_signatureController.isNotEmpty) {
      final signature = await _signatureController.toPngBytes();
      if (signature != null) {
        // Do something with the signature (e.g., upload or save locally)
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Signature saved successfully!")),
        // );
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Homescreen(userId: "12")));
        showSuccessSnackBar(context, "Signature saved successfully!");
        _handleSubmitModal();
      }
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Please provide a signature.")),
      // );
      showFailureSnackBar(context, "Please provide a signature.");
    }
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // _handleUpload();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TripDetailsUpload()));
                // Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text(
                'Upload',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  // void _handleUpload() {
  //   // Logic for handling the upload
  //   print("Ride details uploaded.");
  //   // Add your API call or relevant code here.
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("End Ride"),
      ),
      body: Padding(
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
                  onPressed: _handleClear,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("Clear" ,style: TextStyle(color: Colors.white, fontSize: 18.0),),
                ),
                ElevatedButton(
                  onPressed: _handleSubmit,
                  // onPressed: _handleSubmitModal,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, ),
                  child: Text("Submit & End Ride", style: TextStyle(color: Colors.white, fontSize: 18.0),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
