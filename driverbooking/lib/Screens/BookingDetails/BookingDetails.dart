import 'package:driverbooking/Screens/PickupScreen/PickupScreen.dart';
import 'package:driverbooking/Utils/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:driverbooking/GlobalVariable/global_variable.dart' as globals;
import 'package:driverbooking/Networks/Api_Service.dart';

class Bookingdetails extends StatefulWidget {
  final String userId;
  final String username;
  const Bookingdetails({super.key,
    required this.userId,
    required this.username,
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
      final data = await ApiService.fetchTripSheet(
        userId: widget.userId,
        username: widget.username,
      );
      setState(() {
        tripSheetData = data;
        // Assuming the address is fetched as part of the API response
        address = data.isNotEmpty ? data[0]['address1'] ?? '' : '';
        Dropaddress = data.isNotEmpty ? data[0]['address1'] ?? '' : '';
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
      body:ListView.builder(
        itemCount: tripSheetData.length,
          itemBuilder: (context , index ){
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
                        value: "${tripDetails['tripsheetdate']}",
                        icon: Icons.description,
                      ),
                      _buildDetailTile(
                        context,
                        label: "Trip Date",
                        value: "${tripDetails['tripsheetdate']}",
                        icon: Icons.calendar_today,
                      ),
                      _buildDetailTile(
                        context,
                        label: "start time",
                        value: "${tripDetails['starttime']}",
                        icon: Icons.access_time,
                      ),
                      _buildDetailTile(
                        context,
                        label: "Duty Type",
                        value: "${tripDetails['duty']}",
                        icon: Icons.business_center,
                      ),
                      _buildDetailTile(
                        context,
                        label: "Vehicle Type",
                        value: "${tripDetails['vehType']}",
                        icon: Icons.directions_car,
                      ),
                      _buildDetailTile(
                        context,
                        label: "Company Name",
                        value: "${tripDetails['customer']}",
                        icon: Icons.business,
                      ),
                      _buildDetailTile(
                        context,
                        label: "Guest Name",
                        value: "${tripDetails['guestname']}",
                        icon: Icons.person,
                      ),
                      _buildDetailTile(
                        context,
                        label: "Contact Number",
                        value: "${tripDetails['guestmobileno']}",
                        icon: Icons.phone,
                      ),
                      _buildDetailTile(
                        context,
                        label: "Address",
                        value: address,
                        icon: Icons.location_pin,
                        isLast: true,
                      ),
                      _buildDetailTile(
                        context,
                        label: "Drop Location",
                        value: Dropaddress,
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Pickupscreen(address: address)));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 16.0),
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
      }),


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
