import 'dart:async';

import 'package:dio/dio.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jessy_cabs/Screens/CustomerLocationReached/CustomerLocationReached.dart';
import 'package:jessy_cabs/Screens/StartingKilometer/StartingKilometer.dart';
import 'package:jessy_cabs/Screens/TrackingPage/TrackingPage.dart';
// import 'package:jessy_cabs/Screens/TrackingPage/TrackingPagecopy1.dart';
import 'package:flutter/material.dart';
import 'package:jessy_cabs/Networks/Api_Service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:jessy_cabs/Screens/BookingDetails/BookingDetails.dart';
import 'package:jessy_cabs/Bloc/AppBloc_Events.dart';
import 'package:jessy_cabs/Bloc/App_Bloc.dart';
import 'package:jessy_cabs/Bloc/AppBloc_State.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../NoInternetBanner/NoInternetBanner.dart';
import 'package:provider/provider.dart';
import '../network_manager.dart';

import 'package:geocoding/geocoding.dart' as geocoding;
// import 'package:location/location.dart' as loc;
import 'package:location/location.dart';


class Pickupscreen extends StatefulWidget {
  final String address;
  final String tripId;
  const Pickupscreen({Key?key, required this.address, required this.tripId}):super(key: key);

  @override
  State<Pickupscreen> createState() => _PickupscreenState();
}

class _PickupscreenState extends State<Pickupscreen>{


  bool _isMapLoading = true;
  GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  // LatLng _destination = LatLng( 13.028159, 80.243306);
  LatLng? _destination;
  List<LatLng> _routeCoordinates = [];
  StreamSubscription<Position>? _positionStreamSubscription;

  LocationData? _currentLocation;
  Location location = Location();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    final LatLng _initialPosition = LatLng(13.082680, 80.270721); // Replace with desired coordinates (e.g., Bengaluru, India)
    void initState() {
      super.initState();
      _checkMapLoading();
      saveScreenData();
      // Print the values to debug
      print("Addressss: ${widget.address}");
      print("Trip ID: ${widget.tripId}");

      _setDestinationFromAddress(widget.address);
      _getCurrentLocation();

      // _updateCurrentLocation();
    }


  Future<void> saveScreenData() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('last_screen', 'Pickupscreen');

    await prefs.setString('trip_id', widget.tripId);

    await prefs.setString('address', widget.address);





    print('Saved screen data:');

    print('last_screen: Pickupscreen');

    print('trip_id: ${widget.tripId}');

    print('address: ${widget.address}');



  }


  Future<void> _setDestinationFromAddress(String address) async {
    try {
      List<geocoding.Location> locations = await geocoding.locationFromAddress(address);
      if (locations.isNotEmpty) {
        if (mounted) {
        setState(() {
          _destination =
              LatLng(locations.first.latitude, locations.first.longitude);
        });
      }
      }
    } catch (e) {
      print('Error converting address to coordinates: $e');
    }
  }

  void _checkMapLoading() {
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isMapLoading = false; // Ensure loader disappears
        });
      }
    });
  }












  @override

  void dispose() {




    _positionStreamSubscription?.cancel();

    super.dispose();

  }


  Future<void> _getCurrentLocation() async {
    Location location = Location();

    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }

    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    LocationData _locationData = await location.getLocation();
    LatLng latLng = LatLng(_locationData.latitude!, _locationData.longitude!);

    setState(() {
      _currentLatLng = latLng;
    });

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, 15),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
      bool isConnected = Provider.of<NetworkManager>(context).isConnected;

      return  Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pick Up",
          style: TextStyle(color: Colors.white, fontSize: AppTheme.appBarFontSize),
        ),
        // leading: BackButton(), // explicitly show back button
        automaticallyImplyLeading: false,

        backgroundColor: AppTheme.Navblue1,
        // iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [




          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
              setState(() {
                _isMapLoading = false;
              });

              if (_currentLatLng != null) {
                _mapController!.animateCamera(
                  CameraUpdate.newLatLngZoom(_currentLatLng!, 15),
                );
              }
            },
            initialCameraPosition: CameraPosition(
              target: _currentLatLng ?? _initialPosition,
              zoom: 15,
            ),
            markers: _currentLatLng != null
                ? {
              Marker(
                markerId: MarkerId('currentLocation'),
                position: _currentLatLng!,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              )
            }
                : {},
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
          ),









          // GoogleMap(
          //   onMapCreated: (controller) {
          //     // You can save the controller for further use if needed
          //     Future.delayed(Duration(milliseconds: 500), () {
          //       if (mounted) {
          //         setState(() {
          //           _isMapLoading = false; // Hide loader after small delay
          //         });
          //       }
          //     });
          //   },
          //   initialCameraPosition: CameraPosition(
          //     target: _initialPosition, // Fixed location
          //     zoom: 15, // Adjust zoom level as required
          //   ),
          //     markers: {
          //       Marker(
          //         markerId: MarkerId('currentLocation'),
          //         position: _currentLatLng ?? _initialPosition,
          //         icon: BitmapDescriptor.defaultMarkerWithHue(
          //           // BitmapDescriptor.hueBlue),
          //             BitmapDescriptor.hueRed),
          //       ),
          //
          //     },
          //
          //   myLocationEnabled: false, // Disable 'my location' marker
          //   myLocationButtonEnabled: false, // Disable 'my location' button
          // ),



          if (_isMapLoading)
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.9), // Optional: add slight overlay
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          // Bottom Section
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              // padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 38.0),
              padding: EdgeInsets.only(top: 16.0, bottom: 38.0, left: 10.0,right: 10.0),
                // height: 230,
              constraints: BoxConstraints(
                minHeight: 230.0
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6.0,
                    offset: Offset(0, -2),
                  ),
                ],
              ),

              child: Column(
                children: [
                  SizedBox(height: 10.0,),

                  Row(
                    children: [

                      Column(
                        children: [
                          Icon(Icons.person_pin_circle, color: Colors.green, size: 30),
                          Container(
                            width: 2,
                            height: 30,
                            color: Colors.grey.shade400,
                          ),
                          Icon(Icons.location_on, color: Colors.red, size: 30),
                        ],
                      ),
                      SizedBox(width: 12), // Space between icon and address
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Location',
                              style: TextStyle(color: Colors.grey.shade800, fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 40),
                            Text(
                              ' ${widget.address}',
                              style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0,),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your button action here StartingKilometer
                        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => TrackingPage(address: widget.address, tripId: widget.tripId,)), (route) => false,);
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => StartingKilometer(tripId: widget.tripId, address: widget.address)), (route) => false,);


                      },
                      child: Text(
                        'Reached',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white, // Text color
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Background color
                        padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 12.0), // Button padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0), // Border radius
                        ),
                      ),
                    ),
                  )

                ],
              ),
            ),
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
}
