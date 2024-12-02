import 'package:driverbooking/Screens/HomeScreen/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signature saved successfully!")),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Homescreen(userId: "12")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please provide a signature.")),
      );
    }
  }

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
              height: 600,
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
