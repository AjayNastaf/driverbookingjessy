import 'dart:async';
import 'dart:math';
import 'package:jessy_cabs/Screens/PickUpWithoutHcl/AnimatedCabHeader.dart';
import 'package:jessy_cabs/Screens/StartingKilometer/StartingKilometer.dart';
import 'package:flutter/material.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../NoInternetBanner/NoInternetBanner.dart';
import 'package:provider/provider.dart';
import '../network_manager.dart';

import 'package:google_fonts/google_fonts.dart';


class PickUpWithoutHcl extends StatefulWidget {
  final String address;
  final String tripId;

  const PickUpWithoutHcl({Key?key, required this.address, required this.tripId}):super(key: key);

  @override
  State<PickUpWithoutHcl> createState() => _PickUpWithoutHclState();
}

class _PickUpWithoutHclState extends State<PickUpWithoutHcl> with TickerProviderStateMixin   {
  late AnimationController _textController;
  late Animation<double> _textOpacity;

  void initState() {
    super.initState();
    saveScreenData();


    // Text animation for pulsating effect
    _textController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _textOpacity = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    _textController.repeat(reverse: true);  // Start the text animation



  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> saveScreenData() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('last_screen', 'PickupscreenwithoutHcl');

    await prefs.setString('trip_id', widget.tripId);

    await prefs.setString('address', widget.address);





    print('Saved screen data:');

    print('last_screen: PickupscreenwithoutHcl');

    print('trip_id: ${widget.tripId}');

    print('address: ${widget.address}');



  }


  @override
  Widget build(BuildContext context) {
    bool isConnected = Provider.of<NetworkManager>(context).isConnected;

    return  Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pick Up",
          style: TextStyle(color: Colors.white, fontSize: AppTheme.appBarFontSize),
        ),
        automaticallyImplyLeading: false, // 👈 disables the default back icon

        backgroundColor: AppTheme.Navblue1,
      ),
      // body: Stack(
      //   children: [
      //     Column(
      //       children: [
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //         SizedBox(height: 10.0,),
      //
      //         Row(
      //           children: [
      //
      //             Column(
      //               children: [
      //                 Icon(Icons.person_pin_circle, color: Colors.green, size: 30),
      //                 Container(
      //                   width: 2,
      //                   height: 30,
      //                   color: Colors.grey.shade400,
      //                 ),
      //                 Icon(Icons.location_on, color: Colors.red, size: 30),
      //               ],
      //             ),
      //             SizedBox(width: 12), // Space between icon and address
      //             Expanded(
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                     'Current Location',
      //                     style: TextStyle(color: Colors.grey.shade800, fontSize: 17, fontWeight: FontWeight.w500),
      //                   ),
      //                   SizedBox(height: 40),
      //                   Text(
      //                     ' qqqqqqqqqqqqqqq',
      //                     style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //         SizedBox(height: 30.0,),
      //         Center(
      //           child: ElevatedButton(
      //             onPressed: () {
      //               // Add your button action here StartingKilometer
      //               // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => TrackingPage(address: widget.address, tripId: widget.tripId,)), (route) => false,);
      //               Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => StartingKilometer(tripId: widget.tripId, address: widget.address)), (route) => false,);
      //
      //
      //             },
      //             child: Text(
      //               'Reached',
      //               style: TextStyle(
      //                 fontSize: 18.0,
      //                 color: Colors.white, // Text color
      //               ),
      //             ),
      //             style: ElevatedButton.styleFrom(
      //               backgroundColor: Colors.green, // Background color
      //               padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 12.0), // Button padding
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(8.0), // Border radius
      //               ),
      //             ),
      //           ),
      //         )
      //
      //       ],
      //     ),
      //
      //
      //     Positioned(
      //       top: 15,
      //       left: 0,
      //       right: 0,
      //       child: NoInternetBanner(isConnected: isConnected),
      //     ),
      //   ],
      // ),

       body: AnimatedCabHeader(),

      bottomNavigationBar: BottomAppBar(
        height: 220.0,
        elevation: 8.0,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Address Information
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
                  const SizedBox(width: 12), // Space between icon and address
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Location',
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 45),
                        Text(
                          '${widget.address}',
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),

              // Reached Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to StartingKilometer page
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StartingKilometer(
                          tripId: widget.tripId,
                          address: widget.address,
                        ),
                      ),
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Button color
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60.0,
                      vertical: 12.0,
                    ), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    'Reached',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white, // Text color
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );



  }
}

