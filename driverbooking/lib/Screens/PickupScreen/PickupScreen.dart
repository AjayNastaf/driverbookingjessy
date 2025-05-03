import 'dart:async';

import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
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
import 'package:location/location.dart' as loc;


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
  late final loc.Location location;
  LatLng? _destination;
  List<LatLng> _routeCoordinates = [];
  StreamSubscription<Position>? _positionStreamSubscription;


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    final LatLng _initialPosition = LatLng(13.082680, 80.270721); // Replace with desired coordinates (e.g., Bengaluru, India)
    void initState() {
      super.initState();
      _checkMapLoading();
      saveScreenData();
      // Print the values to debug
      print("Addressss: ${widget.address}");
      print("Trip ID: ${widget.tripId}");

      location = loc.Location();
      _setDestinationFromAddress(widget.address);

      _initializeLocationTracking();
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

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polylineCoordinates = [];
    int index = 0,
        len = encoded.length;
    int lat = 0,
        lng = 0;

    while (index < len) {
      int b,
          shift = 0,
          result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      final point = LatLng(lat / 1e5, lng / 1e5);
      polylineCoordinates.add(point);
    }

    return polylineCoordinates;
  }


  Future<void> _fetchRoute() async {
    if (_currentLatLng == null) return;


    const String apiKey = AppConstants.ApiKey;
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLatLng!
        .latitude},${_currentLatLng!.longitude}&destination=${_destination!
        .latitude},${_destination!.longitude}&key=$apiKey';

    try {
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        final data = response.data;
        final routes = data['routes'] as List;
        if (routes.isNotEmpty) {
          final polyline = routes[0]['overview_polyline']['points'] as String;
          if (mounted) {
          setState(() {
            _routeCoordinates = _decodePolyline(polyline);
          });}
        } else {
          print('No routes found in API response.');
        }
      } else {
        print('API response error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }


  void _updateCameraPosition() {
    if (_currentLatLng != null) {
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentLatLng!,
            zoom: 15,
          ),
        ),
      );
    }
  }

  void _updateCurrentLocation(LocationData locationData) {
      print("hi");
    double? latitude = locationData.latitude;
    double? longitude = locationData.longitude;

    if (latitude != null && longitude != null) {
      print("Received Location: $latitude, $longitude");

      final newLatLng = LatLng(latitude, longitude);
      if (mounted) {
        setState(() {
          _currentLatLng = newLatLng;
        });
        print('lotlong ${_currentLatLng}');
        print('lotlong ${newLatLng}');
      }
      _fetchRoute();
      _updateCameraPosition();

    } else {
      print("⚠ Location data is null, skipping update");
    }
  }

  StreamSubscription<
      LocationData>? _locationSubscription; // Store the subscription
  Future<void> _initializeLocationTracking() async {
    print('hi inside the function');
    // Location location = Location();
    List<geocoding.Location> locations = await geocoding.locationFromAddress(widget.address);

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    final initialLocation = await location.getLocation();
    _updateCurrentLocation(initialLocation);


    _locationSubscription = location.onLocationChanged.listen((newLocation) {
      print("New location received: $newLocation");
      _updateCurrentLocation(newLocation);
    });
  }


  @override

  void dispose() {

    _locationSubscription?.cancel();

    _locationSubscription = null;// Remove reference



    _positionStreamSubscription?.cancel();

    super.dispose();

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
        automaticallyImplyLeading: false, // 👈 disables the default back icon

        backgroundColor: AppTheme.Navblue1,
        // iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Google Map
          // if (!_isMapLoading && _currentLatLng != null && _destination != null )
          // if (!_isMapLoading && _currentLatLng != null  )
          GoogleMap(
            onMapCreated: (controller) {
              // You can save the controller for further use if needed
              Future.delayed(Duration(milliseconds: 500), () {
                if (mounted) {
                  setState(() {
                    _isMapLoading = false; // Hide loader after small delay
                  });
                }
              });
            },
            initialCameraPosition: CameraPosition(
              target: _initialPosition, // Fixed location
              zoom: 15, // Adjust zoom level as required
            ),
              markers: {
                Marker(
                  markerId: MarkerId('currentLocation'),
                  position: _currentLatLng ?? _initialPosition,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    // BitmapDescriptor.hueBlue),
                      BitmapDescriptor.hueRed),
                ),

              },

            myLocationEnabled: false, // Disable 'my location' marker
            myLocationButtonEnabled: false, // Disable 'my location' button
          ),

            // GoogleMap(
            //   initialCameraPosition: CameraPosition(
            //     target: _currentLatLng!,
            //     zoom: 15,
            //   ),
            //   onMapCreated: (controller) {
            //     _mapController = controller;
            //     Future.delayed(Duration(milliseconds: 500), () {
            //       if (mounted) {
            //         setState(() {
            //           _isMapLoading = false; // Hide loader after small delay
            //         });
            //       }
            //     });
            //   },
            //   markers: {
            //     Marker(
            //       markerId: MarkerId('currentLocation'),
            //       position: _currentLatLng!,
            //       icon: BitmapDescriptor.defaultMarkerWithHue(
            //         // BitmapDescriptor.hueBlue),
            //           BitmapDescriptor.hueGreen),
            //     ),
            //     if (_destination != null)
            //       Marker(
            //       markerId: MarkerId('destination'),
            //       position: _destination!,
            //     ),
            //   },
            //   polylines: {
            //     if (_routeCoordinates.isNotEmpty)
            //       Polyline(
            //         polylineId: PolylineId('route'),
            //         points: _routeCoordinates,
            //         color: Colors.green,
            //         width: 5,
            //       ),
            //   },
            //   myLocationEnabled: true,
            //   myLocationButtonEnabled: false,
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
