
import 'dart:convert';

import 'package:jessy_cabs/Screens/CustomerReachedWithouthcl/AnimatedCustomerPage.dart';
import 'package:jessy_cabs/Screens/SignatureEndRide/SignatureEndRide.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:dio/dio.dart';
import 'package:jessy_cabs/GlobalVariable/global_variable.dart' as globals;
import 'package:jessy_cabs/Utils/AllImports.dart';

import 'dart:async';
import '../NoInternetBanner/NoInternetBanner.dart';
import 'package:provider/provider.dart';
import '../network_manager.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart' as loc;
import 'package:shared_preferences/shared_preferences.dart';



class CustomerReachedWithouthcl extends StatefulWidget {

  final String tripId;
  const CustomerReachedWithouthcl({super.key, required this.tripId});

  @override
  State<CustomerReachedWithouthcl> createState() => _CustomerReachedWithouthclState();
}

class _CustomerReachedWithouthclState extends State<CustomerReachedWithouthcl> {


  GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  // LatLng _destination = LatLng(13.028159, 80.243306);
  late LatLng _destination;
// Chennai Central Railway Station
  List<LatLng> _routeCoordinates = [];
  Stream<LocationData>? _locationStream;
  bool isOtpVerified = false;
  bool isStartRideEnabled = false;
  String? latitude;
  String? longitude;
  bool isEndRideClicked = false; // Initially, show "Stop Ride" button
  bool isStartWayPointClicked = false;
  bool isCloseWayPointClicked = false;
  String? vehiclevalue;
  String? Statusvalue;
  String vehicleNumber = "";
  String tripStatus = "";
  Timer? _timer;
  Duration _duration = Duration();
  bool _isMapLoading = true; // Add this variable to track loading state
  double _totalDistance = 0.0;

  LatLng? _lastLocation;        // Store last recorded location
  StreamSubscription<geo.Position>? _positionStreamSubscription;
  String? Tripdestination;
  String? Testvehinum;
  String? Testtripstatus;
  String desti = '';


  @override
  void initState() {
    super.initState();

    context.read<TripTrackingDetailsBloc>().add(
        FetchTripTrackingDetails(widget.tripId));


    saveScreenData();

    print('Drop Location: ${Tripdestination}');

    print( 'sedfvgbhnjgggggggggggggggggg');

    _loadTripSheetDetailsByTripId();
  }

  Future<void> _loadTripSheetDetailsByTripId() async {

    try {

      // Fetch trip details from the API

      final tripDetails = await ApiService.fetchTripDetails(widget.tripId);

      print('Trip details fetchedd: $tripDetails');

      if (tripDetails != null) {



         desti = tripDetails['useage'].toString();

        var vechnum = tripDetails['vehRegNo'].toString();
        var tripstatetest = tripDetails['apps'].toString();

        print('Trip details guest desti: $desti');
        print('Trip details guest desti: $tripstatetest');
        print('Trip details guest desti: $vechnum');



        setState(() {

          Tripdestination = desti;
          Testvehinum = vechnum;
          Testtripstatus = tripstatetest;

        });


      } else {

        print('No trip details found.');

      }

    } catch (e) {

      print('Error loading trip details: $e');

    }

  }







  Future<void> saveScreenData() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('last_screen', 'CustomerReachedWithouthcl');

    await prefs.setString('trip_id', widget.tripId);

    await prefs.setString('drop_location', Tripdestination!); // 🔥 Save droplocation too


    print('Saved screen data:');

    print('last_screen: CustomerReachedWithouthcl');

    print('trip_id: ${widget.tripId}');

    print('drop_location: ${Tripdestination}'); // ✅ Debug log

  }





  Future<void> _refreshCustomerDestination() async {

    context.read<TripTrackingDetailsBloc>().add(
        FetchTripTrackingDetails(widget.tripId));
  }




//for reached status starts
  void _handleEndRide(double latitude, double longitude) {
    context.read<TripTrackingDetailsBloc>().add(
      EndRideEvent(

        latitude: latitude,
        longitude: longitude,
        vehicleNo: vehicleNumber,
        tripId: widget.tripId,
        tripStatus: tripStatus,
      ),

    );
  }
//for reached status completed






  void _showEndRideConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm End Ride"),
          content: Text("Do you really want to end the ride?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                _endRide(); // Call the function to handle ending the ride
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _endRide() async {
    final String dateSignature = DateTime.now().toIso8601String().split('T')[0] + ' ' + DateTime.now().toIso8601String().split('T')[1].split('.')[0];
    final String signTime = TimeOfDay.now().format(context); // Current time

    try {
      await ApiService.sendSignatureDetails(
        tripId: widget.tripId,
        dateSignature: dateSignature,
        signTime: signTime,
        status: "Accept",
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading dataaaaaaaaaa: $error")),
      );
    }
    print('for current ');
    isEndRideClicked = true;

    Future.delayed(Duration(seconds: 1), () {
      isEndRideClicked = false;
      print("🔄 End Ride button reset, can be clicked again.");
    });




      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Signatureendride(tripId: widget.tripId),
          ),(route)=>false
      );


      // Navigator.push(context, MaterialPageRoute(builder: (context)=>Signatureendride(tripId: widget.tripId)));



  }



  @override
  Widget build(BuildContext context) {
    bool isConnected = Provider.of<NetworkManager>(context).isConnected;

    return Scaffold (
            appBar: AppBar(
              title: Text("Trip Started"),
              // automaticallyImplyLeading: false, // 👈 disables the default back icon

            ),
            // body: RefreshIndicator(onRefresh: _refreshCustomerDestination,
            //
            //   child:Stack(
            //     children: [
            //         Text('jiyuv yububu xudggu d'),
            //       Positioned(
            //         top: 50,
            //         left: 10,
            //         child: Container(
            //           padding: EdgeInsets.all(10),
            //           decoration: BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.circular(8),
            //             boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
            //           ),
            //           child: Text(
            //             "Distance Traveled:"
            //                 "Duration: ",
            //
            //             style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            //           ),
            //         ),
            //       ),
            //
            //       Positioned(
            //         bottom: 0, // Aligns the bottom section
            //         left: 0,
            //         right: 0,
            //         child: IgnorePointer(
            //           ignoring: false, // Allows interaction with the map below
            //           child: Container(
            //             // height: 100, // Adjust height as needed
            //             padding: EdgeInsets.all(16),
            //             color: Colors.white, // Semi-transparent background
            //             child: Column(
            //               mainAxisSize: MainAxisSize.min,
            //               children: [
            //
            //
            //
            //                 SizedBox(height: 20),
            //
            //
            //                 SizedBox(
            //                   width: double.infinity,
            //                   child: ElevatedButton(
            //
            //                     onPressed: () {
            //                       _showEndRideConfirmationDialog(context);
            //                     },
            //                     style: ElevatedButton.styleFrom(
            //                       backgroundColor: Colors.red,
            //                       padding: EdgeInsets.symmetric(vertical: 16),
            //                       shape: RoundedRectangleBorder(
            //                         borderRadius: BorderRadius.circular(8),
            //                       ),
            //                     ),
            //                     child: Text(
            //                       'End Ride',
            //                       style: TextStyle(fontSize: 20.0, color: Colors.white),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //       Positioned(
            //         top: 15,
            //         left: 0,
            //         right: 0,
            //         child: NoInternetBanner(isConnected: isConnected),
            //       ),
            //     ],
            //   ),
            //
            // ),


      body: AnimatedCustomerPage(),
    //   bottomNavigationBar: BottomAppBar(
    //     height: 120.00,
    //   color: Colors.white,
    //   elevation: 8.0,
    //   child: Padding(
    //     padding: const EdgeInsets.all(16.0),
    //     child: SizedBox(
    //       width: double.infinity,
    //       child: ElevatedButton(
    //         onPressed: () {
    //           _showEndRideConfirmationDialog(context);
    //         },
    //         style: ElevatedButton.styleFrom(
    //           backgroundColor: Colors.red,
    //           padding: const EdgeInsets.symmetric(vertical: 16),
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(8),
    //           ),
    //         ),
    //         child: const Text(
    //           'End Ride',
    //           style: TextStyle(fontSize: 20.0, color: Colors.white),
    //         ),
    //       ),
    //     ),
    //   ),
    // ),

      bottomNavigationBar: BottomAppBar(
        height: 245.0,
        color: Colors.white,
        elevation: 8.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Green icon + Current Location
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.person_pin_circle, color: Colors.green, size: 30),
                  const SizedBox(width: 12),
                  Text(
                    'Current Location',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Vertical line
              Padding(
                padding: const EdgeInsets.only(left: 14), // aligns under icon
                child: Container(
                  width: 2,
                  height: 30,
                  color: Colors.grey.shade400,
                ),
              ),

              const SizedBox(height: 8),

              // Red icon + qqqqqqqq
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on, color: Colors.red, size: 30),
                  const SizedBox(width: 12),
                  Text(
                    desti,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // End Ride Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showEndRideConfirmationDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'End Ride',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }




}

