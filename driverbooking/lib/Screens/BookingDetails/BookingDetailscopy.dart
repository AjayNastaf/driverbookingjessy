import 'package:jessy_cabs/Screens/PickupScreen/PickupScreen.dart';
import 'package:jessy_cabs/Utils/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:jessy_cabs/GlobalVariable/global_variable.dart' as globals;
import 'package:jessy_cabs/Networks/Api_Service.dart';

class Bookingdetails extends StatefulWidget {
  final String userId;
  final String username;
  final String tripId; // Accept tripid here
  final String duty; // Accept tripid here

  const Bookingdetails({super.key,
    required this.userId,
    required this.username,
    required this.tripId,
    required this.duty// Accept tripid in the constructor

  });

  @override
  State<Bookingdetails> createState() => _BookingdetailsState();
}

class _BookingdetailsState extends State<Bookingdetails> {
  bool isLoading = true;
  List<Map<String, dynamic>> tripSheetData = [];

  String address = '';
  String Dropaddress = "";
  @override
  void initState() {
    super.initState();
    globals.dropLocation = Dropaddress; // Set the global variable
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeData();
  }
  Future<void> _initializeData() async {
    try {
      print("Calling API with tripId: ${widget.tripId} and duty: ${widget.duty}");

      // Modify the API call to fetch data for the specific tripid
      final data = await ApiService.fetchTripSheetbytripid(
        userId: widget.userId,
        username: widget.username,
        tripId: widget.tripId, // Pass tripId to the API call
        duty: widget.duty, // Pass duty to the API call
      );

      print("API Response: $data");

      setState(() {
        tripSheetData = data;  // Store the list of trip data
        address = data.isNotEmpty ? data[0]['address1'] ?? '' : '';  // Access the first item in the list
        Dropaddress = data.isNotEmpty ? data[0]['address1'] ?? '' : '';  // Same here
      });
    } catch (e) {
      print('Error initializing data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Booking Details",
          style:
              TextStyle(color: Colors.white, fontSize: AppTheme.appBarFontSize),
        ),
        backgroundColor: AppTheme.Navblue1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: tripSheetData.length,
        itemBuilder: (context, index) {
          final tripDetails = tripSheetData[index];
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 16.0),
                  // Booking Details Section
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildDetailTile(
                          context,
                          label: "Trip Sheet Number",
                          value: (tripDetails['tripid']?.toString() ?? "Not available"),
                          icon: Icons.description,
                        ),
                        _buildDetailTile(
                          context,
                          label: "Trip Date",
                          value: tripDetails['tripsheetdate'] ?? "Not available", // Default text when null
                          icon: Icons.calendar_today,
                        ),
                        _buildDetailTile(
                          context,
                          label: "Start Time",
                          value: tripDetails['starttime'] ?? "Not available", // Default text when null
                          icon: Icons.access_time,
                        ),
                        _buildDetailTile(
                          context,
                          label: "Duty Type",
                          value: tripDetails['duty'] ?? "Not available", // Default text when null
                          icon: Icons.business_center,
                        ),
                        _buildDetailTile(
                          context,
                          label: "Vehicle Type",
                          value: tripDetails['vehType'] ?? "Not available", // Default text when null
                          icon: Icons.directions_car,
                        ),
                        _buildDetailTile(
                          context,
                          label: "Company Name",
                          value: tripDetails['customer'] ?? "Not available", // Default text when null
                          icon: Icons.business,
                        ),
                        _buildDetailTile(
                          context,
                          label: "Guest Name",
                          value: tripDetails['guestname'] ?? "Not available", // Default text when null
                          icon: Icons.person,
                        ),
                        _buildDetailTile(
                          context,
                          label: "Contact Number",
                          value: tripDetails['guestmobileno'] ?? "Not available", // Default text when null
                          icon: Icons.phone,
                        ),
                        _buildDetailTile(
                          context,
                          label: "Address",
                          value: address.isNotEmpty ? address : "Not available", // Default text when empty
                          icon: Icons.location_pin,
                          isLast: true,
                        ),
                        _buildDetailTile(
                          context,
                          label: "Drop Location",
                          value: Dropaddress.isNotEmpty ? Dropaddress : "Not available", // Default text when empty
                          icon: Icons.location_pin,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // Accept Button
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => Pickupscreen(address: address),
                      //   ),
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      backgroundColor: AppTheme.Navblue1,
                      foregroundColor: Colors.white,
                      elevation: 6,
                    ),
                    child: const Text(
                      "Accept Booking",
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),


    );
  }

  // Detail Tile Widget
  Widget _buildDetailTile(BuildContext context,
      {required String label,
      required String value,
      required IconData icon,
      bool isLast = false}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppTheme.Navblue1),
          title: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          subtitle: Text(
            value,
            style: const TextStyle(fontSize: 14.0, color: Colors.black87),
          ),
        ),
        if (!isLast)
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
            height: 0,
          ),
      ],
    );
  }
}
