// import 'package:driverbooking/Screens/HomeScreen/HomeScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
// import 'package:driverbooking/Screens/HomeScreen/MapScreen.dart';
// import 'package:driverbooking/Screens/IntroScreens/IntroScreenMain.dart';
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



import 'package:driverbooking/Screens/BookingDetails/BookingDetails.dart';
import 'package:driverbooking/Utils/AllImports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:driverbooking/Screens/SplashScreen.dart';
import 'package:driverbooking/Screens/Home.dart';
import 'package:driverbooking/Screens/LoginScreen/Login_Screen.dart';
import 'package:driverbooking/Bloc/App_Bloc.dart';
import 'package:driverbooking/Networks/Api_Service.dart';// Import your Bloc file
import 'package:driverbooking/Utils/AppConstants.dart';// Import your Bloc file

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiBlocProvider(
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
        BlocProvider(create: (context) => SaveLocationBloc()),




      ],
      child: const MyApp(),
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
        home: const SplashScreen(),
        routes: {
          'home': (context) => const Home(),
          'login': (context) => const Login_Screen(),
        },
      );
    });
  }
}
