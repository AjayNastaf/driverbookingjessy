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
    _getCurrentLocation();
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

  Future<void> _getCurrentLocation() async {
    final location = Location();

    // Ensure location services are enabled
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return;
      }
    }

    // Request permissions
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print('Location permissions are denied.');
        return;
      }
    }

    // Set high accuracy
    await location.changeSettings(accuracy: LocationAccuracy.high);

    // Get current location
    final locationData = await location.getLocation();
    print('Latitude: ${locationData.latitude}, Longitude: ${locationData.longitude}');

    setState(() {
      _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
    });
    print('Latiteeude: ${_currentPosition}');


    // Move the map to the current location
    if (_mapController != null && _currentPosition != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 15),
      );
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
                color: Colors.green[700], // Set your green color here
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Faqscreen()));
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
      // appBar: AppBar(
      //   title: Text("mapppp"),
      // ),
      body: Stack(
        children: [

          // Overlay Container
          Padding(
            padding: const EdgeInsets.only(
              top: 80,
              bottom: 16,
              right: 16,
              left: 16,
            ),
            child: Container(
              padding: EdgeInsets.only(top: 10.0,left: 20.0,right: 20.0,bottom: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: Icon(Icons.menu),
                  ),
                  SizedBox(width: 8), // Space between icons and text/input
                  // Icon(Icons.location_on, color: Colors.green[700]),

                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: "Current location",
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 16),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Destinationlocationscreen()));
                      },
                    ),
                  ),
                  Icon(Icons.location_on, color: Colors.green[700]),

                ],
              ),
            ),
          ),

        ],
      ),
    );



  }
}
