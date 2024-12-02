import 'package:driverbooking/Screens/BookingDetails/BookingDetails.dart';
import 'package:driverbooking/Screens/MenuListScreens/History/History.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:driverbooking/Screens/DestinationLocation/DestinationLocationScreen.dart';
import 'package:driverbooking/Screens/LoginScreen/Login_Screen.dart';
import 'package:driverbooking/Screens/MenuListScreens/Contacts/ContactScreen.dart';
import 'package:driverbooking/Screens/MenuListScreens/Faq/FaqScreen.dart';
import 'package:driverbooking/Screens/MenuListScreens/Notifications/NotificationScreen.dart';
import 'package:driverbooking/Screens/MenuListScreens/ReferFriends/ReferFriendScreen.dart';
import 'package:driverbooking/Screens/MenuListScreens/RideScreen/RideScreen.dart';
import 'package:driverbooking/Screens/MenuListScreens/Wallet/WalletScreen.dart';
import 'package:driverbooking/Screens/OtpScreen/OtpScreen.dart';
import 'package:driverbooking/Utils/AllImports.dart';
import 'package:driverbooking/Networks/Api_Service.dart';
import 'package:driverbooking/Screens/MenuListScreens/Profile/profile.dart';
import 'package:driverbooking/Screens/MenuListScreens/Settings/Settings.dart';

class Homescreen extends StatefulWidget {
  final String userId;

  const Homescreen({Key? key, required this.userId}) : super(key:key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String? username;
  String? password;
  String? phonenumber;
  String?email;
  late GoogleMapController _mapController;
  LatLng? _currentPosition;



  @override
  void initState() {
    super.initState();
    // _getCurrentLocation();
    _getUserDetails();
  }

  void _getUserDetails() async {
    final getUserDetailsResult = await ApiService.getUserDetailsDatabase(widget.userId);
    if (getUserDetailsResult != null) {
      setState(() {
        username = getUserDetailsResult['username'];
        password = getUserDetailsResult['password'];
        phonenumber = getUserDetailsResult['phonenumber'];
        email = getUserDetailsResult['email'];
      });
      print('emailssssssssssssssssssssssdddddd: $phonenumber');
    }
    else{
      print("Failed to retrieve user details.");
    }

  }




  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.Navblue1, // Set your green color here
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 30, // Adjust size as needed
                        backgroundImage: AssetImage(AppConstants.intro_three), // Replace with your image asset
                        backgroundColor: Colors.grey[300], // Fallback color when no image is loaded
                      ),
                      Positioned(
                        bottom: 0, // Positioning the edit icon at the bottom-right
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                    userId: widget.userId,
                                    username: '$username',
                                    password: '$password',
                                    phonenumber: '$phonenumber',
                                    email: '$email'
                                ),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 12, // Adjust size of the edit icon container
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.edit,
                              size: 16, // Icon size
                              color: Colors.green[700], // Icon color
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16), // Add spacing between avatar and text
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center align vertically
                    crossAxisAlignment: CrossAxisAlignment.start, // Align to the start
                    children: [
                      Text(
                        "$username", // Replace with the user's name
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4), // Spacing between name and email
                      Text(
                        "$email", // Replace with the user's email
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.car_repair_rounded),
              title: Text('My Rides'),
              onTap: () {
                // Navigator.push(context, ()=>)
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Ridescreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('Wallet'),
              onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Walletscreen()));
                // Navigator.pop(context);
              },
              
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                // Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Notificationscreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.group_add),
              title: Text('Invite Friends'),
              onTap: () {
                // Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ReferFriendScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text("Faq's"),
              onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>FAQScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.supervised_user_circle_rounded),
              title: Text('Contact'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Contactscreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.supervised_user_circle_rounded),
              title: Text('History'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>History()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Settings(
                    userId: widget.userId,
                    username: '$username',
                    password: '$password',
                    phonenumber: '$phonenumber',
                    email: '$email'
                )));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login_Screen()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Home Screen"),
      ),

      // body: Center(
      //   child: Card(
      //     elevation: 4.0, // Elevates the card
      //     margin: EdgeInsets.all(16.0),
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(12.0), // Rounded corners
      //     ),
      //     child: Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: Row(
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //           // Asset Image
      //           ClipRRect(
      //             borderRadius: BorderRadius.circular(8.0), // Rounded image corners
      //             child: Image.asset(
      //               AppConstants.nastafLogo, // Replace with your image path
      //               width: 60,
      //               height: 60,
      //               fit: BoxFit.cover,
      //             ),
      //           ),
      //           SizedBox(width: 16.0), // Spacing between image and text
      //
      //           // Texts
      //           Expanded(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text(
      //                   'Location Name',
      //                   style: TextStyle(
      //                     fontSize: 16.0,
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //                   overflow: TextOverflow.ellipsis, // Prevents overflow
      //                 ),
      //                 SizedBox(height: 4.0),
      //                 Text(
      //                   'Location Details go here and can be quite lengthy',
      //                   style: TextStyle(
      //                     fontSize: 14.0,
      //                     color: Colors.grey,
      //                   ),
      //                   maxLines: 1, // Limits text to one line
      //                   overflow: TextOverflow.ellipsis, // Truncates overflow
      //                 ),
      //               ],
      //             ),
      //           ),
      //
      //           // Waiting Status and Arrow Icon
      //           Column(
      //             crossAxisAlignment: CrossAxisAlignment.end,
      //             children: [
      //               Text(
      //                 'Waiting',
      //                 style: TextStyle(
      //                   fontSize: 14.0,
      //                   color: Colors.orange,
      //                   fontWeight: FontWeight.w500,
      //                 ),
      //               ),
      //               SizedBox(height: 8.0),
      //               Icon(
      //                 Icons.arrow_forward_ios,
      //                 color: Colors.grey,
      //                 size: 16.0,
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),

      // body: SingleChildScrollView(
      //   child: Column(
      //
      //     children: [
      //        Padding(
      //
      //         padding: const EdgeInsets.all(8.0),
      //         child: GestureDetector(
      //           onTap: (){
      //             Navigator.push(context, MaterialPageRoute(builder: (context)=>Bookingdetails()));
      //
      //           },
      //           child: Container(
      //
      //             decoration: BoxDecoration(
      //               color: Colors.white,
      //               border: Border.all(color: Colors.grey, width: 1.0), // Border
      //               borderRadius: BorderRadius.circular(12.0), // Rounded corners
      //             ),
      //             padding: const EdgeInsets.all(16.0), // Inner padding
      //             child: Column(
      //               children: [
      //                 Center(
      //                   child: Column(
      //                     children: [
      //                       // // Image Section
      //                       // Image.asset(
      //                       //  AppConstants.driver_waiting, // Replace with your asset path
      //                       //   height: 200.0,
      //                       //   // width: 200.0,
      //                       //   // width: double.infinity,
      //                       // ),
      //                       // SizedBox(height: 16.0), // Spacing between image and text
      //
      //                       // Row Section
      //                       Row(
      //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                         children: [
      //                           // Text Columns
      //                           Column(
      //                             crossAxisAlignment: CrossAxisAlignment.start,
      //                             children: [
      //                               Text(
      //                                 "Local",
      //                                 style: TextStyle(
      //                                   fontSize: 16.0,
      //                                   fontWeight: FontWeight.bold,
      //                                 ),
      //                               ),
      //                               SizedBox(height: 3.0),
      //                               Row(
      //                                 children: [
      //                                   Text(
      //                                     "2024-11-25",
      //                                     style: TextStyle(
      //                                       fontSize: 14.0,
      //                                       color: Colors.grey,
      //                                     ),
      //                                   ),
      //                                   SizedBox(width: 10.0,),
      //                                   Text(
      //                                     "5.39 PM",
      //                                     style: TextStyle(
      //                                       fontSize: 14.0,
      //                                       color: Colors.grey,
      //                                     ),
      //                                   ),
      //
      //                                 ],
      //                               )
      //
      //                             ],
      //                           ),
      //
      //                           // Waiting Column with Text and Icon
      //                           Column(
      //                             crossAxisAlignment: CrossAxisAlignment.center,
      //                             children: [
      //                               Container(
      //                                 decoration: BoxDecoration(
      //                                   color: Colors.orange.withOpacity(0.1),
      //                                   border: Border.all(
      //                                     color: Colors.orange,
      //                                     width: 1.0,
      //                                   ),
      //                                   borderRadius: BorderRadius.circular(8.0),
      //                                 ),
      //                                 padding: EdgeInsets.symmetric(
      //                                   horizontal: 12.0,
      //                                   vertical: 4.0,
      //                                 ),
      //                                 child: Text(
      //                                   'Waiting',
      //                                   style: TextStyle(
      //                                     fontSize: 14.0,
      //                                     color: Colors.orange,
      //                                     fontWeight: FontWeight.w500,
      //                                   ),
      //                                 ),
      //                               ),
      //                               SizedBox(height: 8.0),
      //                               Icon(
      //                                 Icons.arrow_forward_ios,
      //                                 color: Colors.grey,
      //                                 size: 16.0,
      //                               ),
      //                             ],
      //                           ),
      //                         ],
      //                       ),
      //                     ],
      //                   ),
      //                 )
      //               ],
      //             ),
      //           ),
      //
      //         ),
      //
      //
      //       ),
      //
      //       Padding(
      //
      //         padding: const EdgeInsets.all(8.0),
      //         child: GestureDetector(
      //           onTap: (){
      //             Navigator.push(context, MaterialPageRoute(builder: (context)=>Bookingdetails()));
      //
      //           },
      //           child: Container(
      //
      //             decoration: BoxDecoration(
      //               color: Colors.white,
      //               border: Border.all(color: Colors.grey, width: 1.0), // Border
      //               borderRadius: BorderRadius.circular(12.0), // Rounded corners
      //             ),
      //             padding: const EdgeInsets.all(16.0), // Inner padding
      //             child: Column(
      //               children: [
      //                 Center(
      //                   child: Column(
      //                     children: [
      //                       // Image Section
      //                       // Image.asset(
      //                       //   AppConstants.driver_waiting, // Replace with your asset path
      //                       //   height: 200.0,
      //                       //   // width: 200.0,
      //                       //   // width: double.infinity,
      //                       // ),
      //                       // SizedBox(height: 16.0), // Spacing between image and text
      //
      //                       // Row Section
      //                       Row(
      //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                         children: [
      //                           // Text Columns
      //                           Column(
      //                             crossAxisAlignment: CrossAxisAlignment.start,
      //                             children: [
      //                               Text(
      //                                 "Out Station",
      //                                 style: TextStyle(
      //                                   fontSize: 16.0,
      //                                   fontWeight: FontWeight.bold,
      //                                 ),
      //                               ),
      //                               SizedBox(height: 3.0),
      //                               Row(
      //                                 children: [
      //                                   Text(
      //                                     "2024-11-25",
      //                                     style: TextStyle(
      //                                       fontSize: 14.0,
      //                                       color: Colors.grey,
      //                                     ),
      //                                   ),
      //                                   SizedBox(width: 10.0,),
      //                                   Text(
      //                                     "5.39 PM",
      //                                     style: TextStyle(
      //                                       fontSize: 14.0,
      //                                       color: Colors.grey,
      //                                     ),
      //                                   ),
      //
      //                                 ],
      //                               )
      //
      //                             ],
      //                           ),
      //
      //                           // Waiting Column with Text and Icon
      //                           Column(
      //                             crossAxisAlignment: CrossAxisAlignment.center,
      //                             children: [
      //                               Container(
      //                                 decoration: BoxDecoration(
      //                                   color: Colors.orange.withOpacity(0.1),
      //                                   border: Border.all(
      //                                     color: Colors.orange,
      //                                     width: 1.0,
      //                                   ),
      //                                   borderRadius: BorderRadius.circular(8.0),
      //                                 ),
      //                                 padding: EdgeInsets.symmetric(
      //                                   horizontal: 12.0,
      //                                   vertical: 4.0,
      //                                 ),
      //                                 child: Text(
      //                                   'Waiting',
      //                                   style: TextStyle(
      //                                     fontSize: 14.0,
      //                                     color: Colors.orange,
      //                                     fontWeight: FontWeight.w500,
      //                                   ),
      //                                 ),
      //                               ),
      //                               SizedBox(height: 8.0),
      //                               Icon(
      //                                 Icons.arrow_forward_ios,
      //                                 color: Colors.grey,
      //                                 size: 16.0,
      //                               ),
      //                             ],
      //                           ),
      //                         ],
      //                       ),
      //                     ],
      //                   ),
      //                 )
      //               ],
      //             ),
      //           ),
      //
      //         ),
      //
      //
      //       ),
      //
      //       Padding(
      //
      //         padding: const EdgeInsets.all(8.0),
      //         child: GestureDetector(
      //           onTap: (){
      //             Navigator.push(context, MaterialPageRoute(builder: (context)=>Bookingdetails()));
      //
      //           },
      //           child: Container(
      //
      //             decoration: BoxDecoration(
      //               color: Colors.white,
      //               border: Border.all(color: Colors.grey, width: 1.0), // Border
      //               borderRadius: BorderRadius.circular(12.0), // Rounded corners
      //             ),
      //             padding: const EdgeInsets.all(16.0), // Inner padding
      //             child: Column(
      //               children: [
      //                 Center(
      //                   child: Column(
      //                     children: [
      //                       // Image Section
      //                       // Image.asset(
      //                       //   AppConstants.driver_waiting, // Replace with your asset path
      //                       //   height: 200.0,
      //                       //   // width: 200.0,
      //                       //   // width: double.infinity,
      //                       // ),
      //                       // SizedBox(height: 16.0), // Spacing between image and text
      //
      //                       // Row Section
      //                       Row(
      //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                         children: [
      //                           // Text Columns
      //                           Column(
      //                             crossAxisAlignment: CrossAxisAlignment.start,
      //                             children: [
      //                               Text(
      //                                 "Transfer",
      //                                 style: TextStyle(
      //                                   fontSize: 16.0,
      //                                   fontWeight: FontWeight.bold,
      //                                 ),
      //                               ),
      //                               SizedBox(height: 3.0),
      //                               Row(
      //                                 children: [
      //                                   Text(
      //                                     "2024-11-25",
      //                                     style: TextStyle(
      //                                       fontSize: 14.0,
      //                                       color: Colors.grey,
      //                                     ),
      //                                   ),
      //                                   SizedBox(width: 10.0,),
      //                                   Text(
      //                                     "5.39 PM",
      //                                     style: TextStyle(
      //                                       fontSize: 14.0,
      //                                       color: Colors.grey,
      //                                     ),
      //                                   ),
      //
      //                                 ],
      //                               )
      //
      //                             ],
      //                           ),
      //
      //                           // Waiting Column with Text and Icon
      //                           Column(
      //                             crossAxisAlignment: CrossAxisAlignment.center,
      //                             children: [
      //                               Container(
      //                                 decoration: BoxDecoration(
      //                                   color: Colors.orange.withOpacity(0.1),
      //                                   border: Border.all(
      //                                     color: Colors.orange,
      //                                     width: 1.0,
      //                                   ),
      //                                   borderRadius: BorderRadius.circular(8.0),
      //                                 ),
      //                                 padding: EdgeInsets.symmetric(
      //                                   horizontal: 12.0,
      //                                   vertical: 4.0,
      //                                 ),
      //                                 child: Text(
      //                                   'Waiting',
      //                                   style: TextStyle(
      //                                     fontSize: 14.0,
      //                                     color: Colors.orange,
      //                                     fontWeight: FontWeight.w500,
      //                                   ),
      //                                 ),
      //                               ),
      //                               SizedBox(height: 8.0),
      //                               Icon(
      //                                 Icons.arrow_forward_ios,
      //                                 color: Colors.grey,
      //                                 size: 16.0,
      //                               ),
      //                             ],
      //                           ),
      //                         ],
      //                       ),
      //                     ],
      //                   ),
      //                 )
      //               ],
      //             ),
      //           ),
      //
      //         ),
      //
      //
      //       ),
      //
      //
      //     ],
      //
      //   ),
      //
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Section 1: Local Ride
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Bookingdetails()));

              },
            child: Container(
                margin: EdgeInsets.only(bottom: 16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Local',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    Divider(thickness: 1, color: Colors.grey.shade300),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '2024-11-25 5:39 PM',
                          style: TextStyle(color: Colors.grey, fontSize: 14.0),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Text('Waiting'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),


            // Section 2: Out Station Ride
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Bookingdetails()));

              },
              child: Container(
                margin: EdgeInsets.only(bottom: 16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Out Station',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    Divider(thickness: 1, color: Colors.grey.shade300),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '2024-11-25 5:39 PM',
                          style: TextStyle(color: Colors.grey, fontSize: 14.0),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Text('Waiting'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),


            // Section 3: Transfer Ride
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Bookingdetails()));

              },
              child: Container(
                margin: EdgeInsets.only(bottom: 16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transfer',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    Divider(thickness: 1, color: Colors.grey.shade300),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '2024-11-25 5:39 PM',
                          style: TextStyle(color: Colors.grey, fontSize: 14.0),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Text('Waiting'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )

          ],
        ),
      ),

    );





  }
}
