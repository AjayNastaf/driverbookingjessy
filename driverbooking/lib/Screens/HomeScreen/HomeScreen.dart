// import 'package:driverbooking/Screens/BookingDetails/BookingDetails.dart';
// import 'package:driverbooking/Screens/MenuListScreens/History/History.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:driverbooking/Screens/DestinationLocation/DestinationLocationScreen.dart';
// import 'package:driverbooking/Screens/LoginScreen/Login_Screen.dart';
// import 'package:driverbooking/Screens/MenuListScreens/Contacts/ContactScreen.dart';
// import 'package:driverbooking/Screens/MenuListScreens/Faq/FaqScreen.dart';
// import 'package:driverbooking/Screens/MenuListScreens/Notifications/NotificationScreen.dart';
// import 'package:driverbooking/Screens/MenuListScreens/ReferFriends/ReferFriendScreen.dart';
// import 'package:driverbooking/Screens/MenuListScreens/RideScreen/RideScreen.dart';
// import 'package:driverbooking/Screens/MenuListScreens/Wallet/WalletScreen.dart';
// import 'package:driverbooking/Screens/OtpScreen/OtpScreen.dart';
// import 'package:driverbooking/Utils/AllImports.dart';
// import 'package:driverbooking/Networks/Api_Service.dart';
// import 'package:driverbooking/Screens/MenuListScreens/Profile/profile.dart';
// import 'package:driverbooking/Screens/MenuListScreens/Settings/Settings.dart';
//
// class Homescreen extends StatefulWidget {
//   final String userId;
//
//   const Homescreen({Key? key, required this.userId}) : super(key:key);
//
//   @override
//   State<Homescreen> createState() => _HomescreenState();
// }
//
// class _HomescreenState extends State<Homescreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _searchController = TextEditingController();
//   String? username;
//   String? password;
//   String? phonenumber;
//   String?email;
//   late GoogleMapController _mapController;
//   LatLng? _currentPosition;
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     // _getCurrentLocation();
//     _getUserDetails();
//   }
//
//   void _getUserDetails() async {
//     final getUserDetailsResult = await ApiService.getUserDetailsDatabase(widget.userId);
//     if (getUserDetailsResult != null) {
//       setState(() {
//         username = getUserDetailsResult['username'];
//         password = getUserDetailsResult['password'];
//         phonenumber = getUserDetailsResult['phonenumber'];
//         email = getUserDetailsResult['email'];
//       });
//       // print('emailssssssssssssssssssssssdddddd: $phonenumber');
//     }
//     else{
//       print("Failed to retrieve user details.");
//     }
//
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       key: _scaffoldKey,
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: AppTheme.Navblue1, // Set your green color here
//               ),
//               child: Row(
//                 children: [
//                   Stack(
//                     children: [
//                       CircleAvatar(
//                         radius: 30, // Adjust size as needed
//                         backgroundImage: AssetImage(AppConstants.intro_three), // Replace with your image asset
//                         backgroundColor: Colors.grey[300], // Fallback color when no image is loaded
//                       ),
//                       Positioned(
//                         bottom: 0, // Positioning the edit icon at the bottom-right
//                         right: 0,
//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ProfileScreen(
//                                     userId: widget.userId,
//                                     username: '$username',
//                                     password: '$password',
//                                     phonenumber: '$phonenumber',
//                                     email: '$email'
//                                 ),
//                               ),
//                             );
//                           },
//                           child: CircleAvatar(
//                             radius: 12, // Adjust size of the edit icon container
//                             backgroundColor: Colors.white,
//                             child: Icon(
//                               Icons.edit,
//                               size: 16, // Icon size
//                               color: Colors.green[700], // Icon color
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(width: 16), // Add spacing between avatar and text
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center, // Center align vertically
//                     crossAxisAlignment: CrossAxisAlignment.start, // Align to the start
//                     children: [
//                       Text(
//                         "$username", // Replace with the user's name
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 4), // Spacing between name and email
//                       Text(
//                         "$email", // Replace with the user's email
//                         style: TextStyle(
//                           color: Colors.white70,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             ListTile(
//               leading: Icon(Icons.home),
//               title: Text('Home'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.car_repair_rounded),
//               title: Text('My Rides'),
//               onTap: () {
//                 // Navigator.push(context, ()=>)
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>Ridescreen()));
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.account_balance_wallet),
//               title: Text('Wallet'),
//               onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context)=>Walletscreen()));
//                 // Navigator.pop(context);
//               },
//
//             ),
//             ListTile(
//               leading: Icon(Icons.notifications),
//               title: Text('Notifications'),
//               onTap: () {
//                 // Navigator.pop(context);
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>Notificationscreen()));
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.group_add),
//               title: Text('Invite Friends'),
//               onTap: () {
//                 // Navigator.pop(context);
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>ReferFriendScreen()));
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.help_outline),
//               title: Text("Faq's"),
//               onTap: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context)=>FAQScreen()));
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.supervised_user_circle_rounded),
//               title: Text('Contact'),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>Contactscreen()));
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.supervised_user_circle_rounded),
//               title: Text('History'),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>History()));
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.settings),
//               title: Text('Settings'),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>Settings(
//                     userId: widget.userId,
//                     username: '$username',
//                     password: '$password',
//                     phonenumber: '$phonenumber',
//                     email: '$email'
//                 )));
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text('Logout'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login_Screen()));
//               },
//             ),
//           ],
//         ),
//       ),
//       appBar: AppBar(
//         title: Text("Home Screen"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             buildSection(
//               context,
//               title: 'Local',
//               dateTime: '2024-11-25 5:39 PM',
//               buttonText: 'Waiting',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => Bookingdetails()),
//                 );
//               },
//             ),
//             buildSection(
//               context,
//               title: 'Out Station',
//               dateTime: '2024-11-25 5:39 PM',
//               buttonText: 'Waiting',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => Bookingdetails()),
//                 );
//               },
//             ),
//             buildSection(
//               context,
//               title: 'Transfer',
//               dateTime: '2024-11-25 5:39 PM',
//               buttonText: 'Waiting',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => Bookingdetails()),
//                 );
//               },
//             ),
//
//           ],
//         ),
//       ),
//
//     );
//
//
//
//
//
//   }
// }

import 'package:driverbooking/Screens/BookingDetails/BookingDetails.dart';
import 'package:driverbooking/Screens/LoginScreen/Login_Screen.dart';
import 'package:driverbooking/Screens/MenuListScreens/Contacts/ContactScreen.dart';
import 'package:driverbooking/Screens/MenuListScreens/Faq/FaqScreen.dart';
import 'package:driverbooking/Screens/MenuListScreens/History/History.dart';
import 'package:driverbooking/Screens/MenuListScreens/Notifications/NotificationScreen.dart';
import 'package:driverbooking/Screens/MenuListScreens/Profile/profile.dart';
import 'package:driverbooking/Screens/MenuListScreens/ReferFriends/ReferFriendScreen.dart';
import 'package:driverbooking/Screens/MenuListScreens/RideScreen/RideScreen.dart';
import 'package:driverbooking/Screens/MenuListScreens/Settings/Settings.dart';
import 'package:driverbooking/Screens/MenuListScreens/Wallet/WalletScreen.dart';
import 'package:flutter/material.dart';
import 'package:driverbooking/Networks/Api_Service.dart';
import 'package:driverbooking/Utils/AllImports.dart';

class Homescreen extends StatefulWidget {
  final String userId;
  final String username;

  const Homescreen({Key? key, required this.userId, required this.username})
      : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> tripSheetData = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? username;
  String? password;
  String? phonenumber;
  String? email;


  @override
  void initState() {
    super.initState();
    _getUserDetails();
    _getUserDetailsDriver();

    print('Userhone: ${widget.userId}, Usernameddd: ${widget.username}');

  }



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeData();
  }
  Future<void> _initializeData() async {
    try {
      final data = await ApiService.fetchTripSheet(
        userId: widget.userId,
        username: widget.username,
      );
      setState(() {
        tripSheetData = data;
      });
    } catch (e) {
      print('Error initializing data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _getUserDetails() async {
    final getUserDetailsResult =
        await ApiService.getUserDetailsDatabase(widget.userId);
    if (getUserDetailsResult != null) {
      setState(() {
        username = getUserDetailsResult['username'];
        password = getUserDetailsResult['password'];
        phonenumber = getUserDetailsResult['phonenumber'];
        email = getUserDetailsResult['email'];
      });
      _fetchTripsheet(); // Fetch tripsheet data after retrieving user details
    } else {
      print("Failed to retrieve user details.");
    }
  }

  void _fetchTripsheet() async {
    if (username != null) {
      // final data = await ApiService.fetchTripsheet(username!);
      // setState(() {
      //   tripsheetData = data;
      // });
    }
  }

  void _getUserDetailsDriver() async {
    try {
      print('Fetching user details for username: ${widget.username}');
      final getUserDetailsResult = await ApiService.getDriverProfile(widget.username);

      if (getUserDetailsResult != null) {
        print('User details fetched successfullyyyyy: $getUserDetailsResult');
        var Driverusername = getUserDetailsResult['username'];
        var DriverEmail = getUserDetailsResult['Email'];
        var Driverphone = getUserDetailsResult['Mobileno'];
        var Driverpass = getUserDetailsResult['userpassword'];
        setState(() {
          username = Driverusername ;
          password = Driverpass;
          phonenumber = Driverphone;
          email = DriverEmail;
        });
      } else {
        print('Failed to retrieve user detailssss.');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Ridescreen(userId: widget.userId,username: widget.username,)));
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=>History(userId: widget.userId,username: widget.username,tripSheetData: tripSheetData, // Pass tripSheetData to History
                )));
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : tripSheetData.isEmpty
              ? const Center(
                  child: Text('No trip sheet data found.'),
                )
              : ListView.builder(
                  itemCount: tripSheetData.length,
                  itemBuilder: (context, index) {
                    final trip = tripSheetData[index];
                    return Column(
                      children: [
                        buildSection(
                          context,
                          title: '${trip['duty']}',
                          dateTime: ' ${trip['tripid']}',
                          buttonText: '${trip['apps']}',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Bookingdetails(username: widget.username, userId: widget.userId,
                                    tripId: trip['tripid'].toString(), // Convert tripid to a String
                                    duty: trip['duty'].toString(), // Convert tripid to a String
                                  )),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}
