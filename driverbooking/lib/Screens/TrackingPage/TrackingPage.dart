import 'package:jessy_cabs/Screens/CustomerLocationReached/CustomerLocationReached.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:jessy_cabs/Utils/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
import '../NoInternetBanner/NoInternetBanner.dart';
import 'package:provider/provider.dart';
import '../network_manager.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:location/location.dart' as loc;


class SharedPrefs {
  static Future<void> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }
}

class TrackingPage extends StatefulWidget {
  final String address;
  final String? tripId; // Add this field

  const TrackingPage({Key? key, required this.address ,  this.tripId}) : super(key: key);

  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  LatLng _destination = LatLng( 13.028159, 80.243306); // Chennai Central Railway Station
  List<LatLng> _routeCoordinates = [];
  Stream<LocationData>? _locationStream;
  bool isOtpVerified = false;
  bool isStartRideEnabled = false;
  String? latitude;
  String? longitude;
  // Variables to track last location and time
  LatLng? _lastSavedLatLng;
  DateTime? _lastSavedTime;
  late String? tripId;
  String? vehiclevalue;
  String? Statusvalue;
  String vehicleNumber = "";
  String tripStatus = "";
  bool _isMapLoading = true; // Add this variable to track loading state




  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _initializeLocationTracking();

    _getLatLngFromAddress(widget.address);
    // _saveLocationToDatabase(12.9716, 77.5946);
    tripId = widget.tripId; // Assuming tripId is passed to the TrackingPage
    // _loadTripDetails();
    context.read<TripTrackingDetailsBloc>().add(
        FetchTripTrackingDetails(widget.tripId!));
    _checkMapLoading();

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

  Future<void> _refreshTrackingPage() async{
    _initializeLocationTracking();

    _getLatLngFromAddress(widget.address);
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

  Future<void> _loadTripDetails() async {
    try {
      // Fetch trip details from the API
      final tripDetails = await ApiService.fetchTripDetails(tripId!);
      print('Raw Trip details fetched: $tripDetails'); // Debugging

      if (tripDetails != null) {
        // Remove any accidental spaces or tabs in key names
        var vehicleNo = tripDetails['vehRegNo']?.toString();
        var tripStatusValue = tripDetails['apps'];

        print('Vehicle No: $vehicleNo');
        print('Trip Status: $tripStatusValue');

        if ((tripStatusValue != null) && (vehicleNo != null)) {
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


  Future<void> _getLatLngFromAddress(String address) async {
    const String apiKey = AppConstants.ApiKey; // Replace with your API Key
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri
        .encodeComponent(address)}&key=$apiKey';

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

  StreamSubscription<
      LocationData>? _locationSubscription; // Store the subscription

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


    _locationSubscription = location.onLocationChanged.listen((newLocation) {
      print("New location received: $newLocation");
      _updateCurrentLocation(newLocation);
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
        .latitude},${_currentLatLng!.longitude}&destination=${_destination
        .latitude},${_destination.longitude}&key=$apiKey';

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

  // Function to send location data to API
  Future<void> _saveLocationToDatabase(double latitude,
      double longitude) async {
    print("inside normal");

    print(
        "Saving location: Latitude = $latitude, Longitude = $longitude"); // Debugging print

    final Map<String, dynamic> requestData = {
      "vehicleno": vehiclevalue,
      "latitudeloc": latitude,
      "longitutdeloc": longitude,
      "Trip_id": tripId,
      // Dummy Trip ID
      "Runing_Date": DateTime.now().toIso8601String().split("T")[0],
      // Current Date
      "Runing_Time": DateTime.now().toLocal().toString().split(" ")[1],
      // Current Time
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

      print(
          "Response Status Codeee: ${response.statusCode}"); // Debugging print
      print("Response Body: ${response.body}"); // Debugging print

      if (response.statusCode == 200) {
        print("Lat Long Saved Successfully");
      } else {
        print("Failed to Save Lat Long");
      }
    } catch (e) {
      print("Error sending location data: $e"); // Debugging print
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Error occurred")),
      // );
      showFailureSnackBar(context, "Error occurred");
    }
  }


  void _updateCurrentLocation(LocationData locationData) {
    double? latitude = locationData.latitude;
    double? longitude = locationData.longitude;

    if (latitude != null && longitude != null) {
      print("Received Location: $latitude, $longitude");

      final newLatLng = LatLng(latitude, longitude);

      setState(() {
        _currentLatLng = newLatLng;
      });

      _fetchRoute();
      _updateCameraPosition();
      // _saveLocationToDatabase(latitude, longitude);

      // Check if location is (0.0, 0.0) – if so, do nothing
      if (latitude == 0.0 && longitude == 0.0) {
        print("⚠ Invalid location (0.0, 0.0), skipping saveLocation.");
        return; // Stop execution here
      }

      // Ensure vehicleNumber and tripStatus are available before calling saveLocation
      if (vehicleNumber.isNotEmpty && tripStatus.isNotEmpty) {
        saveLocation(latitude, longitude);
      } else {
        print("⚠ Trip details not loaded yet, waiting...");
      }
    } else {
      print("⚠ Location data is null, skipping update");
    }
  }



  void saveLocation(double latitude, double longitude) {
    print("Inside saveLocation function");
    print("Vehicle Number: $vehicleNumber, Trip Status: $tripStatus");
    // Prevent saving if latitude and longitude are (0.0, 0.0)
    if (latitude == 0.0 && longitude == 0.0) {
      print("⚠ Invalidd location (0.0, 0.0) - Not saving to database.");
      return; // Stop execution
    }

    if (vehicleNumber.isNotEmpty && tripStatus.isNotEmpty) {
      print("Dispatching SaveLocationToDatabase event...");
      context.read<TripTrackingDetailsBloc>().add(
        SaveLocationToDatabase(
          latitude: latitude,
          longitude: longitude,
          vehicleNo: vehicleNumber,
          tripId: widget.tripId!,
          tripStatus: tripStatus,
        ),
      );
    } else {
      print("Trip details are not yet loaded. Cannot save location.");
    }
  }


  Future<void> _handleStartTrip(double latitude, double longitude) async {
    print(
        "Saving start location: Latitude = $latitude, Longitude = $longitude"); // Debugging print
    if (latitude == 0.0 && longitude == 0.0) {
      print("⚠ Invalidd location (0.0, 0.0) - Not saving to database.");
      return; // Stop execution
    }

    bool success = await ApiService.insertStartData( // ✅ Now called statically
      vehicleNo: vehicleNumber,
      tripId: tripId ?? '',
      latitude: latitude,
      longitude: longitude,
      runningDate: DateTime.now().toIso8601String().split("T")[0],
      // Current Date,
      runningTime: DateTime.now().toLocal().toString().split(" ")[1],
      tripStatus: "Started",
      tripStartTime: DateTime.now().toLocal().toString().split(" ")[1],
      tripEndTime: DateTime.now().toIso8601String(),


    );

    if (success) {
      showInfoSnackBar(context, "Trip started  Successfully!");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Customerlocationreached(tripId: tripId!),
        ),(route)=> false
      );
    }



  }



  // void _updateCurrentLocation(LocationData locationData) {
  //   if (locationData.latitude != null && locationData.longitude != null) {
  //     print("Received Location: ${locationData.latitude}, ${locationData.longitude}");
  //
  //     final newLatLng = LatLng(locationData.latitude!, locationData.longitude!);
  //
  //     setState(() {
  //       _currentLatLng = newLatLng;
  //     });
  //
  //     _fetchRoute();
  //     _updateCameraPosition();
  //     _saveLocationToDatabase(locationData.latitude!, locationData.longitude!);
  //
  //   } else {
  //     print("Location data is null");
  //   }
  // }


  // void _updateCurrentLocation(LocationData locationData) {
  //   // Ensure values are not null before using
  //   double? latitude = locationData.latitude;
  //   double? longitude = locationData.longitude;
  //
  //   if (latitude != null && longitude != null) {
  //     print("Received Location: $latitude, $longitude");
  //
  //     final newLatLng = LatLng(latitude, longitude);
  //
  //     setState(() {
  //       _currentLatLng = newLatLng;
  //     });
  //
  //     _fetchRoute();
  //     _updateCameraPosition();
  //
  //     // Now call your functions safely
  //     // _saveLocationToDatabase(latitude, longitude);
  //     saveLocation(latitude, longitude);
  //   } else {
  //     print("⚠ Location data is null, skipping update");
  //   }
  // }


  bool _shouldSaveLocation(LatLng newLatLng) {
    print("Inside _shouldSaveLocation...");

    const double locationThreshold = 0.001;
    const int timeThreshold = 30;

    if (_lastSavedLatLng != null) {
      double distance = _calculateDistance(_lastSavedLatLng!, newLatLng);
      bool hasSignificantChange = distance > locationThreshold;
      bool hasTimePassed = _lastSavedTime == null ||
          DateTime
              .now()
              .difference(_lastSavedTime!)
              .inSeconds > timeThreshold;

      print(
          "Distanceeeee: $distance, Significant Change: $hasSignificantChange, Time Passed: $hasTimePassed");

      if (hasSignificantChange || hasTimePassed) {
        return true;
      }
    }

    print("Returning false from _shouldSaveLocation");
    return false;
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371; // Radius in kilometers
    double dLat = _degToRad(end.latitude - start.latitude);
    double dLng = _degToRad(end.longitude - start.longitude);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degToRad(start.latitude)) *
            math.cos(_degToRad(end.latitude)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c; // Returns distance in kilometers
  }

  double _degToRad(double deg) {
    return deg * (math.pi / 180.0);
  }




  @override
  void dispose() {

    _locationSubscription!.cancel();
    _locationSubscription = null; // Remove reference
    _positionStreamSubscription?.cancel();

    super.dispose();
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

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => Customerlocationreached(tripId: tripId!),
        //   ),
        // );
        // Stop location tracking before navigating
        _locationSubscription?.cancel();
      } else {
        print('Failed to update status: ${response.body}');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Failed to update status')),
        // );
        showFailureSnackBar(context, 'Failed to update status');
      }
    } catch (e) {
      print('Error occurred: $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error occurred while updating status')),
      // );
      showFailureSnackBar(context, 'Error occurred while updating status');

    }
  }


  Future<void> _handleStartRideButton() async {
    // _handleStartTrip(
    //   (latitude as num?)?.toDouble() ?? 0.0,
    //   (longitude as num?)?.toDouble() ?? 0.0,
    // );
    if (_currentLatLng != null) {
      _handleStartTrip(_currentLatLng!.latitude, _currentLatLng!.longitude);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Customerlocationreached(tripId: tripId!),
          ),(route)=> false
      );



      showInfoSnackBar(context, 'Trip started');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location not available yet! Please Wait")),
      );
      showWarningSnackBar(context, "Location not available yet!");
    }

    await _handleStartRide(context);

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => Customerlocationreached(tripId:tripId!),
    //   ),
    // );
  }






  @override
  Widget build(BuildContext context) {
    bool isConnected = Provider.of<NetworkManager>(context).isConnected;

    return BlocListener<TripTrackingDetailsBloc, TripTrackingDetailsState>(
        listener: (context, state) {
          if (state is TripTrackingDetailsLoaded) {
            setState(() {
              vehicleNumber = state.vehicleNumber;
              tripStatus = state.status;
            });

            print("Trip details loaded. Vehicle: $vehicleNumber, Status: $tripStatus");

            // Ensure trip details are set before calling saveLocation
            if (vehicleNumber.isNotEmpty && tripStatus.isNotEmpty) {
              saveLocation(0.0 , 0.0); // Example coordinates
            } else {
              print("Trip details are still empty after setting state.");
            }
          } else if (state is SaveLocationSuccess) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text("Location saved successfully!")),
            // );
            // showSuccessSnackBar(context, "Location saved successfully!");
          } else if (state is SaveLocationFailure) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text(state.errorMessage)),
            // );
            showFailureSnackBar(context, state.errorMessage);
          }
        },

    child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Tracking Page",
              style: TextStyle(
                  color: Colors.white, fontSize: AppTheme.appBarFontSize),
            ),
            backgroundColor: AppTheme.Navblue1,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: RefreshIndicator(
              // child: child,
              onRefresh: _refreshTrackingPage,


       child: Stack(

         children: [
              if (!_isMapLoading && _currentLatLng != null)
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentLatLng!,
                    zoom: 15,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    Future.delayed(Duration(milliseconds: 500), () {
                      if (mounted) {
                        setState(() {
                          _isMapLoading = false; // Hide loader after small delay
                        });
                      }
                    });
                  },
                  markers: {
                    Marker(
                      markerId: MarkerId('currentLocation'),
                      position: _currentLatLng!,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          // BitmapDescriptor.hueBlue),
                          BitmapDescriptor.hueGreen),
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
                        color: Colors.green,
                        width: 5,
                      ),
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                ),
           // Show CircularProgressIndicator while map is loading
           // Show loader until Google Map loads
           if (_isMapLoading)
             Positioned.fill(
               child: Container(
                 color: Colors.white.withOpacity(0.9), // Optional: add slight overlay
                 child: Center(
                   child: CircularProgressIndicator(),
                 ),
               ),
             ),


           Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  ignoring: false,
                  child: Container(
                    height: 150,
                    padding: EdgeInsets.all(16),
                    color: Colors.white,

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child:


                          ElevatedButton(
                            // onPressed: () async {
                            //   setState(() {
                            //     Statusvalue = 'Start'; // Set Trip_Status to "waypoint"
                            //   });
                            //
                            //   // Call the function to save location with updated status
                            //   if (_currentLatLng != null) {
                            //     _saveLocationToDatabase(
                            //       _currentLatLng!.latitude,
                            //       _currentLatLng!.longitude,
                            //     );
                            //
                            //     // await _handleStartRide(context);
                            //     // _handleStartTrip
                            //
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) => Customerlocationreached(tripId:tripId!),
                            //       ),
                            //     );
                            //     print(' values success');
                            //
                            //   } else {
                            //     print("Errorrrr: _currentLatLng is null");
                            //   }
                            //   // await _handleStartRide(context);
                            //
                            // },
                            onPressed: _handleStartRideButton,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.Navblue1,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),

                            child: Text(
                              'Start Ride',
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                          ),

                        ),
                      ],
                    ),
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
          )
          )
        )
    );
  }







}

































