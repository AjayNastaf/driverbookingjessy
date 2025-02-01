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
import 'package:driverbooking/Networks/Api_Service.dart';
import 'dart:async';

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
  bool isRideStopped = false; // Initially, show "Stop Ride" button
  String? vehiclevalue;
  String? Statusvalue;
  bool isLocationSaved = false; // Add this flag at the class level

  // StreamSubscription<LocationData>? _locationSubscription; // Store the subscription

  @override
  void initState() {
    super.initState();
    _initializeCustomerLocationTracking();
    _loadTripDetailsCustomer();
    // _getLatLngFromAddress(globals.dropLocation);
    // _locationSubscription?.cancel(); // ✅ Safe way to cancel without crashing
    // _locationSubscription = null;
  }

  Future<void> _loadTripDetailsCustomer() async {
    try {
      // Fetch trip details from the API
      final tripDetails = await ApiService.fetchTripDetails(widget.tripId!);
      print('Raw Trip details fetched: $tripDetails'); // Debugging

      if (tripDetails != null) {
        // Remove any accidental spaces or tabs in key names
        var vehicleNo = tripDetails['vehRegNo']?.toString();
        var tripStatusValue = tripDetails['apps'];

        print('Vehicle No: $vehicleNo');
        print('Trip Status: $tripStatusValue');

        if((tripStatusValue != null) && (vehicleNo   != null)) {
          setState(() {
            vehiclevalue = vehicleNo;
            Statusvalue = tripStatusValue;
          });
          print('Updated vehiclevalue: $vehiclevalue');
        } else {
          print('Error: vehicleNo is null');
        }
      } else {
        print('No trip details found.');
      }
    } catch (e) {
      print('Error loading trip details: $e');
    }
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

  StreamSubscription<LocationData>? _locationSubscription; // Store the subscription

  Future<void> _initializeCustomerLocationTracking() async {
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
    _updateCustomerCurrentLocation(initialLocation);

    // _locationStream = location.onLocationChanged;
    // _locationStream!.listen((newLocation) {
    //   _updateCustomerCurrentLocation(newLocation);
    // });
    _locationSubscription = location.onLocationChanged.listen((newLocation) {
      print("New location received: $newLocation");
      _updateCustomerCurrentLocation(newLocation);
    });
  }



  void _updateCustomerCameraPosition() {
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

  // Function to send location data to API
  Future<void> _saveLocationToDatabaseCustomer(double latitude, double longitude) async {
    print("Saving location: Latitude = $latitude, Longitude = $longitude"); // Debugging print

    final Map<String, dynamic> requestData = {
      "vehicleno": vehiclevalue,
      "latitudeloc": latitude,
      "longitutdeloc": longitude,
      "Trip_id": widget.tripId, // Dummy Trip ID
      "Runing_Date": DateTime.now().toIso8601String().split("T")[0], // Current Date
      "Runing_Time": DateTime.now().toLocal().toString().split(" ")[1], // Current Time
      "Trip_Status": Statusvalue,
      "Tripstarttime": DateTime.now().toLocal().toString().split(" ")[1],
      "TripEndTime": DateTime.now().toLocal().toString().split(" ")[1],
      "created_at": DateTime.now().toIso8601String(),
    };

    print("Request Data: ${json.encode(requestData)}"); // Debugging print

    try {
      final response = await http.post(
        Uri.parse("${AppConstants.baseUrl}/addvehiclelocationUniqueLatlong"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestData),
      );

      print("Response Status Codeee: ${response.statusCode}"); // Debugging print
      print("Response Body: ${response.body}"); // Debugging print

      if (response.statusCode == 200) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Lat Long Saved Successfullyyyyyyyyyyyyyyyy")),
        // );
        print("Lat Long Saved Successfully");
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Failed to Save Lat Long")),
        // );
        print("Failed to Save Lat Long");
      }
    } catch (e) {
      print("Error sending location data: $e"); // Debugging print
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred")),
      );
    }
  }



  void _updateCustomerCurrentLocation(LocationData locationData) {
    if (locationData.latitude != null && locationData.longitude != null) {
      print("Received Location: ${locationData.latitude}, ${locationData.longitude}");

      final newLatLng = LatLng(locationData.latitude!, locationData.longitude!);

      setState(() {
        _currentLatLng = newLatLng;
      });

      _fetchRouteCustomer();
      _updateCustomerCameraPosition();
      // _saveLocationToDatabaseCustomer(locationData.latitude!, locationData.longitude!);
      _saveLocationToDatabaseCustomer(locationData.latitude!, locationData.longitude!);

    } else {
      print("Location data is null");
    }
  }


  Future<void> _fetchRouteCustomer() async {
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
            _routeCoordinates = _decodePolylineCustomer(polyline);
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

  List<LatLng> _decodePolylineCustomer(String encoded) {
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




  @override
  void dispose() {
    // for (var controller in _otpControllers) {
    //   controller.dispose();
    // }
    _locationSubscription!.cancel();
    _locationSubscription = null;// Remove reference

    super.dispose();
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
                    if (!isRideStopped)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isRideStopped = true; // Hide Stop, Show Start
                              Statusvalue = "waypoint"; // Set Trip_Status to "waypoint"
                            });

                            // Call the function to save location with updated status
                            if (_currentLatLng != null) {
                              _saveLocationToDatabaseCustomer(
                                _currentLatLng!.latitude,
                                _currentLatLng!.longitude,
                              );
                            } else {
                              print("Error: _currentLatLng is null");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Stop Ride',
                            style: TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                      ),

                    // Start Ride Button (Shown after Stop Ride is clicked)
                    if (isRideStopped)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isRideStopped = false; // Hide Stop, Show Start
                              Statusvalue = "On_Going"; // Set Trip_Status to "waypoint"
                            });

                            // Call the function to save location with updated status
                            if (_currentLatLng != null) {
                              _saveLocationToDatabaseCustomer(
                                _currentLatLng!.latitude,
                                _currentLatLng!.longitude,
                              );
                            } else {
                              print("Error: _currentLatLng is null");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Start Ride',
                            style: TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                      ),
                    SizedBox(height: 20.0,),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        // onPressed: () {
                        //   // Navigator.push(context, MaterialPageRoute(builder: (context)=>Signatureendride()));
                        //   Navigator.push(context, MaterialPageRoute(builder: (context)=>TripDetailsUpload(tripId: widget.tripId,)));
                        // },
                        // onPressed: () {
                        //   setState(() {
                        //     Statusvalue = 'Reached'; // Set Trip_Status to "waypoint"
                        //   });
                        //
                        //   // Call the function to save location with updated status
                        //   if (_currentLatLng != null) {
                        //     _saveLocationToDatabaseCustomer(
                        //       _currentLatLng!.latitude,
                        //       _currentLatLng!.longitude,
                        //     );
                        //   } else {
                        //     print("Error: _currentLatLng is null");
                        //   }
                        //   Navigator.push(context, MaterialPageRoute(builder: (context)=>TripDetailsUpload(tripId: widget.tripId,)));
                        //
                        // },

                        // bool isLocationSaved = false; // Add this flag at the class level

                        onPressed: () {
                          if (!isLocationSaved) { // Check if already saved
                            setState(() {
                            Statusvalue = 'Reached'; // Set Trip_Status to "Reached"
                            isLocationSaved = true;  // Prevent duplicate API calls
                          });

                          // Call the function to save location with updated status
                            if (_currentLatLng != null) {
                              _saveLocationToDatabaseCustomer(
                              _currentLatLng!.latitude,
                              _currentLatLng!.longitude,
                            );
                              // _locationSubscription?.cancel();

                            } else {
                              print("Error: _currentLatLng is null");
                            }
                          } else {
                            print("Location already saved, skipping API call.");
                          }
                          _locationSubscription?.cancel();

                          // Navigate to the next screen
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TripDetailsUpload(tripId: widget.tripId,))
                          );
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
