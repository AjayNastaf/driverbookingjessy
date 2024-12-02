import 'package:driverbooking/Screens/SignatureEndRide/SignatureEndRide.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:math' as math;
import 'package:dio/dio.dart';

class Customerlocationreached extends StatefulWidget {
  const Customerlocationreached({super.key});

  @override
  State<Customerlocationreached> createState() => _CustomerlocationreachedState();
}

class _CustomerlocationreachedState extends State<Customerlocationreached> {

  GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  // final LatLng _destination = LatLng(13.030037, 80.240037); // Chennai Central Railway Station
  final LatLng _destination = LatLng(13.028159, 80.243306); // Chennai Central Railway Station
  List<LatLng> _routeCoordinates = [];
  Stream<LocationData>? _locationStream;
  bool _hasReachedDestination = false;
  @override
  void initState() {
    super.initState();
    _initializeLocationTracking();

  }

  Future<void> _initializeLocationTracking() async {
    Location location = Location();

    // Check for location permissions
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

    // Fetch the initial location
    final initialLocation = await location.getLocation();
    _updateCurrentLocation(initialLocation);

    // Listen to location changes
    _locationStream = location.onLocationChanged;
    _locationStream!.listen((newLocation) {
      _updateCurrentLocation(newLocation);
    });
  }

  List<double> _recentDistances = [];

  void _updateCurrentLocation(LocationData locationData) {
    if (locationData.latitude != null && locationData.longitude != null) {
      final newLatLng = LatLng(locationData.latitude!, locationData.longitude!);
      final distance = _calculateDistance(newLatLng, _destination);

      // Smoothing: Store the last 5 distances
      if (_recentDistances.length >= 5) _recentDistances.removeAt(0);
      _recentDistances.add(distance);

      // Check if the average of recent distances is below threshold
      if (!_hasReachedDestination &&
          _recentDistances.length == 5 &&
          _recentDistances.reduce((a, b) => a + b) / _recentDistances.length < 20) {
        setState(() {
          _hasReachedDestination = true;
        });
      }

      setState(() {
        _currentLatLng = newLatLng;
      });

      _fetchRoute();
    }
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371000; // Earth's radius in meters
    final double dLat = _degreesToRadians(end.latitude - start.latitude);
    final double dLng = _degreesToRadians(end.longitude - start.longitude);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(start.latitude)) *
            math.cos(_degreesToRadians(end.latitude)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  Future<void> _fetchRoute() async {
    if (_currentLatLng == null) return;

    const String apiKey = 'AIzaSyCp2ePjsrBdrvgYCQs1d1dTaDe5DzXNjYk'; // Replace with your API key
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
          _adjustCameraBounds();
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

  void _adjustCameraBounds() {
    if (_currentLatLng == null || _routeCoordinates.isEmpty) return;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        math.min(_currentLatLng!.latitude, _destination.latitude),
        math.min(_currentLatLng!.longitude, _destination.longitude),
      ),
      northeast: LatLng(
        math.max(_currentLatLng!.latitude, _destination.latitude),
        math.max(_currentLatLng!.longitude, _destination.longitude),
      ),
    );

    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }


  @override
  Widget build(BuildContext context) {
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
            ),
          Positioned(
            bottom: 0, // Aligns the bottom section
            left: 0,
            right: 0,
            child: IgnorePointer(
              ignoring: false, // Allows interaction with the map below
              child: Container(
                height: 100, // Adjust height as needed
                padding: EdgeInsets.all(16),
                color: Colors.white, // Semi-transparent background
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
Navigator.push(context, MaterialPageRoute(builder: (context)=>Signatureendride()));
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
