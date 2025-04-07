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



import 'package:jessy_cabs/Screens/BookingDetails/BookingDetails.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:jessy_cabs/Screens/SplashScreen.dart';
import 'package:jessy_cabs/Screens/Home.dart';
import 'package:jessy_cabs/Screens/LoginScreen/Login_Screen.dart';
import 'package:jessy_cabs/Bloc/App_Bloc.dart';
import 'package:jessy_cabs/Networks/Api_Service.dart';// Import your Bloc file
import 'package:jessy_cabs/Utils/AppConstants.dart';
import 'package:provider/provider.dart';
import 'Screens/AuthWrapper.dart';
import 'Screens/network_manager.dart';// Import your Bloc file

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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

        BlocProvider(create: (_) => AuthenticationBloc()..add(AppStarted())), // 👈 Add this


      ],
      child: const MyApp(),
    ),
  ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Vehicle Booking App",
        theme: ThemeData(primarySwatch: Colors.blue),
        // home: const SplashScreen(),
        home: const AuthWrapper(), // 👈 replace SplashScreen

        routes: {

          'home': (context) => const Home(),
          // 'home': (context) => const SplashScreen(),
          'login': (context) => const Login_Screen(),
        },
      );
    });
  }
}
