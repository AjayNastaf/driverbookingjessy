import 'package:jessy_cabs/Screens/SignatureEndRide/SignatureEndRide.dart';
import 'package:jessy_cabs/Screens/TripDetailsUpload/TripDetailsUpload.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:jessy_cabs/GlobalVariable/global_variable.dart' as globals;
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jessy_cabs/Networks/Api_Service.dart';
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
  bool isOtpVerified = false;
  bool isStartRideEnabled = false;
  String? latitude;
  String? longitude;
  bool isRideStopped = false; // Initially, show "Stop Ride" button
  bool isEndRideClicked = false; // Initially, show "Stop Ride" button
  bool isStartWayPointClicked = false;
  bool isCloseWayPointClicked = false;
  String? vehiclevalue;
  String? Statusvalue;
  // StreamSubscription<LocationData>? _locationSubscription; // Store the subscription
  String vehicleNumber = "";
  String tripStatus = "";

  @override
  void initState() {
    super.initState();
    _initializeCustomerLocationTracking();
    // _loadTripDetailsCustomer();
    // _getLatLngFromAddress(globals.dropLocation);
    // _locationSubscription?.cancel(); // ✅ Safe way to cancel without crashing
    // _locationSubscription = null;
    context.read<TripTrackingDetailsBloc>().add(
        FetchTripTrackingDetails(widget.tripId));
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
    print("Savinggg location: Latitude = $latitude, Longitude = $longitude"); // Debugging print

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
    print("hhhh: $Statusvalue");

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
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Error occurred")),
      // );
      showFailureSnackBar(context, "Error occurred");
    }
  }



  // void _updateCustomerCurrentLocation(LocationData locationData) {
  //   if (locationData.latitude != null && locationData.longitude != null) {
  //     print("Received Location: ${locationData.latitude}, ${locationData.longitude}");
  //
  //     final newLatLng = LatLng(locationData.latitude!, locationData.longitude!);
  //
  //     setState(() {
  //       _currentLatLng = newLatLng;
  //     });
  //
  //     _fetchRouteCustomer();
  //     _updateCustomerCameraPosition();
  //     // _saveLocationToDatabaseCustomer(locationData.latitude!, locationData.longitude!);
  //     _saveLocationToDatabaseCustomer(locationData.latitude!, locationData.longitude!);
  //
  //   } else {
  //     print("Location data is null");
  //   }
  // }

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
      // _saveLocationToDatabaseCustomer(locationData.latitude!, locationData.longitude!);


      // Check if location is (0.0, 0.0) – if so, do nothing
      if (latitude == 0.0 && longitude == 0.0) {
        print("⚠ Invalid location (0.0, 0.0), skipping saveLocation.");
        return; // Stop execution here
      }

      if (isRideStopped == true) {
        print("Successsss Ajay");
        print("object");
        saveWayPointLocationCustomer(latitude, longitude);
        return;
      }

      if (isEndRideClicked == true) {
        print(" Ajay ERT");
        print("object");
        _handleEndRide(latitude, longitude);
        return;
      }

      if (isStartWayPointClicked == true) {
        print(" Ajay ERT");
        print("object");
        _handleEndRide(latitude, longitude);
        return;
      }
      if (isCloseWayPointClicked == true) {
        print(" Ajay ERT");
        print("object");
        _handleEndRide(latitude, longitude);
        return;
      }

      // Ensure vehicleNumber and tripStatus are available before calling saveLocation
      if (vehicleNumber.isNotEmpty && tripStatus.isNotEmpty) {
        saveLocationCustomer(latitude, longitude);
      } else {
        print("⚠ Trip details not loaded yet, waiting...");
      }
    } else {
      print("⚠ Location data is null, skipping update");
    }
  }




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
          tripStatus: tripStatus,
          reached_30minutes: "null",

        ),
      );
    } else {
      print("Trip details are not yet loaded. Cannot save location.");
    }
  }


  //reached status in bloc
  void _handleEndRide1(double latitude, double longitude) {
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

  void saveWayPointLocationCustomer(double latitude, double longitude) {
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
          reached_30minutes: 'null',
        ),
      );
    } else {
      print("Trip details are not yet loaded. Cannot save location.");
    }
  }


//for reached status starts
  Future<void> _handleReachedTrip(double latitude, double longitude) async {
    print(
        "ssSaving start location: Latitude = $latitude, Longitude = $longitude"); // Debugging print
    if (latitude == 0.0 && longitude == 0.0) {
      print("⚠ Invalidd location (0.0, 0.0) - Not saving to database.");
      return; // Stop execution
    }

    bool success = await ApiService.insertStartData( // ✅ Now called statically
      vehicleNo: vehicleNumber,
      tripId: widget.tripId ?? '',
      latitude: latitude,
      longitude: longitude,
      runningDate: DateTime.now().toIso8601String().split("T")[0],
      // Current Date,
      runningTime: DateTime.now().toLocal().toString().split(" ")[1],
      tripStatus: "Reached",
      tripStartTime: DateTime.now().toLocal().toString().split(" ")[1],
      tripEndTime: DateTime.now().toIso8601String(),


    );



    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TripDetailsUpload(tripId: widget.tripId),
        ),
      );
    }
  }
//for reached status completed

  //for waypoint start status starts
  Future<void> _handleWaypointStartingStatus(double latitude, double longitude) async {
    print(
        "ssSaving start location: Latitude = $latitude, Longitude = $longitude"); // Debugging print
    if (latitude == 0.0 && longitude == 0.0) {
      print("⚠ Invalidd location (0.0, 0.0) - Not saving to database.");
      return; // Stop execution
    }

    bool success = await ApiService.insertWayPointStatus( // ✅ Now called statically
      vehicleNo: vehicleNumber,
      tripId: widget.tripId ?? '',
      latitude: latitude,
      longitude: longitude,
      runningDate: DateTime.now().toIso8601String().split("T")[0],
      // Current Date,
      runningTime: DateTime.now().toLocal().toString().split(" ")[1],
      tripStatus: "waypoint_Start",
      tripStartTime: DateTime.now().toLocal().toString().split(" ")[1],
      tripEndTime: DateTime.now().toIso8601String(),


    );

    if (success) {

      showSuccessSnackBar(context, "waypoint Started");
    }
  }

  void _handleWaypointStartingStatusB(double latitude, double longitude)  {
    print(
        "ssSaving start location: Latitude = $latitude, Longitude = $longitude"); // Debugging print
    if (latitude == 0.0 && longitude == 0.0) {
      print("⚠ Invalidd location (0.0, 0.0) - Not saving to database.");
      return; // Stop execution
    }
    context.read<TripTrackingDetailsBloc>().add(
      StartWayPointEvent(
        latitude: latitude,
        longitude: longitude,
        vehicleNo: vehicleNumber,
        tripId: widget.tripId,
        tripStatus: tripStatus,
      ),

    );
  }


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
//for waypoint start status


  //for waypoint completed status starts
  Future<void> _handleWaypointCompletedStatus(double latitude, double longitude) async {
    print(
        "ssSaving start location: Latitude = $latitude, Longitude = $longitude"); // Debugging print
    if (latitude == 0.0 && longitude == 0.0) {
      print("⚠ Invalidd location (0.0, 0.0) - Not saving to database.");
      return; // Stop execution
    }

    bool success = await ApiService.insertWayPointStatus( // ✅ Now called statically
      vehicleNo: vehicleNumber,
      tripId: widget.tripId ?? '',
      latitude: latitude,
      longitude: longitude,
      runningDate: DateTime.now().toIso8601String().split("T")[0],
      // Current Date,
      runningTime: DateTime.now().toLocal().toString().split(" ")[1],
      tripStatus: "waypoint_end",
      tripStartTime: DateTime.now().toLocal().toString().split(" ")[1],
      tripEndTime: DateTime.now().toIso8601String(),


    );


    if (success) {

      showSuccessSnackBar(context, "waypoint  Ended");
    }
  }


  void _handleWaypointCompletedStatusB(double latitude, double longitude)  {
    print(
        "ssSaving start location: Latitude = $latitude, Longitude = $longitude"); // Debugging print
    if (latitude == 0.0 && longitude == 0.0) {
      print("⚠ Invalidd location (0.0, 0.0) - Not saving to database.");
      return; // Stop execution
    }
    context.read<TripTrackingDetailsBloc>().add(
      EndWayPointEvent(
        latitude: latitude,
        longitude: longitude,
        vehicleNo: vehicleNumber,
        tripId: widget.tripId,
        tripStatus: tripStatus,
      ),

    );
  }
  // void _handleTripStatusReached(BuildContext context, double latitude, double longitude) {
  //   context.read<TripStatusReachedBloc>().add(
  //     TripStatusReachedRequested(
  //       latitude: latitude,
  //       longitude: longitude,
  //       vehicleNumber: vehicleNumber,
  //       tripId: widget.tripId,
  //     ),
  //   );
  //
  // }



//for waypoint completed statuscompleted



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
    // _locationSubscription?.cancel(); // Stop tracking when widget is removed
    _locationSubscription!.cancel();
    _locationSubscription = null;// Remove reference
    super.dispose();
  }
//for saving reached
  Future<bool> _checkIfStatusReached(String tripId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/Vehilcereachedstatus/$tripId'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> result = jsonDecode(response.body);
        print("API Responsessssssssssss: $result");

        return result.isNotEmpty; // True if status already exists
      } else {
        print("Failed to fetch status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error fetching status: $e");
      return false;
    }
  }

//for saving reached end



  @override
  Widget build(BuildContext context) {
    String dropLocation = globals.dropLocation; // Access the global variable

    return

      BlocListener<TripTrackingDetailsBloc, TripTrackingDetailsState>(
        listener: (context, state) {
          if (state is TripTrackingDetailsLoaded) {
            setState(() {
              vehicleNumber = state.vehicleNumber;
              tripStatus = state.status;
            });

            print("Trip details loaded. Vehicle: $vehicleNumber, Status: $tripStatus");

            // Ensure trip details are set before calling saveLocation
            if (vehicleNumber.isNotEmpty && tripStatus.isNotEmpty) {
              saveLocationCustomer(0.0 , 0.0); // Example coordinates
            } else {
              print("Trip details are still empty after setting state.");
            }
          } else if (state is SaveLocationSuccess) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text("Location saved successfully!")),
            // );
            print("inside the success function");
          } else if (state is SaveLocationFailure) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text(state.errorMessage)),
            // );
            showFailureSnackBar(context, state.errorMessage);
          }
        },
        child:Scaffold (
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
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen
                      // BitmapDescriptor.hueBlue

                  ),

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
                              // Statusvalue = "waypoint"; // Set Trip_Status to "waypoint"
                            });

                            isStartWayPointClicked = true; // Set flag to true when button is clicked


                            Future.delayed(Duration(seconds: 1), () {
                              isStartWayPointClicked = false;
                              print("🔄 End Ride button reset, can be clicked again.");
                            });




                            // Call the function to save location with updated status
                            if (_currentLatLng != null) {
                              // _handleWaypointStartingStatus(_currentLatLng!.latitude, _currentLatLng!.longitude);
                              _handleWaypointStartingStatusB(_currentLatLng!.latitude, _currentLatLng!.longitude);

                              saveWayPointLocationCustomer(
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
                              Statusvalue = 'On_Going'; // Set Trip_Status to "waypoint"
                            });
                            isCloseWayPointClicked = true; // Set flag to true when button is clicked


                            Future.delayed(Duration(seconds: 1), () {
                              isCloseWayPointClicked = false;
                              print("🔄 End Ride button reset, can be clicked again.");
                            });


                            // Call the function to save location with updated status
                            if (_currentLatLng != null) {

                              // _handleWaypointCompletedStatus(
                              // _currentLatLng!.latitude,
                              // _currentLatLng!.longitude,
                              // );

                              _handleWaypointCompletedStatusB(
                              _currentLatLng!.latitude,
                              _currentLatLng!.longitude,
                              );

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
                      child:
                      // ElevatedButton(
                      //   // onPressed: () {
                      //   //   // Navigator.push(context, MaterialPageRoute(builder: (context)=>Signatureendride()));
                      //   //   Navigator.push(context, MaterialPageRoute(builder: (context)=>TripDetailsUpload(tripId: widget.tripId,)));
                      //   // },
                      //   onPressed: () {
                      //     setState(() {
                      //       Statusvalue = 'Reached'; // Set Trip_Status to "waypoint"
                      //     });
                      //
                      //     // Call the function to save location with updated status
                      //     if (_currentLatLng != null) {
                      //       _saveLocationToDatabaseCustomer(
                      //         _currentLatLng!.latitude,
                      //         _currentLatLng!.longitude,
                      //       );
                      //       // _locationSubscription?.cancel();
                      //
                      //     } else {
                      //       print("Error: _currentLatLng is null");
                      //     }
                      //     // _locationSubscription?.cancel();
                      //
                      //     Navigator.push(context, MaterialPageRoute(builder: (context)=>TripDetailsUpload(tripId: widget.tripId,)));
                      //     // _locationSubscription?.cancel();
                      //
                      //   },
                      //
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Colors.red,
                      //     padding: EdgeInsets.symmetric(vertical: 16),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //   ),
                      //   child: Text(
                      //      'End Ride',
                      //     style: TextStyle(fontSize: 20.0, color: Colors.white),
                      //   ),
                      // ),

                      // ElevatedButton(
                      //   onPressed: () async {
                      //     bool isStatusAlreadyReached = await _checkIfStatusReached(widget.tripId);
                      //
                      //     if (!isStatusAlreadyReached) {
                      //       setState(() {
                      //         Statusvalue = 'Reached';
                      //       });
                      //       // If status is NOT "Reached", update it
                      //       if (_currentLatLng != null) {
                      //         await _saveLocationToDatabaseCustomer(
                      //           _currentLatLng!.latitude,
                      //           _currentLatLng!.longitude,
                      //           // Statusvalue, // Pass status explicitly
                      //
                      //         );
                      //         print("Trip status updated to 'Reached'.");
                      //       } else {
                      //         print("Error: _currentLatLng is null");
                      //       }
                      //     } else {
                      //       print("Trip status is already 'Reached'. Navigating only.");
                      //     }
                      //
                      //     // Navigate to TripDetailsUpload
                      //     if (mounted) {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => TripDetailsUpload(tripId: widget.tripId),
                      //         ),
                      //       );
                      //     }
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Colors.red,
                      //     padding: EdgeInsets.symmetric(vertical: 16),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //   ),
                      //   child: Text(
                      //     'End Ride',
                      //     style: TextStyle(fontSize: 20.0, color: Colors.white),
                      //   ),
                      // ),
                      ElevatedButton(
                        // onPressed: () async {
                        //   bool isStatusAlreadyReached = await _checkIfStatusReached(widget.tripId);
                        //
                        //   if (!isStatusAlreadyReached) {
                        //     setState(() {
                        //       Statusvalue = 'Reached';
                        //     });
                        //
                        //     if (_currentLatLng != null) {
                        //       await _saveLocationToDatabaseCustomer(
                        //         _currentLatLng!.latitude,
                        //         _currentLatLng!.longitude,
                        //       );
                        //     } else {
                        //       print("Error: _currentLatLng is null");
                        //     }
                        //     print("Trip status is alreadyyy.");
                        //
                        //   } else {
                        //     print("Trip status is already 'Reached'. Navigating only.");
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => TripDetailsUpload(tripId: widget.tripId),
                        //       ),
                        //     );
                        //   }
                        //
                        //   if (mounted) {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => TripDetailsUpload(tripId: widget.tripId),
                        //       ),
                        //     );
                        //   }
                        // },



//                         onPressed: () {
//                           setState(() {
//                             Statusvalue = 'Reached'; // Update Trip_Status in state
//                           });
// print('Ajay status" $Statusvalue');
//                           Future.delayed(Duration(milliseconds: 100), () {
//                             print('Ajay status2" $Statusvalue');
//
//                             if (_currentLatLng != null) {
//                               saveLocationCustomer(
//                                 _currentLatLng!.latitude,
//                                 _currentLatLng!.longitude,
//                               );
// print("in side");
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => TripDetailsUpload(tripId: widget.tripId),
//                                 ),
//                               );
//                             } else {
//                               print("⚠ Erroor: _currentLatLng is null");
//                             }
//                           });
//                         },




                        // onPressed: () {
                        //   if (_currentLatLng != null) {
                        //     _handleReachedTrip(_currentLatLng!.latitude, _currentLatLng!.longitude);
                        //
                        //   } else {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(content: Text("llLocation not available yet!")),
                        //     );
                        //     showWarningSnackBar(context, "Location not available yet!");
                        //   }
                        // },

                        onPressed: () {
                          print('for current ');
                          isEndRideClicked = true; // Set flag to true when button is clicked

                          setState(() {
                            // isEndRideClicked = true; // Set flag to true when button is clicked
                            // Statusvalue = "waypoint"; // Set Trip_Status to "waypoint"
                          });
                          Future.delayed(Duration(seconds: 1), () {
                            isEndRideClicked = false;
                            print("🔄 End Ride button reset, can be clicked again.");
                          });
                          if (_currentLatLng != null) {

                            // _handleEndRide(double latitude, double longitude);
                            _handleEndRide(_currentLatLng!.latitude, _currentLatLng!.longitude);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TripDetailsUpload(tripId: widget.tripId),
                              ),
                            );
                            print('for current location');



                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("llLocation not available yet!")),
                              );
                              showWarningSnackBar(context, "Location not available yet!");
                            }


                          // double latitude = _currentLatLng!.latitude; // Replace with actual latitude value
                          // double longitude = _currentLatLng!.longitude; // Replace with actual longitude value

                          // context.read<TripTrackingDetailsBloc>().add(
                          //   EndRideEvent(
                          //     latitude: latitude,
                          //     longitude: longitude,
                          //     vehicleNo: vehicleNumber,
                          //     tripId: widget.tripId ?? '',
                          //   ),
                          // );
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
    )

    );
  }
}
