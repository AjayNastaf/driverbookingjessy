import 'package:driverbooking/Screens/TrackingPage/TrackingPage.dart';
import 'package:flutter/material.dart';
import 'package:driverbooking/Networks/Api_Service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:driverbooking/Utils/AllImports.dart';
class Pickupscreen extends StatefulWidget {
  const Pickupscreen({super.key});

  @override
  State<Pickupscreen> createState() => _PickupscreenState();
}

class _PickupscreenState extends State<Pickupscreen> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    final LatLng _initialPosition = LatLng(13.082680, 80.270721); // Replace with desired coordinates (e.g., Bengaluru, India)


    @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Pickup"),
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: (controller) {
              // You can save the controller for further use if needed
            },
            initialCameraPosition: CameraPosition(
              target: _initialPosition, // Fixed location
              zoom: 15, // Adjust zoom level as required
            ),
            myLocationEnabled: false, // Disable 'my location' marker
            myLocationButtonEnabled: false, // Disable 'my location' button
          ),
          // Bottom Section
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              // padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 38.0),
              padding: EdgeInsets.only(top: 16.0, bottom: 38.0, left: 10.0,right: 10.0),

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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // Wrap the Column with Flexible


                        Text(
                          'Ajay',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Thiruvalluvar Puram, West Tambaram, Chennai',
                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis, // Prevent overflow
                          maxLines: 1, // Limit to one line
                        ),

                  SizedBox(height: 10.0), // Add some space between the Column and Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your button action here
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>TrackingPage()));
                      },
                      child: Text('Go to the Location'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );

  }
}
