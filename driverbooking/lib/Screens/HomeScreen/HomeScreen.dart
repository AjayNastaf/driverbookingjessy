

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:jessy_cabs/Bloc/AppBloc_State.dart';
import 'package:jessy_cabs/Bloc/App_Bloc.dart';
import 'package:jessy_cabs/Bloc/AppBloc_Events.dart';
import 'package:jessy_cabs/Screens/BookingDetails/BookingDetails.dart';
import 'package:jessy_cabs/Screens/CustomerLocationReached/CustomerLocationReached.dart';
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
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../NoInternetBanner/NoInternetBanner.dart';
import 'package:provider/provider.dart';
import '../network_manager.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:android_intent_plus/android_intent.dart';

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


  @override
  void initState() {
    super.initState();

    saveScreenData();

    print('Userhone: ${widget.userId}, Usernameddd: ${widget.username}');
    _loadUserData();


    context.read<DrawerDriverDataBloc>().add(DrawerDriverData(widget.username));

  }

  Future<void> _refreshData() async {
    BlocProvider.of<TripSheetValuesBloc>(context).add(
      FetchTripSheetValues(
        userid: widget.userId,
        drivername: userData?['drivername'] ?? 'Not Found',
      ),
    );
    context.read<DrawerDriverDataBloc>().add(DrawerDriverData(widget.username));

  }

  Future<void> saveScreenData() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('last_screen', 'FirstHomeScreen');

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



  static const platform = MethodChannel('com.example.jessy_cabs/background');


  // Function to request overlay permission
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
      await requestOverlayPermission(); // Ask permission before showing overlay
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


  @override
  Widget build(BuildContext context) {
    print("Building UI with userData: $userData"); // Debugging
    bool isConnected = Provider.of<NetworkManager>(context).isConnected;

    return Scaffold(
      key: _scaffoldKey,


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

      body: Stack(
    children: [
    RefreshIndicator(
    onRefresh: _refreshData,
      child: Column(
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
                // Use Flexible or Expanded instead of SizedBox + double.infinity
                Flexible(
                  child: SwitchListTile(
                    title: Text(isOnDuty ? "On Duty" : "Off Duty"),
                    value: isOnDuty,
                    onChanged: (value) async {
                      setState(() => isOnDuty = value);
                      await toggleFloatingService(value);
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child:BlocBuilder<TripSheetValuesBloc, TripSheetValuesState>(
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



                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: state.tripSheetData.length,
                    itemBuilder: (context, index) {
                      final trip = state.tripSheetData[index];

                      // Check if the current item is the first one
                      final isFirstItem = (index == 0);

                      return buildSection(
                        context,
                        title: '${trip['duty']}',
                        dateTime: '${trip['tripid']}',
                        buttonText: '${trip['apps']}',
                        isEnabled: isFirstItem,  // Pass enabled status

                        onTap: isFirstItem
                            ? () {
                          if (trip['apps'] == 'On_Going') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Customerlocationreached(
                                    tripId: trip['tripid'].toString()),
                              ),
                            );
                          } else {
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
          ), )

        ],
      ),



    ),

    Positioned(
    top: 15,
    left: 0,
    right: 0,
    child: NoInternetBanner(isConnected: isConnected),
    ),
    ],
    ),

    );
  }
}
