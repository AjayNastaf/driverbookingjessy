import 'package:driverbooking/Screens/PickupScreen/PickupScreen.dart';
import 'package:driverbooking/Utils/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:driverbooking/GlobalVariable/global_variable.dart' as globals;

class Bookingdetails extends StatefulWidget {
  const Bookingdetails({super.key});

  @override
  State<Bookingdetails> createState() => _BookingdetailsState();
}

class _BookingdetailsState extends State<Bookingdetails> {
  String address =
      'no 17 Thiruvalluvar puram, West Tambaram, irumbiliyur, chennai-45';
  String dropaddress = "Nungambakkam";
  @override
  void initState() {
    super.initState();
    globals.dropLocation = Dropaddress; // Set the global variable
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Title and Description Section
              // Card(
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(15),
              //   ),
              //   elevation: 3,
              //   child: Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         const Text(
              //           "Booking Overview",
              //           style: TextStyle(
              //             fontSize: 20.0,
              //             fontWeight: FontWeight.bold,
              //             color: AppTheme.Navblue1,
              //           ),
              //         ),
              //         const SizedBox(height: 10),
              //         const Text(
              //           "Review the booking details before proceeding.",
              //           style: TextStyle(fontSize: 16.0, color: Colors.grey),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
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
                      value: "1175",
                      icon: Icons.description,
                    ),
                    _buildDetailTile(
                      context,
                      label: "Trip Date",
                      value: "2024-04-19",
                      icon: Icons.calendar_today,
                    ),
                    _buildDetailTile(
                      context,
                      label: "Report Time",
                      value: "18:19",
                      icon: Icons.access_time,
                    ),
                    _buildDetailTile(
                      context,
                      label: "Duty Type",
                      value: "Local",
                      icon: Icons.business_center,
                    ),
                    _buildDetailTile(
                      context,
                      label: "Vehicle Type",
                      value: "Sedan BMW",
                      icon: Icons.directions_car,
                    ),
                    _buildDetailTile(
                      context,
                      label: "Company Name",
                      value: "natsaf",
                      icon: Icons.business,
                    ),
                    _buildDetailTile(
                      context,
                      label: "Guest Name",
                      value: "Ajay",
                      icon: Icons.person,
                    ),
                    _buildDetailTile(
                      context,
                      label: "Contact Number",
                      value: "8667551412",
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
                      value: dropaddress,
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
