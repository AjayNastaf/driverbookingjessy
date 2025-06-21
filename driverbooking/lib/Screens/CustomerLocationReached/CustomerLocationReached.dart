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
//
//
//
//
//
//
//
// import 'dart:convert';
//
// import 'package:jessy_cabs/Screens/SignatureEndRide/SignatureEndRide.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:dio/dio.dart';
// import 'package:jessy_cabs/GlobalVariable/global_variable.dart' as globals;
// import 'package:jessy_cabs/Utils/AllImports.dart';
//
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
// import 'package:shared_preferences/shared_preferences.dart';
//
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
// class _CustomerlocationreachedState extends State<Customerlocationreached>   {
//
//
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
//   String? Tripdestination;
//   String? Testvehinum;
//   String? Testtripstatus;
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
//     // _setDestinationFromDropLocation();
//     _startTimer();
//
//     saveScreenData();
//
//     print('Drop Location: ${Tripdestination}');
//
//     print( 'sedfvgbhnjgggggggggggggggggg');
//
//     _loadTripSheetDetailsByTripId();
//   }
//
//   Future<void> _loadTripSheetDetailsByTripId() async {
//
//     try {
//
//       // Fetch trip details from the API
//
//       final tripDetails = await ApiService.fetchTripDetails(widget.tripId);
//
//       print('Trip details fetchedd: $tripDetails');
//
//       if (tripDetails != null) {
//
//
//
//         var desti = tripDetails['useage'].toString();
//
//         var vechnum = tripDetails['vehRegNo'].toString();
//         var tripstatetest = tripDetails['apps'].toString();
//
//         print('Trip details guest desti: $desti');
//         print('Trip details guest desti: $tripstatetest');
//         print('Trip details guest desti: $vechnum');
//
//
//
//         setState(() {
//
//           Tripdestination = desti;
//            Testvehinum = vechnum;
//            Testtripstatus = tripstatetest;
//
//         });
//
//         _setDestinationFromDropLocation();
//
//       } else {
//
//         print('No trip details found.');
//
//       }
//
//     } catch (e) {
//
//       print('Error loading trip details: $e');
//
//     }
//
//   }
//
//
//
//
//
//
//
//   Future<void> saveScreenData() async {
//
//     final prefs = await SharedPreferences.getInstance();
//
//     await prefs.setString('last_screen', 'customerLocationPage');
//
//     await prefs.setString('trip_id', widget.tripId);
//
//     await prefs.setString('drop_location', Tripdestination!); // 🔥 Save droplocation too
//
//
//     print('Saved screen data:');
//
//     print('last_screen: customerLocationPage');
//
//     print('trip_id: ${widget.tripId}');
//
//     print('drop_location: ${Tripdestination}'); // ✅ Debug log
//
//   }
//
//
//   void _setDestinationFromDropLocation() async {
//     try {
//       // String address = globals.dropLocation; // Example: "Tambaram"
//       String address = Tripdestination ?? ''; // Example: "Tambaram"
//
//
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
//   Future<void> _refreshCustomerDestination() async {
//     _initializeCustomerLocationTracking();
//
//     context.read<TripTrackingDetailsBloc>().add(
//         FetchTripTrackingDetails(widget.tripId));
//   }
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
//
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
//
//
//       if (isEndRideClicked == true) {
//         print(" Ajay ERT");
//         print("object");
//         _handleEndRide(latitude, longitude);
//         return;
//       }
//
//       // if (isStartWayPointClicked == true) {
//       //   print(" Ajay ERT");
//       //   print("object");
//       //   _handleEndRide(latitude, longitude);
//       //   return;
//       // }
//       // if (isCloseWayPointClicked == true) {
//       //   print(" Ajay ERT");
//       //   print("object");
//       //   _handleEndRide(latitude, longitude);
//       //   return;
//       // }
//
//
//
//
//
//       // Ensure vehicleNumber and tripStatus are available before calling saveLocation
//       if (vehicleNumber.isNotEmpty && tripStatus.isNotEmpty && tripStatus=='On_Going') {
//         saveLocationCustomer(latitude, longitude);
//
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
//           tripStatus: 'On_Going',
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
//   // void sendLocationToServer(double latitude, double longitude) async {
//   //   print("Vehicle Number sendLocationToServer  : $Testvehinum, Trip Status: $Testtripstatus");
//   //
//   //   try {
//   //     // Reverse geocode coordinates to get address
//   //     String address = '';
//   //     print("addddddddddddddddddd");
//   //     try {
//   //       print("➡ Starting reverse geocoding for coordinates: $latitude, $longitude");
//   //
//   //       List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(latitude, longitude);
//   //
//   //       print("✅ placemarkFromCoordinates call succeeded.");
//   //
//   //       if (placemarks.isNotEmpty) {
//   //         print("✅ Received non-empty placemarks list.");
//   //
//   //         final placemark = placemarks.first;
//   //         print("ℹ First Placemark: ${placemark.toJson()}"); // You can log all fields if needed
//   //
//   //         address = "${placemark.street},${placemark.thoroughfare},${placemark.subLocality}, ${placemark.locality},${placemark.postalCode}, ${placemark.administrativeArea}, ${placemark.country}";
//   //         print("📍 Constructed Address: $address");
//   //       } else {
//   //         print("⚠ placemarks list is empty.");
//   //       }
//   //     } catch (geoError) {
//   //       print("❌ Reverse geocoding failed with error: $geoError");
//   //       address = "Unknown address";
//   //     }
//   //
//   //     final response = await ApiService.addVehicleLocation(
//   //       vehicleno: Testvehinum ?? '',
//   //       latitudeloc: latitude,
//   //       longitutdeloc: longitude,
//   //       tripId: widget.tripId,
//   //       runingDate: Testtripstatus ?? '',
//   //       runingTime: DateTime.now().toIso8601String(),
//   //       tripStatus: DateTime.now().toIso8601String(),
//   //       tripStartTime: DateTime.now().toIso8601String(),
//   //       tripEndTime: DateTime.now().toIso8601String(),
//   //       createdAt: DateTime.now().toIso8601String(),
//   //       gpsPointAddrress: address,
//   //     );
//   //
//   //     final data = jsonDecode(response.body);
//   //     print("Server Response: ${data['message']}");
//   //   } catch (e) {
//   //     print("Error sending location: $e");
//   //   }
//   // }
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
//   Future<void> _endRide() async {
//     final String dateSignature = DateTime.now().toIso8601String().split('T')[0] + ' ' + DateTime.now().toIso8601String().split('T')[1].split('.')[0];
//     final String signTime = TimeOfDay.now().format(context); // Current time
//
//     try {
//       await ApiService.sendSignatureDetails(
//         tripId: widget.tripId,
//         dateSignature: dateSignature,
//         signTime: signTime,
//         status: "Accept",
//       );
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error uploading dataaaaaaaaaa: $error")),
//       );
//     }
//     print('for current ');
//     isEndRideClicked = true;
//
//     Future.delayed(Duration(seconds: 1), () {
//       isEndRideClicked = false;
//       print("🔄 End Ride button reset, can be clicked again.");
//     });
//
//     if (_currentLatLng != null) {
//
//       _handleEndRide(_currentLatLng!.latitude, _currentLatLng!.longitude);
//
//
//
//       Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (context) => Signatureendride(tripId: widget.tripId),
//           ),(route)=>false
//       );
//
//
//       // Navigator.push(context, MaterialPageRoute(builder: (context)=>Signatureendride(tripId: widget.tripId)));
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
//   @override
//   Widget build(BuildContext context) {
//     // String dropLocation = globals.dropLocation; // Access the global variable
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
//             if (vehicleNumber.isNotEmpty && tripStatus.isNotEmpty && tripStatus == 'On_Going') {
//               saveLocationCustomer(0.0 , 0.0); // Example coordinates
//             } else {
//               print("Trip details are still empty after setting state.");
//             }
//           } else if (state is SaveLocationSuccess) {
//             // showSuccessSnackBar(context, "Location saved successfully! $tripStatus");
//             print("inside the success function");
//           } else if (state is SaveLocationFailure) {
//
//             showFailureSnackBar(context, state.errorMessage);
//           }
//         },
//
//         child:Scaffold (
//             appBar: AppBar(
//               title: Text("Trip Started"),
//               automaticallyImplyLeading: false, // 👈 disables the default back icon
//
//             ),
//             body: RefreshIndicator(onRefresh: _refreshCustomerDestination,
//
//               child:Stack(
//                 children: [
//                   if (!_isMapLoading && _currentLatLng != null)
//                     GoogleMap(
//                       initialCameraPosition: CameraPosition(
//                         target: _currentLatLng!,
//                         zoom: 15,
//                       ),
//                       onMapCreated: (controller) {
//                         _mapController = controller;
//                         Future.delayed(Duration(milliseconds: 500), () {
//                           if (mounted) {
//                             setState(() {
//                               _isMapLoading = false; // Hide loader after small delay
//                             });
//                           }
//                         });
//                       },
//                       markers: {
//                         Marker(
//                           markerId: MarkerId('currentLocation'),
//                           position: _currentLatLng!,
//                           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//
//                         ),
//                         Marker(
//                           markerId: MarkerId('destination'),
//                           position: _destination,
//                         ),
//                       },
//                       polylines: {
//                         if (_routeCoordinates.isNotEmpty)
//                           Polyline(
//                             polylineId: PolylineId('route'),
//                             points: _routeCoordinates,
//                             color: Colors.green,
//                             width: 5,
//                           ),
//                       },
//                       myLocationEnabled: true,
//                       myLocationButtonEnabled: false,
//                     ),
//                   if (_isMapLoading)
//                     Positioned.fill(
//                       child: Container(
//                         color: Colors.white.withOpacity(0.9), // Optional: add slight overlay
//                         child: Center(
//                           child: CircularProgressIndicator(),
//                         ),
//                       ),
//                     ),
//
//                   Positioned(
//                     top: 50,
//                     left: 10,
//                     child: Container(
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                         boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
//                       ),
//                       child: Text(
//                         "Distance Traveled: ${_totalDistance.toStringAsFixed(2)} km \n"
//                             "Duration: ${_formatDuration(_duration)}",
//
//                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//
//                   Positioned(
//                     bottom: 0, // Aligns the bottom section
//                     left: 0,
//                     right: 0,
//                     child: IgnorePointer(
//                       ignoring: false, // Allows interaction with the map below
//                       child: Container(
//                         // height: 100, // Adjust height as needed
//                         padding: EdgeInsets.all(16),
//                         color: Colors.white, // Semi-transparent background
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//
//                             SizedBox(height: 10.0,),
//
//                             Row(
//                               children: [
//
//                                 Column(
//                                   children: [
//                                     Icon(Icons.person_pin_circle, color: Colors.green, size: 30),
//                                     Container(
//                                       width: 2,
//                                       height: 30,
//                                       color: Colors.grey.shade400,
//                                     ),
//                                     Icon(Icons.location_on, color: Colors.red, size: 30),
//                                   ],
//                                 ),
//                                 SizedBox(width: 12), // Space between icon and address
//                                 Expanded(
//
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         // width: MediaQuery.of(context).size.width * 0.5, // 70% of screen width
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               'Current Location',
//                                               style: TextStyle(
//                                                 color: Colors.grey.shade800,
//                                                 fontSize: 20.0,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                             SizedBox(height: 32),
//                                             Text(
//                                               // '$dropLocation',
//                                               Tripdestination ?? '',
//                                               style: TextStyle(
//                                                 color: Colors.grey.shade800,
//                                                 fontSize: 20.0,
//                                               ),
//                                             ),
//                                             Text(
//                                               'Current status: $tripStatus',
//                                               style: TextStyle(
//                                                 color: Colors.grey.shade800,
//                                                 fontSize: 20.0,
//                                               ),
//                                             ),
//
//                                           ],
//                                         ),
//                                       ),
//
//                                       SizedBox(width: 30.0,),
//
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//
//                             SizedBox(height: 20),
//
//
//                             SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton(
//
//                                 onPressed: () {
//                                   _showEndRideConfirmationDialog(context);
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.red,
//                                   padding: EdgeInsets.symmetric(vertical: 16),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   'End Ride',
//                                   style: TextStyle(fontSize: 20.0, color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 15,
//                     left: 0,
//                     right: 0,
//                     child: NoInternetBanner(isConnected: isConnected),
//                   ),
//                 ],
//               ),
//
//             )
//         )
//     );
//   }
//
//
//
//
// }
























import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:jessy_cabs/Screens/HomeScreen/HomeScreen.dart';
import 'package:jessy_cabs/Screens/LoginScreen/Login_Screen.dart';
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



class Customerlocationreached extends StatefulWidget {
  final String tripId;
  const Customerlocationreached({super.key, required this.tripId});

  @override
  State<Customerlocationreached> createState() => _CustomerlocationreachedState();
}

class _CustomerlocationreachedState extends State<Customerlocationreached>   {


  List<TextEditingController> otpControllers = List.generate(4, (_) => TextEditingController());
  List<FocusNode> otpFocusNodes = List.generate(4, (_) => FocusNode());

  bool isOtpComplete() {
    return otpControllers.every((controller) => controller.text.trim().isNotEmpty);
  }


  String getEnteredOtp() {
    return otpControllers.map((c) => c.text.trim()).join();
  }

  bool isOtpValid() {
    return getEnteredOtp() == otp;
  }


  bool showCheckmark = false;
  bool hideButton = true;
  String? otp;
  dynamic GetupdatedTime;
  dynamic updatedTimeJust;


// // for 5 minutes time

  bool _showOtpResendButton = false;
  int _otpTimerCount = 5;
  late Timer _otpResendTimer;

  GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  // LatLng _destination = LatLng(13.028159, 80.243306);
  // late LatLng _destination;

  LatLng _destination = LatLng(0.0, 0.0); // Initialized with default value

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
  String? guestMobileNo;
String? TripStartTime;
  Timer? _saveOkayTimer;



  @override
  void initState() {
    super.initState();
    _setDestinationFromDropLocation(); // Initialize properly
    _initializeCustomerLocationTracking();

    context.read<TripTrackingDetailsBloc>().add(
        FetchTripTrackingDetails(widget.tripId));
    _checkMapLoading();
    _startTracking();
    // _setDestinationFromDropLocation();
    _startTimer();

    saveScreenData();

    startOtpResendTimer();

    context.read<GetOkayBloc>().add(FetchOkaymessage(trip_id: widget.tripId));
    _loadTripSheetDetailsByTripId();
  }

  Future<void> _loadTripSheetDetailsByTripId() async {

    try {
      final tripDetails = await ApiService.fetchTripDetails(widget.tripId);

      print('Trip details fetchedd: $tripDetails');

      if (tripDetails != null) {
        var desti = tripDetails['useage'].toString();
        var vechnum = tripDetails['vehRegNo'].toString();
        var tripstatetest = tripDetails['apps'].toString();

        print('Trip details guest desti: $desti');

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




  void startOtpResendTimer() {
    _otpResendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_otpTimerCount > 0) {
        setState(() {
          _otpTimerCount--;
        });
      } else {
        setState(() {
          _showOtpResendButton = true;
          hideButton = false;
          showCheckmark = true;
        });
        timer.cancel();
      }
    });
  }


  Future<void> saveScreenData() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('last_screen', 'customerLocationPage');

    await prefs.setString('trip_id', widget.tripId);

    await prefs.setString('drop_location', Tripdestination!); // 🔥 Save droplocation too


    print('Saved screen data:');

    print('last_screen: customerLocationPage');

    print('trip_id: ${widget.tripId}');

    print('drop_location: ${Tripdestination}'); // ✅ Debug log

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

      // if (isStartWayPointClicked == true) {
      //   print(" Ajay ERT");
      //   print("object");
      //   _handleEndRide(latitude, longitude);
      //   return;
      // }
      // if (isCloseWayPointClicked == true) {
      //   print(" Ajay ERT");
      //   print("object");
      //   _handleEndRide(latitude, longitude);
      //   return;
      // }





      // Ensure vehicleNumber and tripStatus are available before calling saveLocation
      // if (vehicleNumber.isNotEmpty && tripStatus.isNotEmpty && tripStatus=='On_Going') {
      if (vehicleNumber.isNotEmpty && tripStatus.isNotEmpty ) {
        print('values present');
        saveLocationCustomer(latitude, longitude);

      } else {
        print("⚠ Trip details not loaded yet, wwwaiting...");
      }





    } else {
      print("⚠ Location data is null, skipping update");
    }
  }





//save lat long in bloc starts
  void saveLocationCustomer(double latitude, double longitude) async {
    final now = DateTime.now();
    final currentTimeStr = DateFormat("HH:mm:ss.SSS").format(now); // "15:43:21.123"

    final currentTime = DateFormat("HH:mm:ss.SSS").parse(currentTimeStr);
    final updatedTime = DateFormat("HH:mm:ss.SSS").parse(GetupdatedTime);

    print("Current Time: $currentTimeStr");
    print("Updated Time: $GetupdatedTime");

    print("CurrentTime datatype: ${currentTime.runtimeType}");
    print("UpdatedTime datatype: ${updatedTime.runtimeType}");


    print("Inside saveLocation function");
    print("Vehicle Number: $vehicleNumber, Trip Status: $tripStatus");
    // Prevent saving if latitude and longitude are (0.0, 0.0)
    if (latitude == 0.0 && longitude == 0.0) {
      print("⚠ Invalidd location (0.0, 0.0) - Not saving to database.");
      return; // Stop execution
    }


    if (currentTime.isAfter(updatedTime) || currentTime.isAtSameMomentAs(updatedTime)) {
      if (vehicleNumber.isNotEmpty && tripStatus.isNotEmpty) {
        print("Dispatching SaveLocationToDatabase eevent with send okay message to Bloc");

        context.read<TripTrackingDetailsBloc>().add(
          SaveLocationToDatabase(
            latitude: latitude,
            longitude: longitude,
            vehicleNo: vehicleNumber,
            tripId: widget.tripId,
            tripStatus: 'On_Going',
            reached_30minutes: "okay",
          ),
        );

        print('i triggered okay message event dispath and delete the privious time ${currentTime}');
        SharedPreferences pref = await SharedPreferences.getInstance();

        await pref.remove("updated_start_time");

        // context.read<GetOkayBloc>().add(FetchOkaymessage(trip_id: widget.tripId));



      }
    }  else {

      if (vehicleNumber.isNotEmpty && tripStatus.isNotEmpty) {
        print("Dispatching SaveLocationToDatabase eevent... ${currentTime}");

        context.read<TripTrackingDetailsBloc>().add(
          SaveLocationToDatabase(
            latitude: latitude,
            longitude: longitude,
            vehicleNo: vehicleNumber,
            tripId: widget.tripId,
            tripStatus: 'On_Going',
            reached_30minutes:"null",
          ),
        );



      } else {
        print("Trip details are not yet loaded. Cannot save location.");
      }
    }

  }
//save lat long in bloc completed

//save lat long with way point in bloc starts
  void saveWayPointLocationCustomer(double latitude, double longitude) {
    const notReached = "null";

    print("iInside saveLocation function");
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
          tripId: widget.tripId,
          tripStatus: 'waypoint',
          reached_30minutes: notReached,

        ),
      );
    } else {
      print("Trip details are not yet loaded. Cannot save location.");
    }
  }
//save lat long with way point in bloc completed



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






  // void sendLocationToServer(double latitude, double longitude) async {
  //   print("Vehicle Number sendLocationToServer  : $Testvehinum, Trip Status: $Testtripstatus");
  //
  //   try {
  //     // Reverse geocode coordinates to get address
  //     String address = '';
  //     print("addddddddddddddddddd");
  //     try {
  //       print("➡ Starting reverse geocoding for coordinates: $latitude, $longitude");
  //
  //       List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(latitude, longitude);
  //
  //       print("✅ placemarkFromCoordinates call succeeded.");
  //
  //       if (placemarks.isNotEmpty) {
  //         print("✅ Received non-empty placemarks list.");
  //
  //         final placemark = placemarks.first;
  //         print("ℹ First Placemark: ${placemark.toJson()}"); // You can log all fields if needed
  //
  //         address = "${placemark.street},${placemark.thoroughfare},${placemark.subLocality}, ${placemark.locality},${placemark.postalCode}, ${placemark.administrativeArea}, ${placemark.country}";
  //         print("📍 Constructed Address: $address");
  //       } else {
  //         print("⚠ placemarks list is empty.");
  //       }
  //     } catch (geoError) {
  //       print("❌ Reverse geocoding failed with error: $geoError");
  //       address = "Unknown address";
  //     }
  //
  //     final response = await ApiService.addVehicleLocation(
  //       vehicleno: Testvehinum ?? '',
  //       latitudeloc: latitude,
  //       longitutdeloc: longitude,
  //       tripId: widget.tripId,
  //       runingDate: Testtripstatus ?? '',
  //       runingTime: DateTime.now().toIso8601String(),
  //       tripStatus: DateTime.now().toIso8601String(),
  //       tripStartTime: DateTime.now().toIso8601String(),
  //       tripEndTime: DateTime.now().toIso8601String(),
  //       createdAt: DateTime.now().toIso8601String(),
  //       gpsPointAddrress: address,
  //     );
  //
  //     final data = jsonDecode(response.body);
  //     print("Server Response: ${data['message']}");
  //   } catch (e) {
  //     print("Error sending location: $e");
  //   }
  // }



  // @override
  // void dispose() {
  //   // _locationSubscription!.cancel();
  //   _locationSubscription?.cancel();
  //   _locationSubscription = null;// Remove reference
  //
  //   _timer?.cancel(); // Cancel timer when widget is removed
  //   _positionStreamSubscription?.cancel();
  //   super.dispose();
  // }
  @override
  void dispose() {
    // Dispose OTP controllers and focus nodes
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }

    _saveOkayTimer?.cancel();

    // Cancel location subscriptions
    _locationSubscription?.cancel();
    _locationSubscription = null;
    _otpResendTimer.cancel();

    // Cancel other timers/streams
    _timer?.cancel();
    _positionStreamSubscription?.cancel();

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


      // Navigator.push(context, MaterialPageRoute(builder: (context)=>Signatureendride(tripId: widget.tripId)));


      print('for current location');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location not available yet!")),
      );
      showWarningSnackBar(context, "Location not available yet!");
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout Confirmation"),
          content: const Text("Do you really want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: ()  {
                // clearSharedPreferences();
                context.read<AuthenticationBloc>().add(LoggedOut());

                Navigator.of(context).pop(); // Close the popup
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login_Screen()),
                );
              },
              child: const Text("Yes", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }



  String addThirtyMinutes(String tripStartTime) {
    print('in functionnn $tripStartTime');

    List<String> parts = tripStartTime.split(".");
    String cleanedTime = tripStartTime;

    if (parts.length == 2 && parts[1].length > 3) {
      cleanedTime = "${parts[0]}.${parts[1].substring(0, 3)}"; // Only 3 ms digits
    }

    try {
      DateTime parsedTime = DateFormat("HH:mm:ss.SSS").parse(cleanedTime);

      final now = DateTime.now();
      DateTime fullTime = DateTime(
        now.year,
        now.month,
        now.day,
        parsedTime.hour,
        parsedTime.minute,
        parsedTime.second,
        parsedTime.millisecond,
      );

      DateTime updatedTimeD = fullTime.add(Duration(minutes: 10));
      print('inside functionnnn ${DateFormat("HH:mm:ss.SSS").format(updatedTimeD)}');

      return DateFormat("HH:mm:ss.SSS").format(updatedTimeD);
    } catch (e) {
      print("❌ Error parsing time: $e");
      return tripStartTime;
    }
  }



  @override
  Widget build(BuildContext context) {
    // String dropLocation = globals.dropLocation; // Access the global variable
    bool isConnected = Provider.of<NetworkManager>(context).isConnected;
    globals.savedTripDistance = _totalDistance;

    return MultiBlocListener(
        listeners: [
          BlocListener<TripTrackingDetailsBloc, TripTrackingDetailsState>(
            listener: (context, state) async {
              if (state is TripTrackingDetailsLoaded) {
                setState(() {
                  vehicleNumber = state.vehicleNumber;
                  tripStatus = state.status;
                });
                SharedPreferences pref = await SharedPreferences.getInstance();

                await pref.remove("updated_start_time");

                print('i triggered for okay message inside of bloc listener');
                context.read<GetOkayBloc>().add(FetchOkaymessage(trip_id: widget.tripId));

                print("Trip details loaded. Vehicle: $vehicleNumber, Status: $tripStatus");

                // Ensure trip details are set before calling saveLocation
                if (vehicleNumber.isNotEmpty && tripStatus.isNotEmpty && tripStatus == 'On_Going') {
                  saveLocationCustomer(0.0 , 0.0); // Example coordinates
                } else {
                  print("Trip details are still empty after setting state.");
                }
              } else if (state is SaveLocationSuccess) {
                SharedPreferences pref = await SharedPreferences.getInstance();


                print('i triggered for okay message inside of bloc listener');
                context.read<GetOkayBloc>().add(FetchOkaymessage(trip_id: widget.tripId));


                print("inside the success function");
              } else if (state is SaveLocationFailure) {

                showFailureSnackBar(context, state.errorMessage);
              }
            },
          ),


          BlocListener<OtpBloc, OTPState>(listener: (context, state) {
            if (state is OTPSuccess) {
              otp = state.otp;
              print("otp received in customerlocationreached ${state.otp}");
            } else if (state is OTPFailed) {
              showFailureSnackBar(context, state.error);
            }
          }),
          BlocListener<LoginViaBloc, LoginViaState>(
              listener: (context, state){
                if(state is LoginViaSuccess){
                  setState(() {
                    otp = state.otp;
                    print('resend otp received in customerlocationreached ${otp}');
                  });
                }
              }),



          BlocListener<GetOkayBloc, GetOkayState>(
              listener: (context, state)  async{
                if(state is GetOkaySuccess){
                  setState(() {
                    TripStartTime = state.data;
                    print('frontend received tripstarttime ${TripStartTime}');  // 15:12:21.527

                    updatedTimeJust = addThirtyMinutes(TripStartTime!); //15:42:21.527

                  });

                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString('updated_start_time', updatedTimeJust);  //15:42:21.527 post
                  print("updatedTime datatype ${updatedTimeJust.runtimeType}");
                  GetupdatedTime = await prefs.getString('updated_start_time'); //15:42:21.527 get

                  print('Get Updated data from local storage ${GetupdatedTime}');
                }
              })
        ],

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
                        "Distance Traveled: ${_totalDistance.toStringAsFixed(2)} km \n"
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

                            SizedBox(height: 16),

                            // SizedBox(height: 10.0,),

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
                                            // Text(
                                            //   'Current status: $tripStatus',
                                            //   style: TextStyle(
                                            //     color: Colors.grey.shade800,
                                            //     fontSize: 20.0,
                                            //   ),
                                            // ),

                                          ],
                                        ),
                                      ),

                                      SizedBox(width: 30.0,),

                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 15),
                            if(hideButton)...[

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(4, (index) {
                                return SizedBox(
                                  width: 35,
                                  child: TextField(
                                    controller: otpControllers[index],
                                    focusNode: otpFocusNodes[index],
                                    maxLength: 1,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      counterText: '',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12), // Curved edges
                                      ),
                                    ),
                                    onChanged: (value) {
                                      if (value.isNotEmpty && index < 3) {
                                        FocusScope.of(context).requestFocus(otpFocusNodes[index + 1]);
                                      } else if (value.isEmpty && index > 0) {
                                        FocusScope.of(context).requestFocus(otpFocusNodes[index - 1]);
                                      }
                                    },
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (!_showOtpResendButton)
                                  Text(
                                    ' Resend otp will be available after   ${(_otpTimerCount ~/ 60).toString().padLeft(2, '0')}:${(_otpTimerCount % 60).toString().padLeft(2, '0')}',
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                if (_showOtpResendButton)
                                  TextButton(
                                    onPressed: () {
                                      BlocProvider.of<LoginViaBloc>(context).add(LoginViaOtpverificationRequested(phone: guestMobileNo!));
                                      setState(() {
                                        _showOtpResendButton = false;
                                        _otpTimerCount = 300;
                                      });
                                      startOtpResendTimer();
                                      // Call your OTP resend API here
                                    },
                                    child: Text(
                                      'Resend OTP',
                                      style: TextStyle(fontSize: 14, color: Colors.red),
                                    ),
                                  ),
                              ],
                            ),


                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (!isOtpComplete()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Please fill all OTP fields")),
                                    );
                                    return;
                                  }
                                  if (isOtpValid()) {
                                    setState(() {
                                      showCheckmark = true;
                                      hideButton = false;
                                    });
                                    showSuccessSnackBar(context, 'OTP Verified ✅');
                                  } else {
                                    showFailureSnackBar(context, 'Invalid OTP ❌');
                                  }
                                  // _showEndRideConfirmationDialog(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Verify',
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                ),
                              ),
                            ),

                          ],

                          SizedBox(height: 10,),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                              showCheckmark ?
                                  () {
                                _showEndRideConfirmationDialog(context);
                              }
                                  : null
                              ,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'End Ride',
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
              ),

            )
        )
    );

  }




}
