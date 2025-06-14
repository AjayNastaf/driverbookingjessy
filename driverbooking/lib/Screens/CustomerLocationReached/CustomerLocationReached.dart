// import 'package:geocoding/geocoding.dart';
// import 'package:jessy_cabs/Screens/SignatureEndRide/SignatureEndRide.dart';
// import 'package:jessy_cabs/Screens/TripDetailsUpload/TripDetailsUpload.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'dart:math' as math;
// import 'package:dio/dio.dart';
// import 'package:jessy_cabs/GlobalVariable/global_variable.dart' as globals;
// import 'package:jessy_cabs/Utils/AllImports.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:jessy_cabs/Networks/Api_Service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:async';
// import '../NoInternetBanner/NoInternetBanner.dart';
// import 'package:provider/provider.dart';
// import '../network_manager.dart';
//
// import 'package:geolocator/geolocator.dart';
// import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
// import 'package:geolocator/geolocator.dart' as geo;
// import 'package:location/location.dart' as loc;
// import 'package:geocoding/geocoding.dart' as geocoding;
// import 'package:location/location.dart' as loc;
//
//
// class Customerlocationreached extends StatefulWidget {
//   final String tripId;
//   const Customerlocationreached({super.key, required this.tripId});
//
//   @override
//   State<Customerlocationreached> createState() => _CustomerlocationreachedState();
// }
//
// class _CustomerlocationreachedState extends State<Customerlocationreached> {
//
//   GoogleMapController? _mapController;
//   LatLng? _currentLatLng;
//   // LatLng _destination = LatLng(13.028159, 80.243306);
//   late LatLng _destination;
// // Chennai Central Railway Station
//   List<LatLng> _routeCoordinates = [];
//   Stream<LocationData>? _locationStream;
//   bool isOtpVerified = false;
//   bool isStartRideEnabled = false;
//   String? latitude;
//   String? longitude;
//   bool isRideStopped = false; // Initially, show "Stop Ride" button
//   bool isEndRideClicked = false; // Initially, show "Stop Ride" button
//   bool isStartWayPointClicked = false;
//   bool isCloseWayPointClicked = false;
//   String? vehiclevalue;
//   String? Statusvalue;
//   String vehicleNumber = "";
//   String tripStatus = "";
//   Timer? _timer;
//   Duration _duration = Duration();
//   bool _isMapLoading = true; // Add this variable to track loading state
//   double _totalDistance = 0.0;
//
//   LatLng? _lastLocation;        // Store last recorded location
//   StreamSubscription<geo.Position>? _positionStreamSubscription;
//
//
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCustomerLocationTracking();
//
//     context.read<TripTrackingDetailsBloc>().add(
//         FetchTripTrackingDetails(widget.tripId));
//     _checkMapLoading();
//     _startTracking();
//     _setDestinationFromDropLocation();
//     _startTimer();
//
//   }
//
//   // void _setDestinationFromDropLocation() {
//   //   try {
//   //     String dropLocation = globals.dropLocation; // Example: "13.028159,80.243306"
//   //     List<String> parts = dropLocation.split(',');
//   //     print("Destination set to 1 $dropLocation");
//   //     print("Destination set to $parts");
//   //
//   //     if (parts.length == 2) {
//   //       double lat = double.parse(parts[0]);
//   //       double lng = double.parse(parts[1]);
//   //
//   //       _destination = LatLng(lat, lng);
//   //       print("Destination set to $_destination");
//   //     } else {
//   //       throw FormatException("Invalid dropLocation format");
//   //     }
//   //   } catch (e) {
//   //     print("Error setting destination: $e");
//   //     // Fallback to a default value if needed
//   //     _destination = LatLng(0.0, 0.0);
//   //   }
//   // }
//   void _setDestinationFromDropLocation() async {
//     try {
//       String address = globals.dropLocation; // Example: "Tambaram"
//       print("Address to be converted: $address");
//
//       // List<Location> locations = await locationFromAddress(address);
//       List<geocoding.Location> locations = await geocoding.locationFromAddress(address);
//
//       if (locations.isNotEmpty) {
//         double lat = locations[0].latitude;
//         double lng = locations[0].longitude;
//
//         _destination = LatLng(lat, lng);
//         print("Destination coordinates: $_destination");
//       } else {
//         throw Exception("No coordinates found for the address.");
//       }
//     } catch (e) {
//       print("Error converting address to coordinates: $e");
//       _destination = LatLng(0.0, 0.0); // fallback
//     }
//   }
//
//   void _startTracking() {
//     final locationSettings = geo.LocationSettings(
//       accuracy: geo.LocationAccuracy.high, // Use `geo.` prefix
//       distanceFilter: 10,
//     );
//
//
//     _positionStreamSubscription =
//         Geolocator.getPositionStream(locationSettings: locationSettings)
//             .listen((Position position) {
//           LatLng newLocation = LatLng(position.latitude, position.longitude);
//
//           // If we have a previous location, calculate distance
//           if (_lastLocation != null) {
//             double distanceInMeters = Geolocator.distanceBetween(
//               _lastLocation!.latitude,
//               _lastLocation!.longitude,
//               newLocation.latitude,
//               newLocation.longitude,
//             );
//
//             setState(() {
//               _totalDistance += distanceInMeters / 1000; // Convert meters to km
//             });
//           }
//
//           _lastLocation = newLocation; // Update last known location
//         });
//   }
//   void _checkMapLoading() {
//     Future.delayed(Duration(seconds: 2), () {
//       if (mounted) {
//         setState(() {
//           _isMapLoading = false; // Ensure loader disappears
//         });
//       }
//     });
//   }
//
//
// Future<void> _refreshCustomerDestination() async {
//   _initializeCustomerLocationTracking();
//
//   context.read<TripTrackingDetailsBloc>().add(
//       FetchTripTrackingDetails(widget.tripId));
// }
//
//   StreamSubscription<LocationData>? _locationSubscription; // Store the subscription
//
//   Future<void> _initializeCustomerLocationTracking() async {
//     // Location location = Location();
//     loc.Location location = loc.Location();
//
//     bool serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) return;
//     }
//
//     PermissionStatus permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) return;
//     }
//
//     final initialLocation = await location.getLocation();
//     _updateCustomerCurrentLocation(initialLocation);
//
//     // _locationStream = location.onLocationChanged;
//     // _locationStream!.listen((newLocation) {
//     //   _updateCustomerCurrentLocation(newLocation);
//     // });
//
//     _locationSubscription = location.onLocationChanged.listen((newLocation) {
//       print("New location received: $newLocation");
//       _updateCustomerCurrentLocation(newLocation);
//     });
//   }
//
//
//   void _updateCustomerCameraPosition() {
//     if (_currentLatLng != null) {
//       _mapController?.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target: _currentLatLng!,
//             zoom: 15,
//           ),
//         ),
//       );
//     }
//   }
//
//   // main Function to send location data to API
//   Future<void> _saveLocationToDatabaseCustomer(double latitude, double longitude) async {
//     print("Savinggg location: Latitude = $latitude, Longitude = $longitude"); // Debugging print
//
//     final Map<String, dynamic> requestData = {
//       "vehicleno": vehiclevalue,
//       "latitudeloc": latitude,
//       "longitutdeloc": longitude,
//       "Trip_id": widget.tripId, // Dummy Trip ID
//       "Runing_Date": DateTime.now().toIso8601String().split("T")[0], // Current Date
//       "Runing_Time": DateTime.now().toLocal().toString().split(" ")[1], // Current Time
//       "Trip_Status": Statusvalue,
//       "Tripstarttime": DateTime.now().toLocal().toString().split(" ")[1],
//       "TripEndTime": DateTime.now().toLocal().toString().split(" ")[1],
//       "created_at": DateTime.now().toIso8601String(),
//     };
//     print("hhhh: $Statusvalue");
//
//     print("Request Data: ${json.encode(requestData)}"); // Debugging print
//
//     try {
//       final response = await http.post(
//         Uri.parse("${AppConstants.baseUrl}/addvehiclelocationUniqueLatlong"),
//         headers: {"Content-Type": "application/json"},
//         body: json.encode(requestData),
//       );
//
//       print("Response Status Codeee: ${response.statusCode}"); // Debugging print
//       print("Response Body: ${response.body}"); // Debugging print
//
//       if (response.statusCode == 200) {
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(content: Text("Lat Long Saved Successfullyyyyyyyyyyyyyyyy")),
//         // );
//         // showSuccessSnackBar(context, " customer Location saved successfully!");
//
//         print("Lat Long Saved Successfully");
//       } else {
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(content: Text("Failed to Save Lat Long")),
//         // );
//         print("Failed to Save Lat Long");
//       }
//     } catch (e) {
//       print("Error sending location data: $e"); // Debugging print
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   SnackBar(content: Text("Error occurred")),
//       // );
//       showFailureSnackBar(context, "Error occurred");
//     }
//   }
//
//
//   void _updateCustomerCurrentLocation(LocationData locationData) {
//     double? latitude = locationData.latitude;
//     double? longitude = locationData.longitude;
//
//     if (latitude != null && longitude != null) {
//       print("Received Location: $latitude, $longitude");
//
//       final newLatLng = LatLng(latitude, longitude);
//
//       setState(() {
//         _currentLatLng = newLatLng;
//       });
//
//       _fetchRouteCustomer();
//       _updateCustomerCameraPosition();
//
//
//       // Check if location is (0.0, 0.0) – if so, do nothing
//       if (latitude == 0.0 && longitude == 0.0) {
//         print("⚠ Invalid location (0.0, 0.0), skipping saveLocation.");
//         return; // Stop execution here
//       }
//
//       if (isRideStopped == true) {
//         print("Successsss Ajay");
//         print("object");
//         // saveWayPointLocationCustomer(latitude, longitude);
//         return;
//       }
//
//       if (isEndRideClicked == true) {
//         print(" Ajay ERT");
//         print("object");
//         _handleEndRide(latitude, longitude);
//         return;
//       }
//
//       if (isStartWayPointClicked == true) {
//         print(" Ajay ERT");
//         print("object");
//         _handleEndRide(latitude, longitude);
//         return;
//       }
//       if (isCloseWayPointClicked == true) {
//         print(" Ajay ERT");
//         print("object");
//         _handleEndRide(latitude, longitude);
//         return;
//       }
//
//       // Ensure vehicleNumber and tripStatus are available before calling saveLocation
//       if (vehicleNumber.isNotEmpty && tripStatus.isNotEmpty) {
//         saveLocationCustomer(latitude, longitude);
//       } else {
//         print("⚠ Trip details not loaded yet, waiting...");
//       }
//     } else {
//       print("⚠ Location data is null, skipping update");
//     }
//   }
//
//
//
// //save lat long in bloc starts
//   void saveLocationCustomer(double latitude, double longitude) {
//     print("Inside saveLocation function");
//     print("Vehicle Number: $vehicleNumber, Trip Status: $tripStatus");
//     // Prevent saving if latitude and longitude are (0.0, 0.0)
//     if (latitude == 0.0 && longitude == 0.0) {
//       print("⚠ Invalidd location (0.0, 0.0) - Not saving to database.");
//       return; // Stop execution
//     }
//
//     if (vehicleNumber.isNotEmpty && tripStatus.isNotEmpty) {
//       print("Dispatching SaveLocationToDatabase eevent...");
//       context.read<TripTrackingDetailsBloc>().add(
//         SaveLocationToDatabase(
//           latitude: latitude,
//           longitude: longitude,
//           vehicleNo: vehicleNumber,
//           tripId: widget.tripId,
//           tripStatus: tripStatus,
//         ),
//       );
//     } else {
//       print("Trip details are not yet loaded. Cannot save location.");
//     }
//   }
// //save lat long in bloc completed
//
//
//
// //save lat long with way point in bloc starts
//   void saveWayPointLocationCustomer(double latitude, double longitude) {
//     print("iInside saveLocation function");
//     print("Vehicle Number: $vehicleNumber, Trip Status: $tripStatus");
//     // Prevent saving if latitude and longitude are (0.0, 0.0)
//     if (latitude == 0.0 && longitude == 0.0) {
//       print("⚠ Invalidd location (0.0, 0.0) - Not saving to database.");
//       return; // Stop execution
//     }
//
//     if (vehicleNumber.isNotEmpty && tripStatus.isNotEmpty) {
//       print("Dispatching SaveLocationToDatabase event...");
//       context.read<TripTrackingDetailsBloc>().add(
//         SaveLocationToDatabase(
//           latitude: latitude,
//           longitude: longitude,
//           vehicleNo: vehicleNumber,
//           tripId: widget.tripId,
//           tripStatus: 'waypoint',
//         ),
//       );
//     } else {
//       print("Trip details are not yet loaded. Cannot save location.");
//     }
//   }
// //save lat long with way point in bloc completed
//
//
//
// //for reached status starts
//   void _handleEndRide(double latitude, double longitude) {
//     context.read<TripTrackingDetailsBloc>().add(
//       EndRideEvent(
//
//         latitude: latitude,
//         longitude: longitude,
//         vehicleNo: vehicleNumber,
//         tripId: widget.tripId,
//         tripStatus: tripStatus,
//       ),
//
//     );
//   }
// //for reached status completed
//
//
//
// //for waypoint start status starts
//   void _handleWaypointStartingStatusB(double latitude, double longitude)  {
//     print(
//         "ssSaving start location: Latitude = $latitude, Longitude = $longitude"); // Debugging print
//     if (latitude == 0.0 && longitude == 0.0) {
//       print("⚠ Invalidd location (0.0, 0.0) - Not saving to database.");
//       return; // Stop execution
//     }
//     context.read<TripTrackingDetailsBloc>().add(
//       StartWayPointEvent(
//         latitude: latitude,
//         longitude: longitude,
//         vehicleNo: vehicleNumber,
//         tripId: widget.tripId,
//         tripStatus: tripStatus,
//       ),
//
//     );
//   }
// //for waypoint start status completed
//
//
//
// //for waypoint completed status starts
//   void _handleWaypointCompletedStatusB(double latitude, double longitude)  {
//     print(
//         "ssSaving start location: Latitude = $latitude, Longitude = $longitude"); // Debugging print
//     if (latitude == 0.0 && longitude == 0.0) {
//       print("⚠ Invalidd location (0.0, 0.0) - Not saving to database.");
//       return; // Stop execution
//     }
//     context.read<TripTrackingDetailsBloc>().add(
//       EndWayPointEvent(
//         latitude: latitude,
//         longitude: longitude,
//         vehicleNo: vehicleNumber,
//         tripId: widget.tripId,
//         tripStatus: tripStatus,
//       ),
//
//     );
//   }
// //for waypoint completed status completed
//
//
//
//   Future<void> _fetchRouteCustomer() async {
//     if (_currentLatLng == null) return;
//
//     const String apiKey = AppConstants.ApiKey;
//     final String url =
//         'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLatLng!.latitude},${_currentLatLng!.longitude}&destination=${_destination.latitude},${_destination.longitude}&key=$apiKey';
//
//     try {
//       final response = await Dio().get(url);
//       if (response.statusCode == 200) {
//         final data = response.data;
//         final routes = data['routes'] as List;
//         if (routes.isNotEmpty) {
//           final polyline = routes[0]['overview_polyline']['points'] as String;
//           setState(() {
//             _routeCoordinates = _decodePolylineCustomer(polyline);
//           });
//         } else {
//           print('No routes found in API response.');
//         }
//       } else {
//         print('API response error: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching route: $e');
//     }
//   }
//
//   List<LatLng> _decodePolylineCustomer(String encoded) {
//     List<LatLng> polylineCoordinates = [];
//     int index = 0, len = encoded.length;
//     int lat = 0, lng = 0;
//
//     while (index < len) {
//       int b, shift = 0, result = 0;
//       do {
//         b = encoded.codeUnitAt(index++) - 63;
//         result |= (b & 0x1f) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//       int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
//       lat += dlat;
//
//       shift = 0;
//       result = 0;
//       do {
//         b = encoded.codeUnitAt(index++) - 63;
//         result |= (b & 0x1f) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//       int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
//       lng += dlng;
//
//       final point = LatLng(lat / 1e5, lng / 1e5);
//       polylineCoordinates.add(point);
//     }
//
//     return polylineCoordinates;
//   }
//
//
//
//
//
//
//
//
//
//
//
//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         _duration += Duration(seconds: 1);
//       });
//     });
//   }
//
//
//
//
//   String _formatDuration(Duration d) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final hours = twoDigits(d.inHours);
//     final minutes = twoDigits(d.inMinutes.remainder(60));
//     final seconds = twoDigits(d.inSeconds.remainder(60));
//     return "$hours:$minutes:$seconds";
//   }
//
//
//
//
//
//
//
//
//   @override
//   void dispose() {
//     // _locationSubscription!.cancel();
//     _locationSubscription?.cancel();
//     _locationSubscription = null;// Remove reference
//
//     _timer?.cancel(); // Cancel timer when widget is removed
//     _positionStreamSubscription?.cancel();
//     super.dispose();
//   }
//
//
//   void _showEndRideConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Confirm End Ride"),
//           content: Text("Do you really want to end the ride?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close the dialog
//               },
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close the dialog
//                 _endRide(); // Call the function to handle ending the ride
//               },
//               child: Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _endRide() {
//     print('for current ');
//     isEndRideClicked = true;
//
//     Future.delayed(Duration(seconds: 1), () {
//       isEndRideClicked = false;
//       print("🔄 End Ride button reset, can be clicked again.");
//     });
//
//     if (_currentLatLng != null) {
//       _handleEndRide(_currentLatLng!.latitude, _currentLatLng!.longitude);
//       // Navigator.push(
//       //   context,
//       //   MaterialPageRoute(
//       //     builder: (context) => TripDetailsUpload(tripId: widget.tripId),
//       //   ),
//       // );
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//           builder: (context) => Signatureendride(tripId: widget.tripId),
//         ),(route)=>false
//       );
//
//
//       print('for current location');
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Location not available yet!")),
//       );
//       showWarningSnackBar(context, "Location not available yet!");
//     }
//   }
//
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     String dropLocation = globals.dropLocation; // Access the global variable
//     bool isConnected = Provider.of<NetworkManager>(context).isConnected;
//     globals.savedTripDistance = _totalDistance;
//
//     return BlocListener<TripTrackingDetailsBloc, TripTrackingDetailsState>(
//         listener: (context, state) {
//           if (state is TripTrackingDetailsLoaded) {
//             setState(() {
//               vehicleNumber = state.vehicleNumber;
//               tripStatus = state.status;
//             });
//
//             print("Trip details loaded. Vehicle: $vehicleNumber, Status: $tripStatus");
//
//             // Ensure trip details are set before calling saveLocation
//             if (vehicleNumber.isNotEmpty && tripStatus.isNotEmpty) {
//               saveLocationCustomer(0.0 , 0.0); // Example coordinates
//             } else {
//               print("Trip details are still empty after setting state.");
//             }
//           } else if (state is SaveLocationSuccess) {
//             // ScaffoldMessenger.of(context).showSnackBar(
//             //   SnackBar(content: Text("Location saved successfully!")),
//             // );
//             print("inside the success function");
//           } else if (state is SaveLocationFailure) {
//             // ScaffoldMessenger.of(context).showSnackBar(
//             //   SnackBar(content: Text(state.errorMessage)),
//             // );
//             showFailureSnackBar(context, state.errorMessage);
//           }
//         },
//
//           child:Scaffold (
//         appBar: AppBar(
//           title: Text("Trip Started"),
//         ),
//        body: RefreshIndicator(onRefresh: _refreshCustomerDestination,
//
//       child:Stack(
//         children: [
//           if (!_isMapLoading && _currentLatLng != null)
//             GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: _currentLatLng!,
//                 zoom: 15,
//               ),
//               onMapCreated: (controller) {
//                 _mapController = controller;
//                 Future.delayed(Duration(milliseconds: 500), () {
//                   if (mounted) {
//                     setState(() {
//                       _isMapLoading = false; // Hide loader after small delay
//                     });
//                   }
//                 });
//               },
//               markers: {
//                 Marker(
//                   markerId: MarkerId('currentLocation'),
//                   position: _currentLatLng!,
//                   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//
//                 ),
//                 Marker(
//                   markerId: MarkerId('destination'),
//                   position: _destination,
//                 ),
//               },
//               polylines: {
//                 if (_routeCoordinates.isNotEmpty)
//                   Polyline(
//                     polylineId: PolylineId('route'),
//                     points: _routeCoordinates,
//                     color: Colors.green,
//                     width: 5,
//                   ),
//               },
//               myLocationEnabled: true,
//               myLocationButtonEnabled: false,
//             ),
//           if (_isMapLoading)
//           Positioned.fill(
//               child: Container(
//                 color: Colors.white.withOpacity(0.9), // Optional: add slight overlay
//                 child: Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               ),
//             ),
//
//           Positioned(
//             top: 50,
//             left: 10,
//             child: Container(
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
//               ),
//               child: Text(
//                 "Distance Traveled: ${_totalDistance.toStringAsFixed(2)} km \n"
//                 "Duration: ${_formatDuration(_duration)}",
//
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//
//           Positioned(
//             bottom: 0, // Aligns the bottom section
//             left: 0,
//             right: 0,
//             child: IgnorePointer(
//               ignoring: false, // Allows interaction with the map below
//               child: Container(
//                 // height: 100, // Adjust height as needed
//                 padding: EdgeInsets.all(16),
//                 color: Colors.white, // Semi-transparent background
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     //  Text(
//                     //   'Drop Location: ${globals.dropLocation}',
//                     //   style: TextStyle(fontSize: 18.0),
//                     // ),
//                     SizedBox(height: 10.0,),
//
//                     Row(
//                       children: [
//
//                         Column(
//                           children: [
//                             Icon(Icons.person_pin_circle, color: Colors.green, size: 30),
//                             Container(
//                               width: 2,
//                               height: 30,
//                               color: Colors.grey.shade400,
//                             ),
//                             Icon(Icons.location_on, color: Colors.red, size: 30),
//                           ],
//                         ),
//                         SizedBox(width: 12), // Space between icon and address
//                         Expanded(
//
//                           child: Row(
//                             children: [
//                               Container(
//                                 // width: MediaQuery.of(context).size.width * 0.5, // 70% of screen width
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Current Location',
//                                       style: TextStyle(
//                                         color: Colors.grey.shade800,
//                                         fontSize: 20.0,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     SizedBox(height: 32),
//                                     Text(
//                                       '$dropLocation',
//                                       style: TextStyle(
//                                         color: Colors.grey.shade800,
//                                         fontSize: 20.0,
//                                       ),
//                                     ),
//                                     // Text(
//                                     //   "📦 Stored Distance: ${globals.savedTripDistance.toStringAsFixed(2)} km",
//                                     //   style: TextStyle(fontSize: 16, color: Colors.black),
//                                     // ),
// // SizedBox(height: 10.0,),
// //                                     Text('Current TripStatus:  $tripStatus', style: TextStyle(fontSize: 20.0),),
//                                   ],
//                                 ),
//                               ),
//
//                               SizedBox(width: 30.0,),
//
//                               // Center(
//                               //   child: Container(
//                               //     width: 100,
//                               //     height: 100,
//                               //     decoration: BoxDecoration(
//                               //       shape: BoxShape.circle,
//                               //       border: Border.all(color: Colors.green, width: 6), // Circular Border
//                               //     ),
//                               //     alignment: Alignment.center,
//                               //     child: Text(
//                               //       _formatTime(_milliseconds),
//                               //       style: TextStyle(
//                               //         fontSize: 20,
//                               //         fontWeight: FontWeight.bold,
//                               //         color: Colors.green,
//                               //         fontFamily: "Digital",
//                               //       ),
//                               //     ),
//                               //   ),
//                               // ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//
//
//
//
//                     // SizedBox(height: 20.0,),
//                     // if (!isRideStopped)
//                     //   SizedBox(
//                     //     width: double.infinity,
//                     //     child: ElevatedButton(
//                     //       onPressed: () {
//                     //         setState(() {
//                     //           isRideStopped = true; // Hide Stop, Show Start
//                     //           // Statusvalue = "waypoint"; // Set Trip_Status to "waypoint"
//                     //         });
//                     //         _startStopwatch();
//                     //         isStartWayPointClicked = true; // Set flag to true when button is clicked
//                     //
//                     //
//                     //         Future.delayed(Duration(seconds: 1), () {
//                     //           isStartWayPointClicked = false;
//                     //           print("🔄 End Ride button reset, can be clicked again.");
//                     //         });
//                     //
//                     //         // Call the function to save location with updated status
//                     //         if (_currentLatLng != null) {
//                     //           // _handleWaypointStartingStatus(_currentLatLng!.latitude, _currentLatLng!.longitude);
//                     //           _handleWaypointStartingStatusB(_currentLatLng!.latitude, _currentLatLng!.longitude);
//                     //
//                     //           saveWayPointLocationCustomer(
//                     //             _currentLatLng!.latitude,
//                     //             _currentLatLng!.longitude,
//                     //           );
//                     //         } else {
//                     //           print("Error: _currentLatLng is null");
//                     //         }
//                     //
//                     //       },
//                     //       style: ElevatedButton.styleFrom(
//                     //         backgroundColor: Colors.deepPurple,
//                     //         padding: EdgeInsets.symmetric(vertical: 16),
//                     //         shape: RoundedRectangleBorder(
//                     //           borderRadius: BorderRadius.circular(8),
//                     //         ),
//                     //       ),
//                     //       child: Text(
//                     //         'Stop Ride',
//                     //         style: TextStyle(fontSize: 20.0, color: Colors.white),
//                     //       ),
//                     //     ),
//                     //   ),
//                     //
//                     // // Start Ride Button (Shown after Stop Ride is clicked)
//                     // if (isRideStopped)
//                     //   SizedBox(
//                     //     width: double.infinity,
//                     //     child: ElevatedButton(
//                     //       onPressed: () {
//                     //         setState(() {
//                     //           isRideStopped = false; // Hide Stop, Show Start
//                     //           Statusvalue = 'On_Going'; // Set Trip_Status to "waypoint"
//                     //         });
//                     //         _stopStopwatch();
//                     //         isCloseWayPointClicked = true; // Set flag to true when button is clicked
//                     //
//                     //
//                     //         Future.delayed(Duration(seconds: 1), () {
//                     //           isCloseWayPointClicked = false;
//                     //           print("🔄 End Ride button reset, can be clicked again.");
//                     //         });
//                     //
//                     //
//                     //         // Call the function to save location with updated status
//                     //         if (_currentLatLng != null) {
//                     //
//                     //           // _handleWaypointCompletedStatus(
//                     //           // _currentLatLng!.latitude,
//                     //           // _currentLatLng!.longitude,
//                     //           // );
//                     //
//                     //           _handleWaypointCompletedStatusB(
//                     //           _currentLatLng!.latitude,
//                     //           _currentLatLng!.longitude,
//                     //           );
//                     //
//                     //           _saveLocationToDatabaseCustomer(
//                     //             _currentLatLng!.latitude,
//                     //             _currentLatLng!.longitude,
//                     //           );
//                     //         } else {
//                     //           print("Error: _currentLatLng is null");
//                     //         }
//                     //       },
//                     //       style: ElevatedButton.styleFrom(
//                     //         backgroundColor: Colors.green,
//                     //         padding: EdgeInsets.symmetric(vertical: 16),
//                     //         shape: RoundedRectangleBorder(
//                     //           borderRadius: BorderRadius.circular(8),
//                     //         ),
//                     //       ),
//                     //       child: Text(
//                     //         'Start Ride',
//                     //         style: TextStyle(fontSize: 20.0, color: Colors.white),
//                     //       ),
//                     //     ),
//                     //   ),
//                     // SizedBox(height: 20.0,),
//
//
//
//
//
//
//
//                     SizedBox(height: 20),
//                     // Row(
//                     //   mainAxisAlignment: MainAxisAlignment.center,
//                     //   children: [
//                     //     ElevatedButton(
//                     //       onPressed: _startTimer,
//                     //       child: Text("Start Timer"),
//                     //     ),
//                     //     SizedBox(width: 10),
//                     //     ElevatedButton(
//                     //       onPressed: _stopTimer,
//                     //       child: Text("Stop Timer"),
//                     //     ),
//                     //   ],
//                     // ),
//
//
//
//
//
//
//                       SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         // onPressed: () {
//                         //   print('for current ');
//                         //   isEndRideClicked = true; // Set flag to true when button is clicked
//                         //
//                         //   setState(() {
//                         //     // isEndRideClicked = true; // Set flag to true when button is clicked
//                         //     // Statusvalue = "waypoint"; // Set Trip_Status to "waypoint"
//                         //   });
//                         //   Future.delayed(Duration(seconds: 1), () {
//                         //     isEndRideClicked = false;
//                         //     print("🔄 End Ride button reset, can be clicked again.");
//                         //   });
//                         //   if (_currentLatLng != null) {
//                         //
//                         //     // _handleEndRide(double latitude, double longitude);
//                         //     _handleEndRide(_currentLatLng!.latitude, _currentLatLng!.longitude);
//                         //     Navigator.push(
//                         //       context,
//                         //       MaterialPageRoute(
//                         //         builder: (context) => TripDetailsUpload(tripId: widget.tripId),
//                         //       ),
//                         //     );
//                         //     print('for current location');
//                         //
//                         //
//                         //     } else {
//                         //       ScaffoldMessenger.of(context).showSnackBar(
//                         //         SnackBar(content: Text("llLocation not available yet!")),
//                         //       );
//                         //       showWarningSnackBar(context, "Location not available yet!");
//                         //     }
//                         //
//                         // },
//                         onPressed: () {
//                           _showEndRideConfirmationDialog(context);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           padding: EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: Text(
//                           'End Ride',
//                           style: TextStyle(fontSize: 20.0, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 15,
//             left: 0,
//             right: 0,
//             child: NoInternetBanner(isConnected: isConnected),
//           ),
//         ],
//       ),
//
//        )
//     )
//     );
//   }
//
//
//
//
// }

























import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:jessy_cabs/Screens/SignatureEndRide/SignatureEndRide.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:dio/dio.dart';
import 'package:jessy_cabs/GlobalVariable/global_variable.dart' as globals;
import 'package:jessy_cabs/Utils/AllImports.dart';

import 'dart:async';
import '../NativeTracker.dart';
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
import 'package:flutter/services.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';


class Customerlocationreached extends StatefulWidget {
  final String tripId;
  const Customerlocationreached({super.key, required this.tripId});

  @override
  State<Customerlocationreached> createState() => _CustomerlocationreachedState();
}

class _CustomerlocationreachedState extends State<Customerlocationreached>   {



  GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  // late LatLng _destination;
  LatLng _destination = LatLng(0.0, 0.0); // Initialized with default value
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

  double _initialDistance = 0.0;
  // static const platform = MethodChannel('com.example.jessy_cabs/tracking');
  static const MethodChannel _channel =
  MethodChannel('com.example.jessy_cabs/tracking');
  static const MethodChannel _distancechannel = MethodChannel('com.example.jessy_cabs/background');
  static const MethodChannel _trackingChannel = MethodChannel('com.example.jessy_cabs/tracking');

  double totalDistanceInKm = 0.0;

  @override
  void initState() {
    super.initState();
    // _channel.setMethodCallHandler((call) async {
    //   if (call.method == 'locationUpdate') {
    //     final Map<dynamic, dynamic> locationMap = call.arguments;
    //     double totalDistanceMeters = locationMap['totalDistance'] ?? 0.0;
    //
    //     setState(() {
    //       totalDistanceInKm = totalDistanceMeters / 1000;
    //     });
    //   }
    // });



    // const platform = MethodChannel('com.example.jessy_cabs/background');
    // platform.invokeMethod('startTrackingForCurrentPage');
    NativeTracker.startTracking();

    //
    // _distancechannel.setMethodCallHandler((call) async {
    //   print("inside the distance function");
    //   if (call.method == 'locationUpdate') {
    //     final Map<dynamic, dynamic> locationMap = call.arguments;
    //
    //     print('📱 Received from native: $locationMap');
    //
    //
    //     double totalDistanceMeters = locationMap['totalDistance'] ?? 0.0;
    //
    //     setState(() {
    //       totalDistanceInKm = totalDistanceMeters / 1000;
    //     });
    //
    //   }
    // });
    // print("total km by ky $totalDistanceInKm");


    _initializeCustomerLocationTracking();

    context.read<TripTrackingDetailsBloc>().add(
        FetchTripTrackingDetails(widget.tripId));
    _checkMapLoading();

    _startTracking();

    // _setDestinationFromDropLocation();
    _startTimer();

    saveScreenData();
    _setDestinationFromDropLocation();
    _loadTripSheetDetailsByTripId();
    loadSavedDistance();       // Load pref on screen open
    listenToDistanceUpdates(); // Listen for real-time updates
  }

  Future<void> loadSavedDistance() async {
    try {
      final savedDistance = await _trackingChannel.invokeMethod("getSavedDistance");
      setState(() {
        totalDistanceInKm = (savedDistance as num?)?.toDouble() ?? 0.0;
        totalDistanceInKm /= 1000; // convert meters to kilometers
      });
      print('✅ Distance loaded from native: $totalDistanceInKm km');
    } catch (e) {
      print('❌ Error loading distance: $e');
    }
  }

  // static const MethodChannel _distanceChannel = MethodChannel('com.example.jessy_cabs/background');

  void listenToDistanceUpdates() {
    _trackingChannel.setMethodCallHandler((call) async {
      if (call.method == 'locationUpdate') {
        final Map<dynamic, dynamic> data = call.arguments;
        final totalMeters = (data['totalDistance'] as num?)?.toDouble() ?? 0.0;

        setState(() {
          totalDistanceInKm = totalMeters / 1000;
        });

        print("📡 Live update: $totalDistanceInKm km");
      }
    });
  }


  Future<void> clearSavedDistance() async {
    try {
      await _trackingChannel.invokeMethod("clearSavedDistance");
      print("✅ SharedPreferences cleared");
      setState(() {
        totalDistanceInKm = 0.0;
      });
    } catch (e) {
      print("❌ Failed to clear distance: $e");
    }
  }



  void startLoop() {
    Timer.periodic(Duration(seconds: 4), (timer) {
      loadSavedDistance();
showInfoSnackBar(context, "total km by ky $totalDistanceInKm");
    });
  }
  Future<void> _loadTripSheetDetailsByTripId() async {

    try {

      // Fetch trip details from the API

      final tripDetails = await ApiService.fetchTripDetails(widget.tripId);

      print('Trip details fetchedd: $tripDetails');

      if (tripDetails != null) {

        var desti = tripDetails['useage'].toString();

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

        _setDestinationFromDropLocation();

      } else {

        print('No trip details found.');

      }

    } catch (e) {

      print('Error loading trip details: $e');

    }

  }

  Future<void> saveScreenData() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('last_screen', 'customerLocationPage');

    await prefs.setString('trip_id', widget.tripId);

    await prefs.setString('drop_location', Tripdestination!); // 🔥 Save droplocation too


  }


  void _setDestinationFromDropLocation() async {
    try {
      // String address = globals.dropLocation; // Example: "Tambaram"
      String address = Tripdestination ?? ''; // Example: "Tambaram"


      print("Address to be converted: $address");

      // List<Location> locations = await locationFromAddress(address);
      List<geocoding.Location> locations = await geocoding.locationFromAddress(address);

      if (locations.isNotEmpty) {
        double lat = locations[0].latitude;
        double lng = locations[0].longitude;

        _destination = LatLng(lat, lng);
        print("Destination coordinates: $_destination");
      } else {
        throw Exception("No coordinates found for the address.");
      }
    } catch (e) {
      print("Error converting address to coordinates: $e");
      _destination = LatLng(0.0, 0.0); // fallback
    }
  }

  void _startTracking() {
    final locationSettings = geo.LocationSettings(
      accuracy: geo.LocationAccuracy.high, // Use `geo.` prefix
      distanceFilter: 10,
    );


    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
          LatLng newLocation = LatLng(position.latitude, position.longitude);

          // If we have a previous location, calculate distance
          if (_lastLocation != null) {
            double distanceInMeters = Geolocator.distanceBetween(
              _lastLocation!.latitude,
              _lastLocation!.longitude,
              newLocation.latitude,
              newLocation.longitude,
            );

            setState(() {
              _totalDistance += distanceInMeters / 1000; // Convert meters to km
            });
          }

          _lastLocation = newLocation; // Update last known location
        });
  }



  // void _startTracking() {
  //   final locationSettings = geo.LocationSettings(
  //     accuracy: geo.LocationAccuracy.high,
  //     distanceFilter: 10,
  //   );
  //
  //   _positionStreamSubscription =
  //       Geolocator.getPositionStream(locationSettings: locationSettings)
  //           .listen((Position position) {
  //         LatLng newLocation = LatLng(position.latitude, position.longitude);
  //
  //         if (_lastLocation != null) {
  //           double distanceInMeters = Geolocator.distanceBetween(
  //             _lastLocation!.latitude,
  //             _lastLocation!.longitude,
  //             newLocation.latitude,
  //             newLocation.longitude,
  //           );
  //
  //           setState(() {
  //             _totalDistance += distanceInMeters / 1000; // meters to km
  //           });
  //         }
  //
  //         _lastLocation = newLocation;
  //       });
  // }


  // Future<void> _getSavedDistanceFromNative() async {
  //   try {
  //     final double distance = await platform.invokeMethod('getSavedDistance');
  //     _initialDistance = distance;
  //     _totalDistance += _initialDistance;
  //     setState(() {}); // refresh UI
  //   } catch (e) {
  //     print("Failed to get distance: $e");
  //   }
  // }


  void _checkMapLoading() {
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isMapLoading = false; // Ensure loader disappears
        });
      }
    });
  }


  Future<void> _refreshCustomerDestination() async {
    _initializeCustomerLocationTracking();

    context.read<TripTrackingDetailsBloc>().add(
        FetchTripTrackingDetails(widget.tripId));
  }

  StreamSubscription<LocationData>? _locationSubscription; // Store the subscription

  Future<void> _initializeCustomerLocationTracking() async {
    // Location location = Location();
    loc.Location location = loc.Location();

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

  // main Function to send location data to API


  void _updateCustomerCurrentLocation(LocationData locationData) {
    double? latitude = locationData.latitude;
    double? longitude = locationData.longitude;

    if (latitude != null && longitude != null) {
      print("Received Location: $latitude, $longitude");

      final newLatLng = LatLng(latitude, longitude);

      setState(() {
        _currentLatLng = newLatLng;
      });

      _fetchRouteCustomer();
      _updateCustomerCameraPosition();


      // Check if location is (0.0, 0.0) – if so, do nothing
      if (latitude == 0.0 && longitude == 0.0) {
        print("⚠ Invalid location (0.0, 0.0), skipping saveLocation.");
        return; // Stop execution here
      }



      if (isEndRideClicked == true) {
        print(" Ajay ERT");
        print("object");
        _handleEndRide(latitude, longitude);
        return;
      }
      // Ensure vehicleNumber and tripStatus are available before calling saveLocation
      if (vehicleNumber.isNotEmpty && tripStatus.isNotEmpty && tripStatus=='On_Going') {
        saveLocationCustomer(latitude, longitude);

      } else {
        print("⚠ Trip details not loaded yet, waiting...");
      }
    } else {
      print("⚠ Location data is null, skipping update");
    }
  }





//save lat long in bloc starts
  void saveLocationCustomer(double latitude, double longitude) {
    print("Inside saveLocation function");
    print("Vehicle Number: $vehicleNumber, Trip Status: $tripStatus");
    // Prevent saving if latitude and longitude are (0.0, 0.0)
    if (latitude == 0.0 && longitude == 0.0) {
      print("⚠ Invalidd location (0.0, 0.0) - Not saving to database.");
      return; // Stop execution
    }

    if (vehicleNumber.isNotEmpty && tripStatus.isNotEmpty) {
      print("Dispatching SaveLocationToDatabase eevent...");
      context.read<TripTrackingDetailsBloc>().add(
        SaveLocationToDatabase(
          latitude: latitude,
          longitude: longitude,
          vehicleNo: vehicleNumber,
          tripId: widget.tripId,
          tripStatus: 'On_Going',
        ),
      );
    } else {
      print("Trip details are not yet loaded. Cannot save location.");
    }
  }
//save lat long in bloc completed




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

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _duration += Duration(seconds: 1);
      });
    });
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    // _locationSubscription!.cancel();
    _locationSubscription?.cancel();
    _locationSubscription = null;// Remove reference

    _timer?.cancel(); // Cancel timer when widget is removed
    _positionStreamSubscription?.cancel();
    // const platform = MethodChannel('com.example.jessy_cabs/background');
    // platform.invokeMethod('stopTrackingForCurrentPage');
    NativeTracker.stopTracking();


    super.dispose();
  }

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
    clearSavedDistance();
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

    if (_currentLatLng != null) {
      _handleEndRide(_currentLatLng!.latitude, _currentLatLng!.longitude);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Signatureendride(tripId: widget.tripId),
          ),(route)=>false
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location not available yet!")),
      );
      showWarningSnackBar(context, "Location not available yet!");
    }
  }

  Future<void> ForNumberAndIdInbackEndKT() async {
    await NativeTracker.setTrackingMetadata(tripId: widget.tripId, vehicleNumber: vehicleNumber);
    await NativeTracker.startTracking();
  }

  @override
  Widget build(BuildContext context) {
    // String dropLocation = globals.dropLocation; // Access the global variable
    bool isConnected = Provider.of<NetworkManager>(context).isConnected;
    globals.savedTripDistance = _totalDistance;

    return BlocListener<TripTrackingDetailsBloc, TripTrackingDetailsState>(
        listener: (context, state) {
          if (state is TripTrackingDetailsLoaded) {
            setState(() {
              vehicleNumber = state.vehicleNumber;
              tripStatus = state.status;
            });


            print("Trip details loaded. Vehicle: $vehicleNumber, Status: $tripStatus");

            // const platform = MethodChannel('com.example.jessy_cabs/background');
            // platform.invokeMethod('setTrackingMetadata', {
            //   'tripId': widget.tripId,
            //   'vehicleNumber': vehicleNumber,
            // });

            ForNumberAndIdInbackEndKT();







            // Ensure trip details are set before calling saveLocation
            if (vehicleNumber.isNotEmpty && tripStatus.isNotEmpty && tripStatus == 'On_Going') {
              saveLocationCustomer(0.0 , 0.0); // Example coordinates
            } else {
              print("Trip details are still empty after setting state.");
            }
          } else if (state is SaveLocationSuccess) {
            // showSuccessSnackBar(context, "Location saved successfully! $tripStatus");
            print("inside the success function");
          } else if (state is SaveLocationFailure) {

            showFailureSnackBar(context, state.errorMessage);
          }
        },
        child:Scaffold (
            appBar: AppBar(
              title: Text("Trip Started"),
              automaticallyImplyLeading: false, // 👈 disables the default back icon

            ),
            body: RefreshIndicator(onRefresh: _refreshCustomerDestination,

              child:Stack(
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
                          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),

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
                    top: 50,
                    left: 10,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                      ),
                      child: Text(
                        'Total Distance: ${totalDistanceInKm.toStringAsFixed(4)} km \n'

                        "Distance Traveled: ${_totalDistance.toStringAsFixed(4)} km \n"
                            "Duration: ${_formatDuration(_duration)}",

                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
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
                                  child: Row(
                                    children: [
                                      Container(
                                        // width: MediaQuery.of(context).size.width * 0.5, // 70% of screen width
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Current Location',
                                              style: TextStyle(
                                                color: Colors.grey.shade800,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 32),
                                            Text(
                                              // '$dropLocation',
                                              Tripdestination ?? '',
                                              style: TextStyle(
                                                color: Colors.grey.shade800,
                                                fontSize: 20.0,
                                              ),
                                            ),
                                            Text(
                                              'Current status: $tripStatus',
                                              style: TextStyle(
                                                color: Colors.grey.shade800,
                                                fontSize: 20.0,
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),

                                      SizedBox(width: 30.0,),

                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(

                                onPressed: () {
                                  _showEndRideConfirmationDialog(context);
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
                  Positioned(
                    top: 15,
                    left: 0,
                    right: 0,
                    child: NoInternetBanner(isConnected: isConnected),
                  ),
                ],
              ),

            )
        )
    );
  }

}
