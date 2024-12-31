import 'package:driverbooking/Screens/HomeScreen/HomeScreen.dart';
import 'package:driverbooking/Utils/AllImports.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class EditTripDetails extends StatefulWidget {
  const EditTripDetails({super.key});

  @override
  State<EditTripDetails> createState() => _EditTripDetailsState();
}

class _EditTripDetailsState extends State<EditTripDetails> {
  bool isEditable = false;

  // Controllers for input fields
  final TextEditingController tripSheetNumberController = TextEditingController();
  final TextEditingController tripDateController = TextEditingController();
  final TextEditingController reportTimeController = TextEditingController();
  final TextEditingController dutyTypeController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
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

  Widget _buildInputField(String label, TextEditingController controller ,{bool isEnabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        enabled: isEnabled, // Controls whether the field is enabled or not
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: isEnabled ? Colors.white : Colors.grey[200], // Adjusts the color based on enabled state
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            _buildInputField("Trip Sheet Number", tripSheetNumberController, isEnabled: false),
            _buildInputField("Trip Date", tripDateController, isEnabled: false),
            _buildInputField("Report Time", reportTimeController, isEnabled: false),
            const SizedBox(height: 16),
            buildSectionTitle("Duty Information"),
            _buildInputField("Duty Type", dutyTypeController, isEnabled: false),
            _buildInputField("Vehicle Type", vehicleTypeController, isEnabled: false),
            const SizedBox(height: 16),
            buildSectionTitle("Company and Guest"),
            _buildInputField("Company Name", companyNameController, isEnabled: false),
            _buildInputField("Guest Name", guestNameController, isEnabled: false),
            _buildInputField("Contact Number", contactNumberController, isEnabled: false),
            const SizedBox(height: 16),
            buildSectionTitle("Locations"),
            _buildInputField("Address", addressController, isEnabled: false),
            _buildInputField("Drop Location", dropLocationController, isEnabled: false),
            const SizedBox(height: 16),
            buildSectionTitle("Toll and Parking"),
            _buildInputField("Enter Toll Amount", tollAmountController,  isEnabled: true),
            ElevatedButton.icon(
              onPressed: () => _uploadFile("Toll"),
              icon: const Icon(Icons.upload),
              label: const Text("Upload Toll"),
            ),
            const SizedBox(height: 16),
            _buildInputField("Enter Parking Amount", parkingAmountController),
            ElevatedButton.icon(
              onPressed: () => _uploadFile("Parking"),
              icon: const Icon(Icons.upload),
              label: const Text("Upload Parking"),
            ),
            const SizedBox(height: 16),
            buildSectionTitle("Signature"),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Signature(
                controller: _signatureController,
                height: 150,
                backgroundColor:  Colors.white ,
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
                onPressed:  _submitDetails,
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
    );
  }
}
