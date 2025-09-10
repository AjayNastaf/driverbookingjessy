

//working

//
// import 'package:jessy_cabs/Screens/BookingDetails/BookingDetails.dart';
// import 'package:jessy_cabs/Screens/CustomerReachedWithouthcl/CustomerReachedWithouthcl.dart';
// import 'package:jessy_cabs/Screens/HomeScreen/HomeScreen.dart';
// import 'package:jessy_cabs/Screens/PickUpWithoutHcl/PickUpWithoutHcl.dart';
// import 'package:jessy_cabs/Screens/TrackingWithOutHcl/TrackingWithOutHcl.dart';
// import 'package:jessy_cabs/Utils/AllImports.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sizer/sizer.dart';
// import 'package:jessy_cabs/Screens/SplashScreen.dart';
// import 'package:jessy_cabs/Screens/Home.dart';
// import 'package:jessy_cabs/Screens/LoginScreen/Login_Screen.dart';
// import 'package:jessy_cabs/Bloc/App_Bloc.dart';
// import 'package:jessy_cabs/Networks/Api_Service.dart';// Import your Bloc file
// import 'package:jessy_cabs/Utils/AppConstants.dart';
// import 'package:provider/provider.dart';
// import 'Screens/AuthWrapper.dart';
// import 'Screens/CustomerLocationReached/CustomerLocationReached.dart';
// import 'Screens/PickupScreen/PickupScreen.dart';
// import 'Screens/SignatureEndRide/SignatureEndRide.dart';
// import 'Screens/StartingKilometer/StartingKilometer.dart';
// import 'Screens/TollParkingUpload/TollParkingUpload.dart';
// import 'Screens/TrackingPage/TrackingPage.dart';
// import 'Screens/TripDetailsPreview/TripDetailsPreview.dart';
// import 'Screens/TripDetailsUpload/TripDetailsUpload.dart';
// import 'Screens/network_manager.dart';// Import your Bloc file
// import 'package:flutter/services.dart';
// import 'package:jessy_cabs/services/notification_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
//
// void main()async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await NotificationService.initializeNotifications();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//
//   String? lastScreen = prefs.getString('last_screen');
//
//   String? tripId = prefs.getString('trip_id');
//
//   String? duty = prefs.getString('duty');
//
//   String? userId = prefs.getString('user_id');
//
//   String? username = prefs.getString('username');
//
//   String? address = prefs.getString('address');
//
//   String? dropLocation = prefs.getString('drop_location'); // 👈 Add this
//
//
//
//   // Debug prints
//
//   print('Loaded from SharedPreferences:');
//
//   print('last_screen: $lastScreen');
//
//   print('trip_id: $tripId');
//
//   print('duty: $duty');
//
//   print('user_id: $userId');
//
//   print('username: $username');
//
//   print('address: $address');
//
//   print('destination: $dropLocation');
//
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => NetworkManager(),
//       child:MultiBlocProvider(
//         providers: [
//           BlocProvider(
//             create: (context) => TripSheetValuesBloc(), // No event added yet
//           ),
//           BlocProvider(
//             create: (context) => TripSheetClosedValuesBloc(), // No event added yet
//           ),
//           BlocProvider(
//             create: (context) => DrawerDriverDataBloc(),
//           ),
//           BlocProvider(
//             create: (context) => GettingTripSheetDetailsByUseridBloc(),
//           ),
//
//           BlocProvider(
//               create: (context) => UpdateTripStatusInTripsheetBloc()
//           ),
//           BlocProvider(
//             create: (context) => StartKmBloc(),
//           ),
//           BlocProvider(
//               create: (context) => TripSignatureBloc()
//           ),
//           BlocProvider(
//               create: (context) => TripSheetDetailsTripIdBloc()
//           ),
//           BlocProvider(
//               create: (context) => TollParkingDetailsBloc()
//           ),
//           BlocProvider(
//               create: (context) => TripBloc()
//           ),
//           // BlocProvider(create: (context) => FetchTripSheetClosedBloc()),
//
//           BlocProvider(create: (context) => TripSheetBloc()),
//
//           // BlocProvider(create: (context) => FetchFilteredRidesBloc()),
//           BlocProvider(create: (context) => FetchFilteredRidesBloc()),
//           BlocProvider(create: (context) => ProfileBloc()),
//           BlocProvider(create: (context) => TripTrackingDetailsBloc()),
//           BlocProvider(create: (context) => GettingClosingKilometerBloc(apiService)),
//           BlocProvider(create: (context) => TripClosedTodayBloc(apiService)),
//
//           BlocProvider(create: (context) => DocumentImagesBloc(
//               apiService: ApiService(apiUrl: "${AppConstants.baseUrl}"))),
//
//           // BlocProvider<GettingClosingKilometerBloc>(
//           //   create: (context) => GettingClosingKilometerBloc(),
//           // ),
//
//           //For OTP
//
//           //------------------------------------------------
//
//           BlocProvider(create: (context) => OtpBloc()),
//
//           BlocProvider(create: (context)=>LastOtBloc()),
//           BlocProvider(create: (context) => EmailBloc()),
//           BlocProvider(create: (context) => SenderInfoBloc()),
//
//           BlocProvider(create: (context)=>SignupBloc()),
//           BlocProvider(create: (context)=>LoginViaBloc()),
//
//           BlocProvider(create: (context)=> GetDurationBloc()),
//           BlocProvider(create: (context)=> GetOkayBloc()),
//
//
//
//
//
//
//
//           BlocProvider(create: (_) => AuthenticationBloc()..add(AppStarted())), // 👈 Add this
//
//
// //-------------------------------------------------------------
//
//
//
//         ],
//         // child: const MyApp(),
//         child: MyApp(
//
//           initialRoute: lastScreen,
//
//           tripId: tripId,
//
//           duty: duty,
//
//           userId: userId,
//
//           username: username,
//
//           address: address,
//
//           dropLocation: dropLocation,
//
//         ),
//       ),
//     ),
//   );
// }
//
// class MyApp extends StatefulWidget {
//   final String? initialRoute;
//
//   final String? tripId;
//
//   final String? duty;
//
//   final String? userId;
//
//   final String? username;
//
//   final String? address;
//
//   final String? dropLocation;
//
//
//
//   const MyApp({
//
//     super.key,
//
//     required this.initialRoute,
//
//     this.tripId,
//
//     this.duty,
//
//     this.userId,
//
//     this.username,
//
//     this.address,
//
//     this.dropLocation,
//
//   });
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//
//   bool? isOptimized;
//
//   @override
//   void initState() {
//     super.initState();
//     // WidgetsBinding.instance.addPostFrameCallback((_) async {
//     //   requestPermissions(); // Request permissions before starting the service
//     //   BackgroundServiceHelper.startBackgroundService();
//     //   startBackgroundService();
//     //
//     // });
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       requestPermissions(); // Request permissions before starting the service
//       BackgroundServiceHelper.startBackgroundService();
//
//
//     });
//   }
//   @override
//
//   void dispose() {
//
//     super.dispose();
//
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Sizer(builder: (context, orientation, deviceType) {
//       return MaterialApp(
//
//         debugShowCheckedModeBanner: false,
//         title: "Vehicle Booking App",
//         theme: ThemeData(primarySwatch: Colors.blue),
//         // home: const SplashScreen(),
//         // home: const AuthWrapper(), // 👈 replace SplashScreen
//         home: _getInitialScreen(
//
//           widget.initialRoute,
//
//           tripId: widget.tripId,
//
//           duty: widget.duty,
//
//           userId: widget.userId,
//
//           username: widget.username,
//
//           address: widget.address,
//
//           dropLocation: widget.dropLocation,
//
//         ),
//         routes: {
//
//           'home': (context) => const Home(),
//           // 'home': (context) => const SplashScreen(),
//           'login': (context) => const Login_Screen(),
//         },
//       );
//     });
//   }
// }
//
// Widget _getInitialScreen(
//
//     String? lastScreen, {
//
//       String? tripId,
//
//       String? duty,
//
//       String? userId,
//
//       String? username,
//
//       String? address,
//
//       String? dropLocation, // 👈 Add this
//
//     }) {
//
//   switch (lastScreen) {
//
//     case 'FirstHomeScreen':
//
//       return Homescreen(
//         userId: userId ?? '',
//
//         username: username ?? '',
//
//
//       );
//
//     case 'Pickupscreen':
//
//       return Pickupscreen(
//
//         tripId: tripId ?? '',
//
//         address: address ?? '',
//
//       );
//
//       case 'PickupscreenwithoutHcl':
//
//       return PickUpWithoutHcl(
//
//         tripId: tripId ?? '',
//
//         address: address ?? '',
//
//       );
//
//     case 'Bookingdetails':
//
//       return Bookingdetails(
//
//         userId: userId ?? '',
//
//         username: username ?? '',
//
//         tripId: tripId ?? '',
//
//         duty: duty ?? '',
//
//       );
//
//     case 'startingkm':
//
//       return StartingKilometer(
//
//         tripId: tripId ?? '',
//
//         address: address ?? '',
//
//       );
//
//     case 'TrackingPage':
//
//       return Builder(
//
//         builder: (_) => TrackingPage(
//
//           key: UniqueKey(),
//
//           tripId: tripId ?? '',
//
//           address: address ?? '',
//
//         ),
//
//       );
//
//     case 'TrackingWithOutHcl':
//
//       return Builder(
//
//         builder: (_) => TrackingWithOutHcl(
//
//           key: UniqueKey(),
//
//           tripId: tripId ?? '',
//
//           address: address ?? '',
//
//         ),
//
//       );
//
//     case 'customerLocationPage':
//
//       return Builder(
//
//         builder: (_) => Customerlocationreached(
//
//           key: UniqueKey(),
//
//           tripId: tripId ?? '',
//
//         ),
//
//       );
//
//     case 'CustomerReachedWithouthcl':
//
//       return Builder(
//
//         builder: (_) => CustomerReachedWithouthcl(
//
//           key: UniqueKey(),
//
//           tripId: tripId ?? '',
//
//         ),
//
//       );
//
//     case 'signpagescreen':
//
//       return Signatureendride(tripId: tripId ?? '');
//
//     case 'TripDetailsUpload':
//
//       return TripDetailsUpload(tripId: tripId ?? '');
//
//     case 'TripDetailsPreview':
//
//       return TripDetailsPreview(tripId: tripId ?? '');
//
//     case 'TollParkingUpload':
//
//       return TollParkingUpload(tripId: tripId ?? '');
//
//     default:
//
//       return const AuthWrapper(); // Default screen
//
//   }
//
// }
//
//
// //
// // void requestPermissions() async {
// //   var status = await Permission.location.request();
// //   if (status.isGranted) {
// //     // Permissions granted, proceed with location tracking
// //   } else {
// //     // Handle the case when permissions are not granted
// //   }
// // }
// //
// // class BackgroundServiceHelper {
// //   static const MethodChannel _channel = MethodChannel("com.example.jessy_cabs/background");
// //   static const MethodChannel _notificationChannel = MethodChannel("com.example.jessy_cabs/notification");
// //   static Future<void> startBackgroundService() async {
// //     try {
// //       // final result = await _channel.invokeMethod("startService");
// //       final result = await _channel.invokeMethod("startBackgroundService");
// //       print("Background service result: $result");
// //     } on PlatformException catch (e) {
// //       print("Error starting background service: ${e.message}");
// //     }
// //   }
// // }
// //
// //
// //
// // const platform = MethodChannel('com.example.jessy_cabs/background');
// //
// // Future<void> startBackgroundService() async {
// //   try {
// //     await platform.invokeMethod('startBackgroundService');
// //   } catch (e) {
// //     print("Error starting service: $e");
// //   }
// // }
// //
// // Future<void> stopBackgroundService() async {
// //   try {
// //     await platform.invokeMethod('stopBackgroundService');
// //   } catch (e) {
// //     print("Error stopping service: $e");
// //   }
// // }
//
//
// void requestPermissions() async {
//   var status = await Permission.location.request();
//   if (status.isGranted) {
//     // Permissions granted, proceed with location tracking
//   } else {
//     // Handle the case when permissions are not granted
//   }
// }
//
// class BackgroundServiceHelper {
//   static const MethodChannel _channel = MethodChannel("com.example.jessy_cabs/background");
//
//   static Future<void> startBackgroundService() async {
//     try {
//       final result = await _channel.invokeMethod("startService");
//       print("Background service result: $result");
//     } on PlatformException catch (e) {
//       print("Error starting background service: ${e.message}");
//     }
//   }
// }







import 'dart:async';

import 'package:android_intent_plus/android_intent.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:jessy_cabs/Screens/BookingDetails/BookingDetails.dart';
import 'package:jessy_cabs/Screens/CustomerReachedWithouthcl/CustomerReachedWithouthcl.dart';
import 'package:jessy_cabs/Screens/HomeScreen/HomeScreen.dart';
import 'package:jessy_cabs/Screens/PickUpWithoutHcl/PickUpWithoutHcl.dart';
import 'package:jessy_cabs/Screens/TrackingWithOutHcl/TrackingWithOutHcl.dart';
import 'package:jessy_cabs/Screens/VerifyOtp/VerifyOtp.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jessy_cabs/Utils/battery_opt_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:jessy_cabs/Screens/SplashScreen.dart';
import 'package:jessy_cabs/Screens/Home.dart';
import 'package:jessy_cabs/Screens/LoginScreen/Login_Screen.dart';
import 'package:jessy_cabs/Bloc/App_Bloc.dart';
import 'package:jessy_cabs/Networks/Api_Service.dart';// Import your Bloc file
import 'package:jessy_cabs/Utils/AppConstants.dart';
import 'package:provider/provider.dart';
import 'Screens/AuthWrapper.dart';
import 'Screens/CustomerLocationReached/CustomerLocationReached.dart';
import 'Screens/PickupScreen/PickupScreen.dart';
import 'Screens/SignatureEndRide/SignatureEndRide.dart';
import 'Screens/StartingKilometer/StartingKilometer.dart';
import 'Screens/TollParkingUpload/TollParkingUpload.dart';
import 'Screens/TrackingPage/TrackingPage.dart';
import 'Screens/TripDetailsPreview/TripDetailsPreview.dart';
import 'Screens/TripDetailsUpload/TripDetailsUpload.dart';
import 'Screens/network_manager.dart';// Import your Bloc file
import 'package:flutter/services.dart';
import 'package:jessy_cabs/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotifications();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? lastScreen = prefs.getString('last_screen');

  String? tripId = prefs.getString('trip_id');

  String? duty = prefs.getString('duty');

  String? userId = prefs.getString('user_id');

  String? username = prefs.getString('username');

  String? address = prefs.getString('address');

  String? dropLocation = prefs.getString('drop_location'); // 👈 Add this



  // Debug prints

  print('Loaded from SharedPreferences:');

  print('last_screen: $lastScreen');


  runApp(
    ChangeNotifierProvider(
      create: (context) => NetworkManager(),
      child:MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TripSheetValuesBloc(), // No event added yet
          ),
          BlocProvider(
            create: (context) => TripSheetClosedValuesBloc(), // No event added yet
          ),
          BlocProvider(
            create: (context) => DrawerDriverDataBloc(),
          ),
          BlocProvider(
            create: (context) => GettingTripSheetDetailsByUseridBloc(),
          ),

          BlocProvider(
              create: (context) => UpdateTripStatusInTripsheetBloc()
          ),
          BlocProvider(
            create: (context) => StartKmBloc(),
          ),
          BlocProvider(
              create: (context) => TripSignatureBloc()
          ),
          BlocProvider(
              create: (context) => TripSheetDetailsTripIdBloc()
          ),
          BlocProvider(
              create: (context) => TollParkingDetailsBloc()
          ),
          BlocProvider(
              create: (context) => TripBloc()
          ),
          // BlocProvider(create: (context) => FetchTripSheetClosedBloc()),

          BlocProvider(create: (context) => TripSheetBloc()),

          // BlocProvider(create: (context) => FetchFilteredRidesBloc()),
          BlocProvider(create: (context) => FetchFilteredRidesBloc()),
          BlocProvider(create: (context) => ProfileBloc()),
          BlocProvider(create: (context) => TripTrackingDetailsBloc()),
          BlocProvider(create: (context) => GettingClosingKilometerBloc(apiService)),
          BlocProvider(create: (context) => TripClosedTodayBloc(apiService)),

          BlocProvider(create: (context) => DocumentImagesBloc(
              apiService: ApiService(apiUrl: "${AppConstants.baseUrl}"))),

          // BlocProvider<GettingClosingKilometerBloc>(
          //   create: (context) => GettingClosingKilometerBloc(),
          // ),

          //For OTP

          //------------------------------------------------

          BlocProvider(create: (context) => OtpBloc()),

          BlocProvider(create: (context)=>LastOtBloc()),
          BlocProvider(create: (context) => EmailBloc()),
          BlocProvider(create: (context) => SenderInfoBloc()),

          BlocProvider(create: (context)=>SignupBloc()),
          BlocProvider(create: (context)=>LoginViaBloc()),


          // for check trip status is Cancelled to not

          BlocProvider(create: (context)=>CheckTripSheetBloc()),

          BlocProvider(create: (context)=> GetDurationBloc()),
          BlocProvider(create: (context)=> GetOkayBloc()),







          BlocProvider(create: (_) => AuthenticationBloc()..add(AppStarted())), // 👈 Add this


//-------------------------------------------------------------



        ],
        // child: const MyApp(),
        child: MyApp(

          initialRoute: lastScreen,

          tripId: tripId,

          duty: duty,

          userId: userId,

          username: username,

          address: address,

          dropLocation: dropLocation,

        ),
      ),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  final String? initialRoute;

  final String? tripId;

  final String? duty;

  final String? userId;

  final String? username;

  final String? address;

  final String? dropLocation;



  const MyApp({

    super.key,

    required this.initialRoute,

    this.tripId,

    this.duty,

    this.userId,

    this.username,

    this.address,

    this.dropLocation,

  });
  @override
  State<MyApp> createState() => _MyAppState();
}

class TripStatusManager {
  static final TripStatusManager _instance = TripStatusManager._internal();

  factory TripStatusManager() => _instance;

  TripStatusManager._internal();

  Timer? _timer;

  void start(BuildContext context, String tripId) {
    _timer?.cancel(); // Cancel previous timer if running

    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      print("🚀 Dispatching trip check every 4s: $tripId");
      context.read<CheckTripSheetBloc>().add(checkTripEvent(TripId: tripId));
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}



class _MyAppState extends State<MyApp> {


  bool? isOptimized;



  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {



      bool granted = await hasBackgroundLocationPermission();

      if (!granted) {
        openLocationSettings();
      }



      // requestPermissions(); // Request permissions before starting the service
      //
      // startBackgroundService();




    });







    // for check trip status is Canclled or not

    //    WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (widget.tripId != null) {
    //     print(" Dispatching trip ID from main.dart: ${widget.tripId}");

    //     _tripStatusTime = Timer.periodic(Duration(seconds: 4), (timer) {
    //       context.read<CheckTripSheetBloc>().add(
    //             checkTripEvent(TripId: widget.tripId!),
    //           );
    //     });
    //   }
    // });


    //-----------------------------------------------

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   requestPermissions(); // Request permissions before starting the service
    //   BackgroundServiceHelper.startBackgroundService();
    //
    // });
  }

  // Future<void> openBatterySettings() async {
  //   const intent = AndroidIntent(
  //     action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
  //   );
  //   await intent.launch();
  // }
  //
  // void _checkAndPromptOppoPermissions() async {
  //   final deviceInfo = await DeviceInfoPlugin().androidInfo;
  //   final isOppo = deviceInfo.manufacturer?.toLowerCase().contains("oppo") ?? false;
  //
  //   if (isOppo) {
  //     showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //         title: Text("Permission Required"),
  //         content: Text(
  //             "To keep tracking running in background, please allow auto-start & battery ignore for Oppo."),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               openBatterySettings(); // from oppo_helper.dart
  //               Navigator.of(context).pop();
  //             },
  //             child: Text("Open Settings"),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

  @override

  void dispose() {

    super.dispose();

  }


  @override
  Widget build(BuildContext context) {

    // return Sizer(builder: (context, orientation, deviceType) {
    //   return MultiBlocListener(
    //     listeners: [
    //       BlocListener<CheckTripSheetBloc, CheckTripStatusState>
    //       (listener: (contex, state){
    //         if(state is CheckTripStatusSuccess){


    //             if(state.status == "Cancelled"){

    //               print("❌ Trip Cancelled. Redirecting to Home...");

    //               TripStatusManager().stop();

    //               Navigator.pushReplacement(
    //               context,
    //               MaterialPageRoute(builder: (context) => Homescreen(userId: "" ,username: state.name!,
    //               )
    //             )
    //           );
    //             print("Navigated success to home screen");
    //           } else if (state is CheckTripStatusFailed){

    //               print("Tripsheet status is not Cancelled}");

    //           }
    //         }
    //       })
    //     ],
    //     child: MaterialApp(

    //       debugShowCheckedModeBanner: false,
    //       title: "Vehicle Booking App",
    //       theme: ThemeData(primarySwatch: Colors.blue),
    //       // home: const SplashScreen(),
    //       // home: const AuthWrapper(), // 👈 replace SplashScreen
    //       home: _getInitialScreen(

    //         widget.initialRoute,

    //         tripId: widget.tripId,

    //         duty: widget.duty,

    //         userId: widget.userId,

    //         username: widget.username,

    //         address: widget.address,

    //         dropLocation: widget.dropLocation,

    //       ),
    //       routes: {

    //         'home': (context) => const Home(),
    //         // 'home': (context) => const SplashScreen(),
    //         'login': (context) => const Login_Screen(),
    //       },
    //     ),
    //   );
    // });

    return Sizer(builder: (context, orientation, deviceType) {
      return MultiBlocListener(
        listeners: [
          BlocListener<CheckTripSheetBloc, CheckTripStatusState>(
            listener: (context, state) {
              if (state is CheckTripStatusSuccess && state.status == "Cancelled") {
                print(" Trip Cancelled. Redirecting to Home...");
                TripStatusManager().stop();

                navigatorKey.currentState?.pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => Homescreen(
                      userId: "",
                      username: state.name!,
                    ),
                  ),
                );
                print("Navigated success to home screen");
              } else if (state is CheckTripStatusFailed) {
                print("Tripsheet status is not Cancelled");
              }
            },
          ),
        ],
        // child:MaterialApp(
        //   navigatorKey: navigatorKey,
        //   debugShowCheckedModeBanner: false,
        //   title: "Vehicle Booking App",
        //   theme: ThemeData(primarySwatch: Colors.blue),
        //   home: _getInitialScreen(
        //
        //     widget.initialRoute,
        //
        //     tripId: widget.tripId,
        //
        //     duty: widget.duty,
        //
        //     userId: widget.userId,
        //
        //     username: widget.username,
        //
        //     address: widget.address,
        //
        //     dropLocation: widget.dropLocation,
        //
        //   ),
        //   routes: {
        //
        //     'home': (context) => const Home(),
        //     // 'home': (context) => const SplashScreen(),
        //     'login': (context) => const Login_Screen(),
        //   },
        // ),
        child: Builder(
          builder: (context) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: MaterialApp(
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                title: "Vehicle Booking App",
                theme: ThemeData(primarySwatch: Colors.blue),
                home: _getInitialScreen(
                  widget.initialRoute,
                  tripId: widget.tripId,
                  duty: widget.duty,
                  userId: widget.userId,
                  username: widget.username,
                  address: widget.address,
                  dropLocation: widget.dropLocation,
                ),
                routes: {
                  'home': (context) => const Home(),
                  'login': (context) => const Login_Screen(),
                },
              ),
            );
          },
        ),

      );
    });

  }
}

Widget _getInitialScreen(

    String? lastScreen, {

      String? tripId,

      String? duty,

      String? userId,

      String? username,

      String? address,

      String? dropLocation,

    }) {

  switch (lastScreen) {

    case 'FirstHomeScreen':

      return Homescreen(
        userId: userId ?? '',

        username: username ?? '',


      );

    case 'Pickupscreen':

      return Pickupscreen(

        tripId: tripId ?? '',

        address: address ?? '',

      );

    case 'PickupscreenwithoutHcl':

      return PickUpWithoutHcl(

        tripId: tripId ?? '',

        address: address ?? '',

      );

    case 'Bookingdetails':

      return Bookingdetails(

        userId: userId ?? '',

        username: username ?? '',

        tripId: tripId ?? '',

        duty: duty ?? '',

      );

    case 'startingkm':

      return StartingKilometer(

        tripId: tripId ?? '',

        address: address ?? '',

      );

    case 'TrackingPage':

      return Builder(

        builder: (_) => TrackingPage(

          key: UniqueKey(),

          tripId: tripId ?? '',

          address: address ?? '',

        ),

      );

    case 'TrackingWithOutHcl':

      return Builder(

        builder: (_) => TrackingWithOutHcl(

          key: UniqueKey(),

          tripId: tripId ?? '',

          address: address ?? '',

        ),

      );

    case 'customerLocationPage':

      return Builder(

        builder: (_) => Customerlocationreached(

          key: UniqueKey(),

          tripId: tripId ?? '',

        ),

      );
    case 'customerLocationPagetest':

      return Customerlocationreached(tripId: tripId ?? '');

    case 'CustomerReachedWithouthcl':

      return Builder(

        builder: (_) => CustomerReachedWithouthcl(

          key: UniqueKey(),

          tripId: tripId ?? '',

        ),

      );

    case 'signpagescreen':

      return Signatureendride(tripId: tripId ?? '');

    case 'TripDetailsUpload':

      return TripDetailsUpload(tripId: tripId ?? '');

    case 'TripDetailsPreview':

      return TripDetailsPreview(tripId: tripId ?? '');

    case 'TollParkingUpload':

      return TollParkingUpload(tripId: tripId ?? '');

    case  'verifyOtp':

      return VerifyDeBoardimgOtp(tripId: tripId ?? "");


    default:

      return const AuthWrapper(); // Default screen

  }

}


void requestPermissions() async {
  var status = await Permission.location.request();
  if (status.isGranted) {
    // Permissions granted, proceed with location tracking
  } else {
    // Handle the case when permissions are not granted
  }
}
 const platform = MethodChannel('com.example.jessy_cabs/background');

Future<void> openLocationSettings() async {
  try {
    await platform.invokeMethod('openLocationPermissionSettings');
  } catch (e) {
    print("Error opening settings: $e");
  }
}
Future<bool> hasBackgroundLocationPermission() async {
  try {
    final bool granted = await platform.invokeMethod('hasBackgroundLocationPermission');
    return granted;
  } catch (e) {
    print("Error checking background location permission: $e");
    return false;
  }
}

// import 'package:permission_handler/permission_handler.dart';




class BackgroundServiceHelper {
  static const MethodChannel _channel = MethodChannel("com.example.jessy_cabs/background");
  // static const MethodChannel _notificationChannel = MethodChannel("com.example.jessy_cabs/notification");
  //
  // static Future<void> startBackgroundService() async {
  //
  //   try {
  //
  //     final result = await _channel.invokeMethod("startService");
  //
  //     print("Background service result: $result");
  //
  //   } on PlatformException catch (e) {
  //
  //     print("Error starting background service: ${e.message}");
  //
  //   }
  //
  // }

}


// const platform = MethodChannel('com.example.jessy_cabs/background');
Future<void> startBackgroundService() async {
  try {
    await platform.invokeMethod('startBackgroundService');

  } catch (e) {

    print("Error starting service: $e");

  }

}



Future<void> stopBackgroundService() async {

  try {

    await platform.invokeMethod('stopBackgroundService');

  } catch (e) {

    print("Error stopping service: $e");

  }

}

/// Entry point used by the background FlutterEngine from Kotlin
@pragma('vm:entry-point')
void trackingMain() {
  WidgetsFlutterBinding.ensureInitialized();

  const MethodChannel trackingChannel = MethodChannel('com.example.jessy_cabs/tracking');

  trackingChannel.setMethodCallHandler((call) async {
    if (call.method == 'getTotalDistance') {
      // Return mock or cached distance (you can integrate real data here)
      return 0.0;
    }

    return null;
  });

  print("✅ trackingMain isolate started.");
}
