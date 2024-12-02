import 'package:driverbooking/Screens/CustomerLocationReached/CustomerLocationReached.dart';
import 'package:driverbooking/Screens/TrackingPage/TrackingPage.dart';
import 'package:flutter/material.dart';
import 'package:driverbooking/Networks/Api_Service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:driverbooking/Utils/AllImports.dart';
import 'package:driverbooking/Screens/BookingDetails/BookingDetails.dart';
class Pickupscreen extends StatefulWidget {
  final String address;
  const Pickupscreen({Key?key, required this.address}):super(key: key);

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
              // child: Column(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //
              //   children: [
              //     // Wrap the Column with Flexible
              //
              //
              //     SizedBox(height: 10.0), // Add some space between the Column and Button
              //
              //     Row(
              //       children: [
              //         Icon(Icons.person, size: 26.0, color: Colors.grey), // User icon
              //         SizedBox(width: 8.0), // Space between icon and text
              //         Text(
              //           'Ajay',
              //           style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w500),
              //         ),
              //       ],
              //     ),
              //
              //     Row(
              //       children: [
              //         Icon(Icons.person_pin_circle, size: 20.0, color: Colors.red), // User icon
              //         SizedBox(width: 8.0), // Space between icon and text
              //         Text(
              //           'Thiruvalluvar Puram, West Tambaram, Chennai',
              //           style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
              //           overflow: TextOverflow.ellipsis, // Prevent overflow
              //           maxLines: 1, // Limit to one line
              //         ),
              //       ],
              //     ),
              //
              //
              //     SizedBox(height: 10.0), // Add some space between the Column and Button
              //     Center(
              //       child: ElevatedButton(
              //         onPressed: () {
              //           // Add your button action here
              //           Navigator.push(context,
              //               MaterialPageRoute(builder: (context)=>TrackingPage()));
              //         },
              //         child: Text('Go to the Location',style: TextStyle(fontSize: 18.0),),
              //         style: ElevatedButton.styleFrom(
              //           padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 12.0),
              //         ),
              //
              //       ),
              //     ),
              //   ],
              // ),
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
                        // Add your button action here
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TrackingPage(address: widget.address)));
                      },
                      child: Text(
                        'Go to the Location',
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

        ],
      ),
    );

  }
}
