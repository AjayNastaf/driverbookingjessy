import 'package:driverbooking/Screens/SignatureEndRide/SignatureEndRide.dart';
import 'package:driverbooking/Screens/TripDetailsUpload/TripDetailsUpload.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:driverbooking/GlobalVariable/global_variable.dart' as globals;
import 'package:driverbooking/Utils/AllImports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Customerlocationreached extends StatefulWidget {
  final String tripId;
  const Customerlocationreached({super.key, required this.tripId});

  @override
  State<Customerlocationreached> createState() => _CustomerlocationreachedState();
}

class _CustomerlocationreachedState extends State<Customerlocationreached> {

  GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  LatLng _destination = LatLng(13.028159, 80.243306); // Chennai Central Railway Station
  List<LatLng> _routeCoordinates = [];
  Stream<LocationData>? _locationStream;
  bool _hasReachedDestination = false;
  List<TextEditingController> _otpControllers = [];
  bool isOtpVerified = false;
  bool isStartRideEnabled = false;
  String? latitude;
  String? longitude;

  @override
  void initState() {
    super.initState();
    _initializeLocationTracking();

    // _getLatLngFromAddress(globals.dropLocation);
  }

  Future<void> _getLatLngFromAddress(String dropLocation) async {
    const String apiKey = AppConstants.ApiKey; // Replace with your API Key
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(dropLocation)}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final location = data['results'][0]['geometry']['location'];
          setState(() {
            _destination = LatLng(location['lat'], location['lng']);
          });
        } else {
          print('Error: ${data['status']}');
        }
      } else {
        print('Failed to fetch geocoding data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _initializeLocationTracking() async {
    Location location = Location();

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

    _locationStream = location.onLocationChanged;
    _locationStream!.listen((newLocation) {
      _updateCurrentLocation(newLocation);
    });
  }

  void _updateCurrentLocation(LocationData locationData) {
    if (locationData.latitude != null && locationData.longitude != null) {
      final newLatLng = LatLng(locationData.latitude!, locationData.longitude!);

      if (mounted) {
        setState(() {
          _currentLatLng = newLatLng;
        });
      }

      // setState(() {
      //   _currentLatLng = newLatLng;
      // });

      _fetchRoute();
      _updateCameraPosition();
    }
  }

  Future<void> _fetchRoute() async {
    if (_currentLatLng == null) return;

    const String apiKey = AppConstants.ApiKey;
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLatLng!.latitude},${_currentLatLng!.longitude}&destination=${_destination.latitude},${_destination.longitude}&key=$apiKey';

    try {
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        final data = response.data;
        final routes = data['routes'] as List;
        if (routes.isNotEmpty) {
          final polyline = routes[0]['overview_polyline']['points'] as String;
          setState(() {
            _routeCoordinates = _decodePolyline(polyline);
          });
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

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polylineCoordinates = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
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

  @override
  Widget build(BuildContext context) {
    String dropLocation = globals.dropLocation; // Access the global variable

    return Scaffold (
      appBar: AppBar(
        title: Text("Trip Started"),
      ),
      body: Stack(
        children: [
          if (_currentLatLng != null)
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLatLng!,
                zoom: 15,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              markers: {
                Marker(
                  markerId: MarkerId('currentLocation'),
                  position: _currentLatLng!,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),

                ),
                Marker(
                  markerId: MarkerId('destination'),
                  position: _destination,
                ),
              },
              polylines: {
                if (_routeCoordinates.isNotEmpty)
                  Polyline(
                    polylineId: PolylineId('route'),
                    points: _routeCoordinates,
                    color: Colors.blue,
                    width: 5,
                  ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
          Positioned(
            bottom: 0, // Aligns the bottom section
            left: 0,
            right: 0,
            child: IgnorePointer(
              ignoring: false, // Allows interaction with the map below
              child: Container(
                // height: 100, // Adjust height as needed
                padding: EdgeInsets.all(16),
                color: Colors.white, // Semi-transparent background
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //  Text(
                    //   'Drop Location: ${globals.dropLocation}',
                    //   style: TextStyle(fontSize: 18.0),
                    // ),
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
                                style: TextStyle(color: Colors.grey.shade800, fontSize: 20.0, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 32),
                              Text(
                                // ' ${globals.dropLocation}',
    '$dropLocation',
                                style: TextStyle(color: Colors.grey.shade800, fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0,),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>Signatureendride()));
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>TripDetailsUpload(tripId: widget.tripId,)));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                           'End Ride',
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
