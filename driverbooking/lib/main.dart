// import 'package:jessy_cabs/Screens/HomeScreen/HomeScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
// import 'package:jessy_cabs/Screens/HomeScreen/MapScreen.dart';
// import 'package:jessy_cabs/Screens/IntroScreens/IntroScreenMain.dart';
// import './Screens/SplashScreen.dart';
// import './Screens/Home.dart';
// import './Screens/LoginScreen/Login_Screen.dart';
//
//
// class MyApp extends StatefulWidget {
//   // final String userId;
//   const MyApp({super.key});
//
//   // const MyApp({super.key, required this.userId });
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   // SizerUtil().init(); // Initializes the SizerUtil
//
//   runApp(MyApp());
//   // runApp(MyApp(userId: "12345")); // Pass a sample userId here
//
//
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return Sizer(builder: (context, orientation, deviceType) {
//       return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: "vehiclebooking App",
//         theme: ThemeData(
//           primarySwatch: Colors.blue
//         ),
//         home: SplashScreen(),
//           routes: {
//           'home':(context)=> const Home(),
//             'login': (context) => const Login_Screen(),
//             // 'login': (context) =>  Homescreen(userId: ''),
//             // 'intro_screen': (context) => const Introscreenmain(),
//           },
//
//
//       );
//     });
//   }
// }
//
// //
// // class SplashScreen extends StatefulWidget {
// //   const SplashScreen({super.key});
// //
// //   @override
// //   State<SplashScreen> createState() => _SplashScreenState();
// // }
// //
// // class _SplashScreenState extends State<SplashScreen> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return const Placeholder();
// //   }
// // }



// import 'package:jessy_cabs/Screens/BookingDetails/BookingDetails.dart';
// import 'package:jessy_cabs/Utils/AllImports.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:sizer/sizer.dart';
// import 'package:jessy_cabs/Screens/SplashScreen.dart';
// import 'package:jessy_cabs/Screens/Home.dart';
// import 'package:jessy_cabs/Screens/LoginScreen/Login_Screen.dart';
// import 'package:jessy_cabs/Bloc/App_Bloc.dart';
// import 'package:jessy_cabs/Networks/Api_Service.dart';// Import your Bloc file
// import 'package:jessy_cabs/Utils/AppConstants.dart';
// import 'package:provider/provider.dart';
// import 'Screens/AuthWrapper.dart';
// import 'Screens/network_manager.dart';// Import your Bloc file
// import 'package:flutter/services.dart';
//
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => NetworkManager(),
//       child:MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => TripSheetValuesBloc(), // No event added yet
//         ),
//         BlocProvider(
//           create: (context) => TripSheetClosedValuesBloc(), // No event added yet
//         ),
//         BlocProvider(
//             create: (context) => DrawerDriverDataBloc(),
//         ),
//         BlocProvider(
//           create: (context) => GettingTripSheetDetailsByUseridBloc(),
//         ),
//
//         BlocProvider(
//             create: (context) => UpdateTripStatusInTripsheetBloc()
//         ),
//         BlocProvider(
//           create: (context) => StartKmBloc(),
//         ),
//         BlocProvider(
//             create: (context) => TripSignatureBloc()
//         ),
//         BlocProvider(
//             create: (context) => TripSheetDetailsTripIdBloc()
//         ),
//         BlocProvider(
//             create: (context) => TollParkingDetailsBloc()
//         ),
//         BlocProvider(
//             create: (context) => TripBloc()
//         ),
//         // BlocProvider(create: (context) => FetchTripSheetClosedBloc()),
//
//         BlocProvider(create: (context) => TripSheetBloc()),
//
//         // BlocProvider(create: (context) => FetchFilteredRidesBloc()),
//         BlocProvider(create: (context) => FetchFilteredRidesBloc()),
//         BlocProvider(create: (context) => ProfileBloc()),
//         BlocProvider(create: (context) => TripTrackingDetailsBloc()),
//         BlocProvider(create: (context) => GettingClosingKilometerBloc(apiService)),
//         BlocProvider(create: (context) => TripClosedTodayBloc(apiService)),
//
//         BlocProvider(create: (context) => DocumentImagesBloc(
//             apiService: ApiService(apiUrl: "${AppConstants.baseUrl}"))),
//
//         // BlocProvider<GettingClosingKilometerBloc>(
//         //   create: (context) => GettingClosingKilometerBloc(),
//         // ),
//
//         BlocProvider(create: (_) => AuthenticationBloc()..add(AppStarted())), // 👈 Add this
//
//
//       ],
//       child: const MyApp(),
//     ),
//   ),
//   );
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//        requestPermissions(); // Request permissions before starting the service
//       BackgroundServiceHelper.startBackgroundService();
//     });
//   }
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
//         home: const AuthWrapper(), // 👈 replace SplashScreen
//
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



//working


import 'package:jessy_cabs/Screens/BookingDetails/BookingDetails.dart';
import 'package:jessy_cabs/Screens/CustomerReachedWithouthcl/CustomerReachedWithouthcl.dart';
import 'package:jessy_cabs/Screens/HomeScreen/HomeScreen.dart';
import 'package:jessy_cabs/Screens/PickUpWithoutHcl/PickUpWithoutHcl.dart';
import 'package:jessy_cabs/Screens/TrackingWithOutHcl/TrackingWithOutHcl.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  print('trip_id: $tripId');

  print('duty: $duty');

  print('user_id: $userId');

  print('username: $username');

  print('address: $address');

  print('destination: $dropLocation');

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

class _MyAppState extends State<MyApp> {

  bool? isOptimized;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      requestPermissions(); // Request permissions before starting the service
      BackgroundServiceHelper.startBackgroundService();
      startBackgroundService();

    });
  }
  @override

  void dispose() {

    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(

        debugShowCheckedModeBanner: false,
        title: "Vehicle Booking App",
        theme: ThemeData(primarySwatch: Colors.blue),
        // home: const SplashScreen(),
        // home: const AuthWrapper(), // 👈 replace SplashScreen
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
          // 'home': (context) => const SplashScreen(),
          'login': (context) => const Login_Screen(),
        },
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

      String? dropLocation, // 👈 Add this

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

class BackgroundServiceHelper {
  static const MethodChannel _channel = MethodChannel("com.example.jessy_cabs/background");
  static const MethodChannel _notificationChannel = MethodChannel("com.example.jessy_cabs/notification");
  static Future<void> startBackgroundService() async {
    try {
      final result = await _channel.invokeMethod("startService");
      print("Background service result: $result");
    } on PlatformException catch (e) {
      print("Error starting background service: ${e.message}");
    }
  }
}



const platform = MethodChannel('com.example.jessy_cabs/background');

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

