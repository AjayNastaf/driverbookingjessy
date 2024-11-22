// import 'package:flutter/material.dart';
// import 'package:vehiclebooking/Networks/Api_Service.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:location/location.dart';
// import 'package:vehiclebooking/Screens/LoginScreen/Login_Screen.dart';
// import 'package:vehiclebooking/Screens/MenuListScreens/Contacts/ContactScreen.dart';
// import 'package:vehiclebooking/Screens/MenuListScreens/Faq/FaqScreen.dart';
// import 'package:vehiclebooking/Screens/MenuListScreens/Notifications/NotificationScreen.dart';
// import 'package:vehiclebooking/Screens/MenuListScreens/Profile/profile.dart';
// import 'package:vehiclebooking/Screens/MenuListScreens/ReferFriends/ReferFriendScreen.dart';
// import 'package:vehiclebooking/Screens/MenuListScreens/RideScreen/RideScreen.dart';
// import 'package:vehiclebooking/Screens/MenuListScreens/Wallet/WalletScreen.dart';
// import 'package:vehiclebooking/Utils/AllImports.dart';
//
// class Homescreen extends StatefulWidget {
//   final String userId;
//
//   // const Homescreen({Key? key, required this.userId}) : super(key: key);
//   const Homescreen({Key? key, required this.userId}) : super(key: key);
//
//   @override
//   State<Homescreen> createState() => _HomescreenState();
// }
//
// class _HomescreenState extends State<Homescreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _searchController = TextEditingController();
//
//   String? username;
//   String? password;
//   String? phonenumber;
//   String? email;
//   // late GoogleMapController _mapController;
//   // LatLng? _currentPosition;
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
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
//       print('emailssssssssssssssssssssssdddddd: $phonenumber');
//     }
//     else{
//       print("Failed to retrieve user details.");
//     }
//
//   }
//
//   Future<void> _getCurrentLocation() async {
//     // final location = Location();
//
//     // Ensure location services are enabled
//     // bool serviceEnabled = await location.serviceEnabled();
//     // if (!serviceEnabled) {
//     //   serviceEnabled = await location.requestService();
//     //   if (!serviceEnabled) {
//     //     print('Location services are disabled.');
//     //     return;
//     //   }
//     // }
//
//     // Request permissions
//     // PermissionStatus permissionGranted = await location.hasPermission();
//     // if (permissionGranted == PermissionStatus.denied) {
//     //   permissionGranted = await location.requestPermission();
//     //   if (permissionGranted != PermissionStatus.granted) {
//     //     print('Location permissions are denied.');
//     //     return;
//     //   }
//     // }
//
//     // Set high accuracy
//     // await location.changeSettings(accuracy: LocationAccuracy.high);
//
//     // Get current location
//     // final locationData = await location.getLocation();
//     // print('Latitude: ${locationData.latitude}, Longitude: ${locationData.longitude}');
//     //
//     // setState(() {
//     //   _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
//     // });
//     // print('Latiteeude: ${_currentPosition}');
//
//
//     // Move the map to the current location
//     // if (_mapController != null && _currentPosition != null) {
//     //   _mapController.animateCamera(
//     //     CameraUpdate.newLatLngZoom(_currentPosition!, 15),
//     //   );
//     // }
//   }
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
//                 color: Colors.green[700], // Set your green color here
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
//                   Navigator.push(context, MaterialPageRoute(builder: (context)=>Faqscreen()));
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
//               leading: Icon(Icons.logout),
//               title: Text('Logout'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login_Screen()));
//               },
//             ),
//             // ListTile(
//             //   leading: Icon(Icons.supervised_user_circle_sharp),
//             //   title: Text('Profile'),
//             //   onTap: () {
//             //     Navigator.pop(context);
//             //     Navigator.pushReplacement(
//             //         context, MaterialPageRoute(
//             //           builder: (context)=>ProfileScreen(
//             //               username: '$username',
//             //               password: '$password',
//             //               phonenumber: '$phonenumber',
//             //               email: '$email'),
//             //         )
//             //     );
//             //   },
//             // ),
//           ],
//         ),
//       ),
//       // appBar: AppBar(
//       //   title: Text("mapppp"),
//       // ),
//       body: Stack(
//         children: [
//           // Google Map
//           // _currentPosition == null
//           //     ? Center(child: CircularProgressIndicator())
//           //     : GoogleMap(
//           //   onMapCreated: (controller) => _mapController = controller,
//           //   initialCameraPosition: CameraPosition(
//           //     target: _currentPosition!,
//           //     zoom: 15,
//           //   ),
//           //   myLocationEnabled: true,
//           //   myLocationButtonEnabled: true,
//           // ),
//
//           // Overlay Container
//           Padding(
//             padding: const EdgeInsets.only(
//               top: 80,
//               bottom: 16,
//               right: 16,
//               left: 16,
//             ),
//             child: Container(
//               padding: EdgeInsets.only(top: 10.0,left: 20.0,right: 20.0,bottom: 10.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 10,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       _scaffoldKey.currentState?.openDrawer();
//                     },
//                     child: Icon(Icons.menu),
//                   ),
//                   SizedBox(width: 8), // Space between icons and text/input
//                   // Icon(Icons.location_on, color: Colors.green[700]),
//
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: TextField(
//                       controller: _locationController,
//                       decoration: InputDecoration(
//                         hintText: "Current location",
//                         border: InputBorder.none,
//                       ),
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                   Icon(Icons.location_on, color: Colors.green[700]),
//
//                 ],
//               ),
//             ),
//           ),
//           DraggableScrollableSheet(
//             initialChildSize: 0.3, // Initial size of the draggable section
//             minChildSize: 0.3, // Minimum size of the draggable section
//             maxChildSize: 0.7, // Maximum size of the draggable section
//             builder: (context, controller) {
//               return Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                       offset: Offset(0, -4),
//                     ),
//                   ],
//                 ),
//                 child: SingleChildScrollView(
//                   controller: controller,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Search Input
//
//                       TextFormField(
//                         controller: _searchController,
//
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.grey[200],
//                           prefixIcon: Icon(Icons.search, color: Colors.grey),
//                           hintText: "Where to?",
//                           hintStyle: TextStyle(color: Colors.grey[600]),
//                           contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 16),
//
//                       // Sample Address List
//                       ListTile(
//                         title: Text("Chennai, Tamil Nadu, India"),
//                         leading: Icon(Icons.location_on, color: Colors.green),
//                       ),
//                       ListTile(
//                         title: Text("New York, NY, USA"),
//                         leading: Icon(Icons.location_on, color: Colors.green),
//                       ),
//                       ListTile(
//                         title: Text("London, England, UK"),
//                         leading: Icon(Icons.location_on, color: Colors.green),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//
//         ],
//       ),
//     );
//
//
//
//   }
// }
//
//
//
