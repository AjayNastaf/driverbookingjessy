import 'package:driverbooking/Screens/CustomerLocationReached/CustomerLocationReached.dart';
import 'package:driverbooking/Utils/AllImports.dart';
import 'package:driverbooking/Utils/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:driverbooking/Screens/TrackingPage/TrackingPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:driverbooking/Bloc/App_Bloc.dart';
import 'package:driverbooking/Bloc/AppBloc_Events.dart';
import 'package:driverbooking/Bloc/AppBloc_State.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrackingPage extends StatefulWidget {
  final String address;

  const TrackingPage({Key? key, required this.address}) : super(key: key);

  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  LatLng _destination =
      LatLng(13.028159, 80.243306); // Chennai Central Railway Station
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
    for (int i = 0; i < 4; i++) {
      _otpControllers.add(TextEditingController());
    }
    _getLatLngFromAddress(widget.address);
  }

  Future<void> _getLatLngFromAddress(String address) async {
    const String apiKey = AppConstants.ApiKey; // Replace with your API Key
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey';

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
      setState(() {
        _currentLatLng = newLatLng;
      });

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

  void _clearOtpInputs() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildOtpInput(int index) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: _otpControllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            if (index < _otpControllers.length - 1) {
              FocusScope.of(context).nextFocus();
            }
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
          _checkOtpCompletion();
        },
      ),
    );
  }

  void _checkOtpCompletion() {
    setState(() {
      isStartRideEnabled =
          _otpControllers.every((controller) => controller.text.isNotEmpty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomerOtpVerifyBloc(),
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
        body: BlocListener<CustomerOtpVerifyBloc, CustomerOtpVerifyState>(
          listener: (context, state) {
            if (state is OtpVerifyCompleted) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text("OTP Verified Successfully!")),
              // );
              setState(() {
                isOtpVerified = true; // Mark OTP as verified
              });
              showSuccessSnackBar(context, "OTP Verified Successfully!");
            } else if (state is OtpVerifyFailed) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Customerlocationreached(),
                ),
              );

              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text(state.error)),
              // );
              showFailureSnackBar(context, '${state.error}');
              _clearOtpInputs();
            }
          },
          child: BlocBuilder<CustomerOtpVerifyBloc, CustomerOtpVerifyState>(
            builder: (context, state) {
              // if (state is OtpVerifyLoading) {
              //   return Center(child: CircularProgressIndicator());
              // }
              return Stack(
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
                              BitmapDescriptor.hueBlue),
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
                        height: 300, // Adjust height as needed
                        padding: EdgeInsets.all(16),
                        color: Colors.white, // Semi-transparent background
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 30.0),
                            Text(
                              'Enter Customer OTP',
                              style: TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildOtpInput(0),
                                _buildOtpInput(1),
                                _buildOtpInput(2),
                                _buildOtpInput(3),
                              ],
                            ),
                            SizedBox(height: 40),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (isOtpVerified) {
                                    // Navigate to the next screen when "Start Ride" is clicked
                                    _clearOtpInputs();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Customerlocationreached(),
                                      ),
                                    );
                                  } else {
                                    // Verify OTP when "Verify OTP" is clicked
                                    final String otp = _otpControllers
                                        .map((controller) => controller.text)
                                        .join();
                                    context
                                        .read<CustomerOtpVerifyBloc>()
                                        .add(OtpVerifyAttempt(otp: otp));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.Navblue1,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  isOtpVerified ? 'Start Ride' : 'Verify OTP',
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
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
