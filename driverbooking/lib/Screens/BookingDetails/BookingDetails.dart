import 'package:jessy_cabs/Bloc/AppBloc_State.dart';
import 'package:jessy_cabs/Bloc/AppBloc_Events.dart';
import 'package:jessy_cabs/Bloc/App_Bloc.dart';
import 'package:intl/intl.dart';
import 'package:jessy_cabs/Screens/HomeScreen/HomeScreen.dart';
import 'package:jessy_cabs/Screens/PickUpWithoutHcl/PickUpWithoutHcl.dart';

import 'package:jessy_cabs/Screens/PickupScreen/PickupScreen.dart';
import 'package:jessy_cabs/Screens/StartingKilometer/StartingKilometer.dart';
import 'package:jessy_cabs/Utils/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:jessy_cabs/GlobalVariable/global_variable.dart' as globals;
import 'package:jessy_cabs/Networks/Api_Service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../NoInternetBanner/NoInternetBanner.dart';
import 'package:provider/provider.dart';
import '../network_manager.dart';




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

class _BookingdetailsState extends State<Bookingdetails>  {



  bool isLoading = true;
  List<Map<String, dynamic>> tripSheetData = [];

  String address = '';
  String Dropaddress = "";
  @override
  void initState() {
    super.initState();
    globals.dropLocation = Dropaddress; // Set the global variable
    BlocProvider.of<GettingTripSheetDetailsByUseridBloc>(context).add(Getting_TripSheet_Details_By_Userid(userId: widget.userId, username: widget.username, tripId: widget.tripId, duty: widget.duty));
    saveScreenData();
  }

  Future<void> saveScreenData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_screen', 'Bookingdetails');
    await prefs.setString('trip_id', widget.tripId);
    await prefs.setString('duty', widget.duty);
    await prefs.setString('user_id', widget.userId);
    await prefs.setString('username', widget.username);
    // prefs.setString('dropLocation', Dropaddress.trim());


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
        Dropaddress = data.isNotEmpty ? data[0]['useage'] ?? '' : '';  // Same here
        globals.dropLocation = Dropaddress;

      });
    } catch (e) {
      print('Error initializing data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // local storage
  Future<void> _saveTripDetailsToLocalStorage(Map<String, dynamic> tripDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert the tripDetails map to a JSON string
    String tripDetailsJson = json.encode(tripDetails);

    // Save the JSON string in shared preferences
    await prefs.setString('tripDetails', tripDetailsJson);

    print('Trip details saved to local storage.');
  }


  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "Not available"; // Handle null case
    try {
      DateTime parsedDate = DateTime.parse(dateStr); // Parse the string to DateTime
      return DateFormat('dd-MM-yyyy').format(parsedDate); // Format to "YYYY-MM-DD"
    } catch (e) {
      return "Invalid date"; // Handle parsing errors
    }
  }

  String _formatTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return "Not available"; // Handle null case
    try {
      DateTime parsedTime = DateFormat("HH:mm:ss").parse(timeStr); // Parse 'HH:mm:ss'
      return DateFormat("HH:mm").format(parsedTime); // Format as 'HH:mm'
    } catch (e) {
      return "Invalid time"; // Handle parsing errors
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



  @override
  Widget build(BuildContext context) {
    bool isConnected = Provider.of<NetworkManager>(context).isConnected;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Trip Details",
          style: TextStyle(color: Colors.white, fontSize: AppTheme.appBarFontSize),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Custom back icon
          onPressed: () {
            _loadLoginDetails();
            },
        ),
        backgroundColor: AppTheme.Navblue1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body:
          Stack(
            children: [


      RefreshIndicator(
          onRefresh: _initializeData,
      child: BlocBuilder<GettingTripSheetDetailsByUseridBloc, GettingTripSheetDetilsByUseridState>(builder: (context , state){
        if (state is Getting_TripSheetDetails_ByUserid_Loading){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }else if(state is Getting_TripSheetDetails_ByUserid_Loaded){
          return ListView.builder(
            itemCount: state. tripSheets.length,
            itemBuilder: (context, index) {
              final tripDetails = state.tripSheets[index];
              _saveTripDetailsToLocalStorage(tripDetails);
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
                              // value: tripDetails['tripsheetdate'] ?? "Not available", // Default text when null
                              value: _formatDate(tripDetails['startdate']), // Convert date format
                              icon: Icons.calendar_today,
                            ),
                            _buildDetailTile(
                              context,
                              label: "Start Time",
                              value: _formatTime(tripDetails['starttime']), // Format time properly

                              // value: tripDetails['starttime'] ?? "Not available", // Default text when null
                              icon: Icons.access_time,
                            ),
                            _buildDetailTile(
                              context,
                              label: "Duty Type",
                              value: tripDetails['duty'] ?? "Not available", // Default text when null
                              icon: Icons.business_center,
                            ),
                            // _buildDetailTile(
                            //   context,
                            //   label: "Vehicle Type",
                            //   value: tripDetails['vehType'] ?? "Not available", // Default text when null
                            //   icon: Icons.directions_car,
                            // ),
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
                              // value: address.isNotEmpty ? address : "Not available", // Default text when empty
                              value: tripDetails['address1'] ?? "Not available", // Default text when null

                              icon: Icons.location_pin,
                              isLast: true,
                            ),
                            _buildDetailTile(
                              context,
                              label: "Drop Location",
                              // value: Dropaddress.isNotEmpty ? Dropaddress : "Not available", // Default text when empty
                              value: tripDetails['useage'] ?? "Not available", // Default text when null

                              icon: Icons.location_pin,
                              isLast: true,
                            ),

                            // _buildDetailTile(
                            //   context,
                            //   label: "Hybriddata",
                            //   value: tripDetails['Hybriddata'].toString() ?? "Not available", // Default text when null
                            //
                            //   icon: Icons.location_pin,
                            //   isLast: true,
                            // ),

                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      // Accept Button
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     await ApiService.updateTripStatus(
                      //       tripId: widget.tripId,
                      //       status: "Accept",
                      //     );
                      //
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => StartingKilometer(address: address, tripId: widget.tripId,),
                      //       ),
                      //     );
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(12.0),
                      //     ),
                      //     backgroundColor: AppTheme.Navblue1,
                      //     foregroundColor: Colors.white,
                      //     elevation: 6,
                      //   ),
                      //   child: const Text(
                      //     "Accept Booking",
                      //     style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      //   ),
                      // ),

                  BlocConsumer<UpdateTripStatusInTripsheetBloc, UpdateTripStatusInTripsheetState>(
                    listener: (context, state) {
                      if (state is UpdateTripStatusInTripsheetSuccess) {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => StartingKilometer(address: tripDetails['address1'], tripId: widget.tripId),
                        //   ),
                        // );
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => Pickupscreen(address: tripDetails['address1'], tripId: widget.tripId),
                        //   ),
                        // );

                        if (tripDetails['Hybriddata'].toString() == '1') {
                          // Navigator.pushAndRemoveUntil(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => Pickupscreen(
                          //       address: tripDetails['address1'],
                          //       tripId: widget.tripId,
                          //     ),
                          //   ),
                          //       (route) => false,
                          // );
                          print("hcl inside, ${tripDetails['Hybriddata'].toString()}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Pickupscreen(
                                address: tripDetails['address1'],
                                tripId: widget.tripId,
                              ),
                            ),

                          );
                        } else if(tripDetails['Hybriddata'].toString() == '0') {
                          // Navigator.pushAndRemoveUntil(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => PickUpWithoutHcl(
                          //       address: tripDetails['address1'],
                          //       tripId: widget.tripId,   ), // Replace with your other screen
                          //   ),
                          //       (route) => false,
                          // );
                          print("non hcl inside, ${tripDetails['Hybriddata'].toString()}");

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PickUpWithoutHcl(
                                address: tripDetails['address1'],
                                tripId: widget.tripId,   ), // Replace with your other screen
                            ),

                          );
                        }






                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => Pickupscreen(address: tripDetails['address1'], tripId: widget.tripId),
                        //   ),(route)=> false
                        // );

    // Navigator.pushAndRemoveUntil(
    // context,
    // MaterialPageRoute(
    // builder: (context) => Customerlocationreached(tripId: tripId!),
    // ),(route)=> false
    // );
    //


                      } else if (state is UpdateTripStatusInTripsheetFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: ${state.error}")),
                        );
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state is UpdateTripStatusInTripsheetLoading
                            ? null // Disable button when loading
                            : () {
                          context.read<UpdateTripStatusInTripsheetBloc>().add(
                            UpdateTripStatusEventClass(
                              tripId: widget.tripId,
                              status: "Accept",
                            ),
                          );
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
                        child: state is UpdateTripStatusInTripsheetLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                          "Accept",
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  )

                  ],
                  ),
                ),
              );
            },
          );

        }else{
          return const Center(
            child: Text('Failed to Load Data '),
          );
        }
      })

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
