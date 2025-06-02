import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jessy_cabs/Screens/CustomerReachedWithouthcl/CustomerReachedWithouthcl.dart';
import 'package:jessy_cabs/Screens/TrackingWithOutHcl/AnimatedPageTracking.dart';
import 'package:location/location.dart';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jessy_cabs/Bloc/App_Bloc.dart';
import 'package:jessy_cabs/Bloc/AppBloc_Events.dart';
import 'package:jessy_cabs/Networks/Api_Service.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Bloc/AppBloc_State.dart';
import '../../GlobalVariable/global_variable.dart' as globals;
import '../../Utils/AllImports.dart';
import '../../Utils/AppConstants.dart';
import '../../Utils/AppFunctions.dart';
import '../../Utils/AppTheme.dart';
import '../CustomerLocationReached/CustomerLocationReached.dart';
import '../NoInternetBanner/NoInternetBanner.dart';
import 'package:provider/provider.dart';
import '../network_manager.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:location/location.dart' as loc;



class TrackingWithOutHcl extends StatefulWidget {
  final String address;
  final String tripId; // Add this field

  const TrackingWithOutHcl({Key? key, required this.address ,  required this.tripId}) : super(key: key);


  @override
  State<TrackingWithOutHcl> createState() => _TrackingWithOutHclState();
}

class _TrackingWithOutHclState extends State<TrackingWithOutHcl> {





  bool isOtpVerified = false;
  bool isStartRideEnabled = false;


  late String? tripId;
  String? vehiclevalue;
  String? Statusvalue;
  String vehicleNumber = "";
  String tripStatus = "";
  bool _isLoading = false; // Declare at the top of your state class



  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();

    tripId = widget.tripId; // Assuming tripId is passed to the TrackingPage
    context.read<TripTrackingDetailsBloc>().add(
        FetchTripTrackingDetails(widget.tripId!));


    saveScreenData();

  }


  Future<void> saveScreenData() async {

    print('1one');

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('last_screen', 'TrackingWithOutHcl');

    await prefs.setString('trip_id', widget.tripId);

    await prefs.setString('address', widget.address);





    print('Saved screen datang:');

    print('last_screen: TrackingWithOutHcl');

    print('trip_id: ${widget.tripId}');

    print('address: ${widget.address}');



  }






  Future<void> _refreshTrackingPage() async{

    tripId = widget.tripId; // Assuming tripId is passed to the TrackingPage
    context.read<TripTrackingDetailsBloc>().add(
        FetchTripTrackingDetails(widget.tripId!));
  }

  void performAnotherFunction() {
    print("Using trip details in another function:");
    print("Vehicle Number: $vehicleNumber");
    print("Trip Status: $tripStatus");

    // You can perform any logic using the fetched data here.
  }





  Future<void> _handleStartRide(BuildContext context) async {
    print('coming inside');
    if (tripId == null) {
      print('Error: tripId is null');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Trip ID is missing. Cannot start the ride.')),
      // );
      showWarningSnackBar(context, 'Trip ID is missing. Cannot start the ride.');
      return;
    }

    try {
      final response = await ApiService.updateTripStatusStartRide(
          tripId!, 'On_Going');

      if (response.statusCode == 200) {
        print('Status updated successfully ongoing');




        WidgetsBinding.instance.addPostFrameCallback((_) {

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerReachedWithouthcl(tripId: tripId!),
              ),(route)=> false
          );

        });

      } else {
        print('Failed to update status: ${response.body}');

        showFailureSnackBar(context, 'Failed to update status');

      }
    } catch (e) {
      print('Error occurred: $e');

      showFailureSnackBar(context, 'Error occurred while updating status');

    }
  }


  Future<void> _handleStartRideButton() async {

    await _handleStartRide(context);




  }









  @override
  Widget build(BuildContext context) {
    bool isConnected = Provider.of<NetworkManager>(context).isConnected;

    return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Tracking",
              style: TextStyle(
                  color: Colors.white, fontSize: AppTheme.appBarFontSize),
            ),
            backgroundColor: AppTheme.Navblue1,
            // iconTheme: const IconThemeData(color: Colors.white),
            // automaticallyImplyLeading: false, // 👈 disables the default back icon

          ),
          // body: RefreshIndicator(
          //   // child: child,
          //   onRefresh: _refreshTrackingPage,
          //
          //
          //
          //
          //   child: SingleChildScrollView(
          //     physics: const AlwaysScrollableScrollPhysics(),
          //     child: AnimatedPageTracking()
          //
          //
          //
          //   ),
          //
          // ),
          body:AnimatedPageTracking(),
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            height: 100.0,
            shape: const CircularNotchedRectangle(),  // Optional: for notch design
            elevation: 18.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleStartRideButton,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.Navblue1,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'Start Ride',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),

        );



  }

}





