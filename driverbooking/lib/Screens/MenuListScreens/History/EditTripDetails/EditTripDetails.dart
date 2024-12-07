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
    // Add your file and camera upload logic here
  }


  void _submitDetails() {
    // Your logic to handle submit (e.g., saving the data, calling API)
    print("Details submitted");
    // For now, just showing a message as an example
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Details Submitted")));
  }

  Widget _buildSectionTitle(String title) {
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

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        enabled: isEditable,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: isEditable ? Colors.white : Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
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
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isEditable = !isEditable;
                  if (!isEditable) {
                    _signatureController.clear();
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.red, // Button color changes based on isEditable state
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit, color: AppTheme.white1),
                  SizedBox(width: 8.0),
                  Text(
                    "Edit Details",
                    style: TextStyle(color: AppTheme.white1, fontSize: 20.0),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            _buildSectionTitle("Trip Information"),
            _buildInputField("Trip Sheet Number", tripSheetNumberController),
            _buildInputField("Trip Date", tripDateController),
            _buildInputField("Report Time", reportTimeController),
            const SizedBox(height: 16),
            _buildSectionTitle("Duty Information"),
            _buildInputField("Duty Type", dutyTypeController),
            _buildInputField("Vehicle Type", vehicleTypeController),
            const SizedBox(height: 16),
            _buildSectionTitle("Company and Guest"),
            _buildInputField("Company Name", companyNameController),
            _buildInputField("Guest Name", guestNameController),
            _buildInputField("Contact Number", contactNumberController),
            const SizedBox(height: 16),
            _buildSectionTitle("Locations"),
            _buildInputField("Address", addressController),
            _buildInputField("Drop Location", dropLocationController),
            const SizedBox(height: 16),
            _buildSectionTitle("Toll and Parking"),
            _buildInputField("Enter Toll Amount", tollAmountController),
            ElevatedButton.icon(
              onPressed: isEditable ? () => _uploadFile("Toll") : null,
              icon: const Icon(Icons.upload),
              label: const Text("Upload Toll"),
            ),
            const SizedBox(height: 16),
            _buildInputField("Enter Parking Amount", parkingAmountController),
            ElevatedButton.icon(
              onPressed: isEditable ? () => _uploadFile("Parking") : null,
              icon: const Icon(Icons.upload),
              label: const Text("Upload Parking"),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle("Signature"),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: AbsorbPointer(
                absorbing: !isEditable, // Disable signature input when not editable
                child: Signature(
                  controller: _signatureController,
                  height: 150,
                  backgroundColor: isEditable ? Colors.white : Colors.grey[200] ?? Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: isEditable ? () => _signatureController.clear() : null,
                  child: const Text("Clear Signature"),
                ),
                ElevatedButton(
                  onPressed: isEditable ? _saveSignature : null,
                  child: const Text("Save Signature"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isEditable ? _submitDetails : null,
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
