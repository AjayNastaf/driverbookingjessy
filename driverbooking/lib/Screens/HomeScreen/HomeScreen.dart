// import 'package:jessy_cabs/Screens/BookingDetails/BookingDetails.dart';
// import 'package:jessy_cabs/Screens/MenuListScreens/History/History.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:jessy_cabs/Screens/DestinationLocation/DestinationLocationScreen.dart';
// import 'package:jessy_cabs/Screens/LoginScreen/Login_Screen.dart';
// import 'package:jessy_cabs/Screens/MenuListScreens/Contacts/ContactScreen.dart';
// import 'package:jessy_cabs/Screens/MenuListScreens/Faq/FaqScreen.dart';
// import 'package:jessy_cabs/Screens/MenuListScreens/Notifications/NotificationScreen.dart';
// import 'package:jessy_cabs/Screens/MenuListScreens/ReferFriends/ReferFriendScreen.dart';
// import 'package:jessy_cabs/Screens/MenuListScreens/RideScreen/RideScreen.dart';
// import 'package:jessy_cabs/Screens/MenuListScreens/Wallet/WalletScreen.dart';
// import 'package:jessy_cabs/Screens/OtpScreen/OtpScreen.dart';
// import 'package:jessy_cabs/Utils/AllImports.dart';
// import 'package:jessy_cabs/Networks/Api_Service.dart';
// import 'package:jessy_cabs/Screens/MenuListScreens/Profile/profile.dart';
// import 'package:jessy_cabs/Screens/MenuListScreens/Settings/Settings.dart';
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








import 'dart:convert';
import 'package:jessy_cabs/Bloc/AppBloc_State.dart';
import 'package:jessy_cabs/Bloc/App_Bloc.dart';
import 'package:jessy_cabs/Bloc/AppBloc_Events.dart';
import 'package:jessy_cabs/Screens/BookingDetails/BookingDetails.dart';
import 'package:jessy_cabs/Screens/CustomerLocationReached/CustomerLocationReached.dart';
import 'package:jessy_cabs/Screens/CustomerReachedWithouthcl/CustomerReachedWithouthcl.dart';
import 'package:jessy_cabs/Screens/LoginScreen/Login_Screen.dart';
import 'package:jessy_cabs/Screens/MenuListScreens/Contacts/ContactScreen.dart';
import 'package:jessy_cabs/Screens/MenuListScreens/Faq/FaqScreen.dart';
import 'package:jessy_cabs/Screens/MenuListScreens/Notifications/NotificationScreen.dart';
import 'package:jessy_cabs/Screens/MenuListScreens/Profile/profile.dart';
import 'package:jessy_cabs/Screens/MenuListScreens/ReferFriends/ReferFriendScreen.dart';
import 'package:jessy_cabs/Screens/MenuListScreens/RideScreen/RideScreen.dart';
import 'package:jessy_cabs/Screens/MenuListScreens/Settings/Settings.dart';
import 'package:jessy_cabs/Screens/MenuListScreens/Wallet/WalletScreen.dart';
import 'package:flutter/material.dart';
import 'package:jessy_cabs/Networks/Api_Service.dart';
import 'package:jessy_cabs/Screens/TripDetailsUpload/TripDetailsUpload.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../NoInternetBanner/NoInternetBanner.dart';
import 'package:provider/provider.dart';
import '../network_manager.dart';
import 'package:flutter/services.dart';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/services.dart';

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
  bool isOnDuty = false;

  String? username;
  String? password;
  String? phonenumber;
  String? email;
  Map<String, dynamic>? userData;
  String? driverName;
  bool isToggleOn = false; // default: toggle is off


  @override
  void initState() {
    super.initState();
    // _getUserDetails();
    // _getUserDetailsDriver();
    /// Dispatch the event when the screen loads
    saveScreenData();
    _loadUsernameFromPrefs();
    loadDutyStatus();


    print('Userhone: ${widget.userId}, Usernameddd: ${widget.username}');
    _loadUserData();

    // BlocProvider.of<TripSheetValuesBloc>(context).add(
    //   // FetchTripSheetValues(username: widget.username, userid: widget.userId),
    //
    //   FetchTripSheetValues(
    //     userid: widget.userId,
    //     drivername: userData?['user']?[0]?['drivername'] ?? 'Nottt Found',
    //   ),
    // );
    context.read<DrawerDriverDataBloc>().add(DrawerDriverData(widget.username));

  }

  Future<void> _refreshData() async {


    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString('username');

    print("geted username in home page from local storage ${username}");

    // if (username != null) {
    //   BlocProvider.of<TripSheetValuesBloc>(context).add(
    //     FetchTripSheetValues(
    //       userid: widget.userId,
    //       drivername: username!,
    //     ),
    //   );
    //   print('dispatched with help of refresh data of username');
    // }
    loadDutyStatus();



    if (userData?['drivername'] != null) {
      BlocProvider.of<TripSheetValuesBloc>(context).add(
        FetchTripSheetValues(
          userid: widget.userId,
          drivername: userData!['drivername'],
        ),
      );
      print('dispatched with help of refresh data of userData');

    }
    else if (username != null) {
      BlocProvider.of<TripSheetValuesBloc>(context).add(
        FetchTripSheetValues(
          userid: widget.userId,
          drivername: username!,
        ),
      );
      print('dispatched with help of refresh data of username');
    }


    // BlocProvider.of<TripSheetValuesBloc>(context).add(
    //   FetchTripSheetValues(
    //     userid: widget.userId,
    //     drivername: userData?['drivername'] ?? 'not found',
    //   ),
    // );

    context.read<DrawerDriverDataBloc>().add(DrawerDriverData(widget.username));

  }

  void _loadUsernameFromPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString('username');
    });
    print("geted username in home page from initState $username");
  }


  Future<void> saveScreenData() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('last_screen', 'FirstHomeScreen');

    // await prefs.setString('trip_id', widget.tripId);





    print('Saved screen data:');

    print('last_screen: FirstHomeScreen');

    // print('trip_id: ${widget.tripId}');



  }


  static const platform = MethodChannel('com.example.jessy_cabs/background');

  Future<void> requestOverlayPermission() async {
    const intent = AndroidIntent(
      action: 'android.settings.action.MANAGE_OVERLAY_PERMISSION',
      data: 'package:com.example.jessy_cabs',
    );

    await intent.launch();
  }

  // Function to start background service + floating icon




  Future<void> onDuty() async {

    try {
      final isGranted = await Permission.systemAlertWindow.isGranted;

      if (!isGranted) {
        await requestOverlayPermission(); // Only ask if not granted
        return; // Optional: stop further calls until permission is granted
      }

      // await requestOverlayPermission(); // Ask permission before showing overlay
      await platform.invokeMethod("startBackgroundService");
      await platform.invokeMethod("startFloatingIcon");
    } catch (e) {
      print("Error in onDuty: $e");
    }
  }


  // Function to stop background service + floating icon
  Future<void> offDuty() async {
    try {
      await platform.invokeMethod("stopBackgroundService");
      await platform.invokeMethod("stopFloatingIcon");

    } catch (e) {
      print("Error in offDuty: $e");

    }

  }


  // Toggle handler
  Future<void> toggleFloatingService(bool value) async {

    if (value) {
      await onDuty();

    } else {
      await offDuty();

    }

  }





  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');

    print("Retrieved userData String: $userDataString");

    if (userDataString != null && userDataString.isNotEmpty) {
      try {
        Map<String, dynamic> decodedData = jsonDecode(userDataString);

        setState(() {
          userData = decodedData;
        });

        print("After setState, userDatam: $userData");

        // 🚀 Move the event dispatch here, after userData is loaded
        BlocProvider.of<TripSheetValuesBloc>(context).add(
          FetchTripSheetValues(
            userid: widget.userId,
            drivername: userData?['drivername'] ?? 'Notttyu Found',
          ),
        );

        // context.read<DrawerDriverDataBloc>().add(DrawerDriverData(widget.username));
      } catch (e) {
        print("Error decoding userData: $e");
        print("Error decoding userData: $e");
      }
    } else {
      print("No userData found or it's empty in SharedPreferences.");
    }
  }


  // Future<void> _loadUserData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? userDataString = prefs.getString('userData');
  //
  //   print("Retrieved Data: $userDataString"); // Debugging line
  //
  //   if (userDataString != null) {
  //     setState(() {
  //       userData = jsonDecode(userDataString);
  //     });
  //
  //     print("Updated userData in state: $userData"); // Check if it's updated
  //   } else {
  //     print("No user data found in SharedPreferences!");
  //   }
  // }

  // Future<void> _loadUserData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? userDataString = prefs.getString('userData');
  //
  //   print("Retrieved userData String: $userDataString"); // Debugging
  //
  //   if (userDataString != null) {
  //     try {
  //       Map<String, dynamic> decodedData = jsonDecode(userDataString);
  //       print("Decoded userData: $decodedData"); // Ensure it’s a Map
  //
  //       setState(() {
  //         userData = decodedData ;
  //         // userData = decodedData;
  //       });
  //
  //       print("After setState, userData: $userData"); // Debugging after update
  //     } catch (e) {
  //       print("Error decoding userData: $e");
  //     }
  //   } else {
  //     print("No userData found in SharedPreferences.");
  //   }
  // }

  // Future<void> _loadUserData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? userDataString = prefs.getString('userData');
  //
  //   print("Retrieved userData String: $userDataString"); // Debugging
  //
  //   if (userDataString != null && userDataString.isNotEmpty) {
  //     try {
  //       // Check if the stored string is a JSON object or just a plain string
  //       if (userDataString.startsWith('{')) {
  //         Map<String, dynamic> decodedData = jsonDecode(userDataString);
  //
  //         setState(() {
  //           userData = decodedData;
  //         });
  //
  //         print("After setState, userData: $userData");
  //       } else {
  //         print("Error: Stored value is a plain string, not a JSON object.");
  //       }
  //     } catch (e) {
  //       print("Error decoding userData: $e");
  //     }
  //   } else {
  //     print("No userData found or it's empty in SharedPreferences.");
  //   }
  // }





  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // _initializeData();
  // }
  // Future<void> _initializeData() async {
  //   try {
  //     final data = await ApiService.fetchTripSheet(
  //       userId: widget.userId,
  //       username: widget.username,
  //     );
  //     setState(() {
  //       tripSheetData = data;
  //     });
  //   } catch (e) {
  //     print('Error initializing data: $e');
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // void _getUserDetails() async {
  //   final getUserDetailsResult =
  //       await ApiService.getUserDetailsDatabase(widget.userId);
  //   if (getUserDetailsResult != null) {
  //     setState(() {
  //       username = getUserDetailsResult['username'];
  //       password = getUserDetailsResult['password'];
  //       phonenumber = getUserDetailsResult['phonenumber'];
  //       email = getUserDetailsResult['email'];
  //     });
  //     // _fetchTripsheet(); // Fetch tripsheet data after retrieving user details
  //   } else {
  //     print("Failed to retrieve user details.");
  //   }
  // }

  // void _fetchTripsheet() async {
  //   if (username != null) {
  //     // final data = await ApiService.fetchTripsheet(username!);
  //     // setState(() {
  //     //   tripsheetData = data;
  //     // });
  //   }
  // }

  // void _getUserDetailsDriver() async {
  //   try {
  //     print('Fetching user details for username: ${widget.username}');
  //     final getUserDetailsResult = await ApiService.getDriverProfile(widget.username);
  //
  //     if (getUserDetailsResult != null) {
  //       print('User details fetched successfullyyyyy: $getUserDetailsResult');
  //       var Driverusername = getUserDetailsResult['username'];
  //       var DriverEmail = getUserDetailsResult['Email'];
  //       var Driverphone = getUserDetailsResult['Mobileno'];
  //       var Driverpass = getUserDetailsResult['userpassword'];
  //       setState(() {
  //         username = Driverusername ;
  //         password = Driverpass;
  //         phonenumber = Driverphone;
  //         email = DriverEmail;
  //       });
  //     } else {
  //       print('Failed to retrieve user detailssss.');
  //     }
  //   } catch (e) {
  //     print('Error fetching user details: $e');
  //   }
  // }

  void loadDutyStatus() async {

    final prefs = await SharedPreferences.getInstance();

    final storedValue = prefs.getBool('isOnDuty') ?? false;

    // setState(() => isOnDuty = storedValue);
    setState(() {
      isToggleOn = storedValue;
      isOnDuty = storedValue;
    });
  }



  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('last_screen');
    await prefs.remove('trip_id');
    await prefs.remove('user_id');
    await prefs.remove('username');
    await prefs.remove('address');
    await prefs.remove('drop_location');
    print("SharedPreferences cleared successfully");
  }



  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout Confirmation"),
          content: const Text("Do you really want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: ()  {
                 clearSharedPreferences();
                 removeAllFloatingIcons();
                context.read<AuthenticationBloc>().add(LoggedOut());

                Navigator.of(context).pop(); // Close the popup
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login_Screen()),
                );
              },
              child: const Text("Yes", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }





  bool _wasOffline = false;
  bool _registeredOnce = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_registeredOnce) {
      final network = Provider.of<NetworkManager>(context, listen: false);

      network.onReconnect(() async {
        if (_wasOffline) {
          print("🟢 Internet came back after refresh — fetching now...");

          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? userDataString = prefs.getString('userData');

          print("Retrievedwww userData String: $userDataString");

          if (userDataString != null && userDataString.isNotEmpty) {
            try {
              Map<String, dynamic> decodedData = jsonDecode(userDataString);

              if (mounted) {
                setState(() {
                  userData = decodedData;
                });
              }

              print("After setState, userData: $userData");

              context.read<TripSheetValuesBloc>().add(
                FetchTripSheetValues(
                  userid: widget.userId,
                  drivername: userData?['drivername'] ?? 'Not Found',
                ),
              );
            } catch (e) {
              print("Error decoding userData: $e");
            }
          } else {
            print("No userData found or it's empty in SharedPreferences.");
          }

          context.read<DrawerDriverDataBloc>().add(
            DrawerDriverData(widget.username),
          );

          _wasOffline = false;
        }
      });

      _registeredOnce = true;
    }
  }



 // static const platform = MethodChannel('com.example.jessy_cabs/background');

  Future<void> removeAllFloatingIcons() async {
    try {
      final result = await platform.invokeMethod("removeAllFloatingIcons");
      print("✅ $result");
    } catch (e) {
      print("❌ Failed to remove floating icons: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    print("Building UI with userData: $userData"); // Debugging
    // bool isConnected = Provider.of<NetworkManager>(context).isConnected;

    final isConnected = Provider.of<NetworkManager>(context).isConnected;

    // Set offline state so we know user was offline before
    if (!isConnected && !_wasOffline) {
      _wasOffline = true;
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
      key: _scaffoldKey,
      //   drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       DrawerHeader(
      //         decoration: BoxDecoration(
      //           color: AppTheme.Navblue1, // Set your green color here
      //         ),
      //         child: Row(
      //           children: [
      //             Stack(
      //               children: [
      //                 CircleAvatar(
      //                   radius: 30, // Adjust size as needed
      //                   backgroundImage: AssetImage(AppConstants.intro_three), // Replace with your image asset
      //                   backgroundColor: Colors.grey[300], // Fallback color when no image is loaded
      //                 ),
      //                 Positioned(
      //                   bottom: 0, // Positioning the edit icon at the bottom-right
      //                   right: 0,
      //                   child: GestureDetector(
      //                     onTap: () {
      //                       Navigator.push(
      //                         context,
      //                         MaterialPageRoute(
      //                           builder: (context) => ProfileScreen(
      //                               // userId: widget.userId,
      //                               username: widget.username,
      //                               // password: '$password',
      //                               // phonenumber: '$phonenumber',
      //                               // email: '$email'
      //                           ),
      //                         ),
      //                       );
      //                     },
      //                     child: CircleAvatar(
      //                       radius: 12, // Adjust size of the edit icon container
      //                       backgroundColor: Colors.white,
      //                       child: Icon(
      //                         Icons.edit,
      //                         size: 16, // Icon size
      //                         color: Colors.green[700], // Icon color
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             SizedBox(width: 16), // Add spacing between avatar and text
      //             BlocBuilder<DrawerDriverDataBloc, DrawerDriverDetailsState>(builder: (context , state){
      //               if(state is DrawerDriverDataLoading){
      //                 return CircularProgressIndicator();
      //               } else if(state is DrawerDriverDataLoaded){
      //                 return
      //                   Column(
      //                   mainAxisAlignment: MainAxisAlignment.center, // Center align vertically
      //                   crossAxisAlignment: CrossAxisAlignment.start, // Align to the start
      //                   children: [
      //                     Text(
      //                       '${state.username}', // Replace with the user's name
      //                       style: TextStyle(
      //                         color: Colors.white,
      //                         fontSize: 18,
      //                         fontWeight: FontWeight.bold,
      //                       ),
      //                     ),
      //                     SizedBox(height: 4), // Spacing between name and email
      //                     Text(
      //                       '${state.email}', // Replace with the user's email
      //                       style: TextStyle(
      //                         color: Colors.white70,
      //                         fontSize: 14,
      //                       ),
      //                     ),
      //                   ],
      //                 );
      //               }else{
      //                 return Text('Failed to load user data',
      //                     style: TextStyle(color: Colors.red),);
      //               }
      //             }),
      //
      //
      //           ],
      //         ),
      //       ),
      //
      //       ListTile(
      //         leading: Icon(Icons.home),
      //         title: Text('Home'),
      //         onTap: () {
      //           Navigator.pop(context);
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.car_repair_rounded),
      //         title: Text('My Rides'),
      //         onTap: () {
      //           // Navigator.push(context, ()=>)
      //           Navigator.push(context, MaterialPageRoute(builder: (context)=>Ridescreen(userId: widget.userId,username: widget.username,)));
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.account_balance_wallet),
      //         title: Text('Wallet'),
      //         onTap: () {
      //         Navigator.push(context, MaterialPageRoute(builder: (context)=>Walletscreen()));
      //           // Navigator.pop(context);
      //         },
      //
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.notifications),
      //         title: Text('Notifications'),
      //         onTap: () {
      //           // Navigator.pop(context);
      //           Navigator.push(context, MaterialPageRoute(builder: (context)=>Notificationscreen()));
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.group_add),
      //         title: Text('Invite Friends'),
      //         onTap: () {
      //           // Navigator.pop(context);
      //           Navigator.push(context, MaterialPageRoute(builder: (context)=>ReferFriendScreen()));
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.help_outline),
      //         title: Text("Faq's"),
      //         onTap: () {
      //             Navigator.push(context, MaterialPageRoute(builder: (context)=>FAQScreen()));
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.supervised_user_circle_rounded),
      //         title: Text('Contact'),
      //         onTap: () {
      //           Navigator.push(context, MaterialPageRoute(builder: (context)=>Contactscreen()));
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.supervised_user_circle_rounded),
      //         title: Text('History'),
      //         onTap: () {
      //           Navigator.push(context, MaterialPageRoute(builder: (context)=>History(userId: widget.userId,username: widget.username,tripSheetData: tripSheetData, // Pass tripSheetData to History
      //           )));
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.settings),
      //         title: Text('Settings'),
      //         onTap: () {
      //           Navigator.push(context, MaterialPageRoute(builder: (context)=>Settings(
      //               userId: widget.userId,
      //               username: '$username',
      //               password: '$password',
      //               phonenumber: '$phonenumber',
      //               email: '$email'
      //           )));
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.logout),
      //         title: Text('Logout'),
      //         onTap: () {
      //           Navigator.pop(context);
      //           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login_Screen()));
      //         },
      //       ),
      //     ],
      //   ),
      // ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            BlocBuilder<DrawerDriverDataBloc, DrawerDriverDetailsState>(
              builder: (context, state) {
                if (state is DrawerDriverDataLoading) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is DrawerDriverDataLoaded) {
                  return DrawerHeader(
                    decoration: BoxDecoration(
                      color: AppTheme.Navblue1, // Set your desired color
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            // CircleAvatar(
                            //   radius: 30, // Adjust size
                            //   backgroundImage: AssetImage(AppConstants.intro_three),
                            //   backgroundColor: Colors.grey[300],
                            // ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: (state.profileImage != null && state.profileImage!.isNotEmpty)
                                  ? NetworkImage("${AppConstants.baseUrl}/profile_photos/${state.profileImage!}")
                                  // ? NetworkImage("${AppConstants.baseUrl}/${state.profileImage!}")
                                  : AssetImage(AppConstants.intro_three) as ImageProvider,
                            ),



                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                        username: state.username, // Use loaded username
                                      ),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.edit, size: 16, color: Colors.green[700]),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.username, // Loaded from state
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              state.email, // Loaded from state
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return DrawerHeader(
                    decoration: BoxDecoration(color: AppTheme.Navblue1),
                    child: Center(
                      child: Text('Failed to load user data', style: TextStyle(color: Colors.red)),
                    ),
                  );
                }
              },
            ),


          // ListTile(
          //   leading: Icon(Icons.home),
          //   title: Text('Home'),
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.car_repair_rounded),
            title: Text('My Rides'),
            onTap: () {
              // Navigator.push(context, ()=>)
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Ridescreen(userId: widget.userId,username: widget.username,)));
            },
          ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Info'),
              onTap: () {
                // Navigator.push(context, ()=>)
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>Ridescreen(userId: widget.userId,username: widget.username,)));
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Walletscreen()));
              },
            ),
          // ListTile(
          //   leading: Icon(Icons.account_balance_wallet),
          //   title: Text('Wallet'),
          //   onTap: () {
          //   Navigator.push(context, MaterialPageRoute(builder: (context)=>Walletscreen()));
          //     // Navigator.pop(context);
          //   },
          //
          // ),
          // ListTile(
          //   leading: Icon(Icons.notifications),
          //   title: Text('Notifications'),
          //   onTap: () {
          //     // Navigator.pop(context);
          //     Navigator.push(context, MaterialPageRoute(builder: (context)=>Notificationscreen()));
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.group_add),
          //   title: Text('Invite Friends'),
          //   onTap: () {
          //     // Navigator.pop(context);
          //     Navigator.push(context, MaterialPageRoute(builder: (context)=>ReferFriendScreen()));
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.help_outline),
          //   title: Text("Faq's"),
          //   onTap: () {
          //       Navigator.push(context, MaterialPageRoute(builder: (context)=>FAQScreen()));
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.supervised_user_circle_rounded),
          //   title: Text('Contact'),
          //   onTap: () {
          //     Navigator.push(context, MaterialPageRoute(builder: (context)=>Contactscreen()));
          //   },
          // ),









          // ListTile(
          //   leading: Icon(Icons.supervised_user_circle_rounded),
          //   title: Text('History'),
          //   onTap: () {
          //     Navigator.push(context, MaterialPageRoute(builder: (context)=>History(userId: widget.userId,username: widget.username,tripSheetData: tripSheetData, // Pass tripSheetData to History
          //     )));
          //   },
          // ),





          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text('Settings'),
          //   onTap: () {
          //     // Navigator.push(context, MaterialPageRoute(builder: (context)=>Settings(
          //     //     userId: widget.userId,
          //     //     username: '$username',
          //     //     password: '$password',
          //     //     phonenumber: '$phonenumber',
          //     //     email: '$email'
          //     // )));
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            // onTap: () {
            //   Navigator.pop(context);
            //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login_Screen()));
            // },
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
            // Other drawer items...
          ],
        ),
      ),

      appBar: AppBar(
        title: Text("Home Screen"),

      ),
    //   body:Stack(
    //     children: [
    //
    //
    //     // Column(
    //     //   children: [
    //     //
    //     //
    //     //     Text("Message: ${userData?['message'] ?? 'Not Found'}"),
    //     //     Text("User ID: ${userData?['user']?[0]?['id'] ?? 'Not Found'}"),
    //     //     Text("Driver ID: ${userData?['user']?[0]?['driverid'] ?? 'Not Found'}"),
    //     //     Text("Driver Name: ${userData?['user']?[0]?['drivername'] ?? 'Not Found'}"),
    //     //     Text("Username: ${userData?['user']?[0]?['username'] ?? 'Not Found'}"),
    //     //     Text("Stations: ${userData?['user']?[0]?['stations'] ?? 'Not Found'}"),
    //     //     Text("Mobile No: ${userData?['user']?[0]?['Mobileno'] ?? 'Not Found'}"),
    //     //     Text("Email: ${userData?['user']?[0]?['Email'] ?? 'Not Found'}"),
    //     //
    //     //   ],
    //     // )
    // //   RefreshIndicator(
    // //     onRefresh: _refreshData, // 🔄 Pull-to-Refresh function
    // //     child:BlocBuilder<TripSheetValuesBloc, TripSheetValuesState>(
    // //     builder: (context, state) {
    // //       if (state is FetchingTripSheetValuesLoading) {
    // //         return const Center(
    // //           child: CircularProgressIndicator(),
    // //         );
    // //       }
    // //
    // //       else if (state is FetchingTripSheetValuesLoaded) {
    // //         return state.tripSheetData.isEmpty
    // //             ? const Center(
    // //           child: Text('No trip sheet data found.'),
    // //         )
    // //             : ListView.builder(
    // //           itemCount: state.tripSheetData.length, // Use state.tripSheetData
    // //           itemBuilder: (context, index) {
    // //             final trip = state.tripSheetData[index]; // Use state.tripSheetData
    // //             return Column(
    // //               children: [
    // //                 buildSection(
    // //                   context,
    // //                   title: '${trip['duty']}',
    // //                   dateTime: '${trip['tripid']}',
    // //                   buttonText: '${trip['apps']}',
    // //                   onTap: () {
    // //                     Navigator.push(
    // //                       context,
    // //                       MaterialPageRoute(
    // //                         builder: (context) => Bookingdetails(
    // //                           username: widget.username,
    // //                           userId: widget.userId,
    // //                           tripId: trip['tripid'].toString(),
    // //                           duty: trip['duty'].toString(),
    // //                         ),
    // //                       ),
    // //                     );
    // //                   },
    // //                 ),
    // //               ],
    // //             );
    // //           },
    // //         );
    // //       }
    // //
    // //
    // //
    // //
    // //
    // //
    // //
    // //
    // //
    // //
    // //
    // //
    // //
    // //
    // //
    // //
    // //
    // //
    // //
    // //
    // //
    // //
    // //
    // //
    // //
    // //
    // //
    // //       // Default case to handle any unexpected state
    // //       return Container();
    // //     },
    // //   ),
    // //
    // // ),
    //       RefreshIndicator(
    //         onRefresh: _refreshData, // 🔄 Pull-to-Refresh function
    //         child: SingleChildScrollView(
    //           physics: const AlwaysScrollableScrollPhysics(), // Ensures pull-to-refresh always works
    //           child: BlocBuilder<TripSheetValuesBloc, TripSheetValuesState>(
    //             builder: (context, state) {
    //               if (state is FetchingTripSheetValuesLoading) {
    //                 return const Center(
    //                   child: CircularProgressIndicator(),
    //                 );
    //               } else if (state is FetchingTripSheetValuesLoaded) {
    //                 // return state.tripSheetData.isEmpty
    //                 //     ? const Center(
    //                 //       child: Text('No trip sheet data found.'),
    //                 //     )
    //                 //     :
    //
    //
    //
    // if (state.tripSheetData.isEmpty) {
    //   return ListView(
    //   physics: const AlwaysScrollableScrollPhysics(), // required to trigger pull even when empty
    //     children: const [
    //      SizedBox(height: 300), // push content down to make pull-to-refresh visible
    //       Center(child: Text('No trip sheet data found.')),
    //     ],
    //   );
    // } else {
    //   return
    //     ListView.builder(
    //       physics: const AlwaysScrollableScrollPhysics(),
    //
    //       shrinkWrap: true,
    //
    //       // Prevents nested scrolling issues
    //       itemCount: state.tripSheetData.length,
    //       // Use state.tripSheetData
    //       itemBuilder: (context, index) {
    //         final trip = state.tripSheetData[index]; // Use state.tripSheetData
    //         return Column(
    //           children: [
    //             buildSection(
    //               context,
    //               title: '${trip['duty']}',
    //               dateTime: '${trip['tripid']}',
    //               buttonText: '${trip['apps']}',
    //               onTap: () {
    //                 Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                     builder: (context) =>
    //                         Bookingdetails(
    //                           username: widget.username,
    //                           userId: widget.userId,
    //                           tripId: trip['tripid'].toString(),
    //                           duty: trip['duty'].toString(),
    //                         ),
    //                   ),
    //                 );
    //               },
    //             ),
    //           ],
    //         );
    //       },
    //     );
    // };
    //               }
    //               // Default case to handle any unexpected state
    //               return Container();
    //             },
    //           ),
    //         ),
    //       ),
    //
    //       Positioned(
    //     top: 15,
    //     left: 0,
    //     right: 0,
    //     child: NoInternetBanner(isConnected: isConnected),
    //   ),
    //
    //     ],
    //   )
      body: Stack(
    children: [
    RefreshIndicator(
    onRefresh: _refreshData,
      child:Column(

      children: [

      // 🔄 On Duty / Off Duty Toggle Switch

      Padding(

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

        child: Row(

          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            const Text(
              "Duty Status",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            Flexible(

              child: SwitchListTile(

                title: Text(isOnDuty ? "On Duty" : "Off Duty"),
                value: isToggleOn,

                // value: isOnDuty,

                onChanged: (value) async {

                  // setState(() => isOnDuty = value);
                  // setState(() { isToggleOn = value; });
                  setState(() {
                    isOnDuty = value;
                    isToggleOn = value;

                  });
                  final prefs = await SharedPreferences.getInstance();

                  await prefs.setBool('isOnDuty', value);

                  await toggleFloatingService(value);
                  // setState(() {
                  // isOnDuty = value;
                  // isToggleOn = value;
                  //
                  // });
                  if (!value) {
                    await removeAllFloatingIcons(); // 👈 remove bubble if toggled off
                  }

                },

                contentPadding: EdgeInsets.zero,
              ),

            ),
          ],

        ),

      ),



        Expanded(
          child: BlocBuilder<TripSheetValuesBloc, TripSheetValuesState>(
        builder: (context, state) {
          if (state is FetchingTripSheetValuesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FetchingTripSheetValuesLoaded) {
            if (state.tripSheetData.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 300),
                  Center(child: Text('No trip sheet data found.')),
                ],
              );
            } else {
              // return ListView.builder(
              //   physics: const AlwaysScrollableScrollPhysics(),
              //   itemCount: state.tripSheetData.length,
              //   itemBuilder: (context, index) {
              //     final trip = state.tripSheetData[index];
              //     return buildSection(
              //       context,
              //       title: '${trip['duty']}',
              //       dateTime: '${trip['tripid']}',
              //       buttonText: '${trip['apps']}',
              //       // onTap: () {
              //       //   Navigator.push(
              //       //     context,
              //       //     MaterialPageRoute(
              //       //       builder: (context) => Bookingdetails(
              //       //         username: widget.username,
              //       //         userId: widget.userId,
              //       //         tripId: trip['tripid'].toString(),
              //       //         duty: trip['duty'].toString(),
              //       //       ),
              //       //     ),
              //       //   );
              //       // },
              //       onTap: () {
              //         if (trip['apps'] == 'On_Going') {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => Customerlocationreached(tripId: trip['tripid'].toString()),
              //             ),
              //           );
              //         } else {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => Bookingdetails(
              //                 username: widget.username,
              //                 userId: widget.userId,
              //                 tripId: trip['tripid'].toString(),
              //                 duty: trip['duty'].toString(),
              //               ),
              //             ),
              //           );
              //         }
              //       },
              //
              //     );
              //   },
              // );


              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.tripSheetData.length,
                itemBuilder: (context, index) {
                  final trip = state.tripSheetData[index];

                  // Check if the current item is the first one
                  final isFirstItem = (index == 0);
                  final isItemEnabled = isOnDuty && isFirstItem;
                  return buildSection(
                    context,
                    title: '${trip['duty']}',
                    dateTime: '${trip['tripid']}',
                    buttonText: '${trip['apps']}',
                    // buttonText: '${trip['Hybriddata']}',
                    // isEnabled: isFirstItem,  // Pass enabled status
                    isEnabled: isItemEnabled,  // Pass enabled status

                    // onTap: isFirstItem
                    onTap: isItemEnabled
                        ? () {
                      if ((trip['apps'] == 'On_Going' ) && (trip['Hybriddata'] == 1)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Customerlocationreached(
                                tripId: trip['tripid'].toString()),
                          ),
                        );
                      } else if ((trip['apps'] == 'On_Going' ) && (trip['Hybriddata'] == 0)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerReachedWithouthcl(
                                tripId: trip['tripid'].toString()),
                          ),
                        );



                      }else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Bookingdetails(
                              username: widget.username,
                              userId: widget.userId,
                              tripId: trip['tripid'].toString(),
                              duty: trip['duty'].toString(),
                            ),
                          ),


                        );

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => TripDetailsUpload(
                        //       tripId: trip['tripid'].toString(),
                        //     ),
                        //   ),
                        //
                        //
                        // );


                      }
                    }
                        : null,  // Disable onTap if not the first item
                  );
                },
              );

            }
          }
          return const SizedBox(); // Fallback empty widget
        },
       ),
       )

      ]),
     ),

    Positioned(
    top: 15,
    left: 0,
    right: 0,
    child: NoInternetBanner(isConnected: isConnected),
    ),
    ],
    ),

    ),);
  }
}
