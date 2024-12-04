import 'package:driverbooking/Screens/HomeScreen/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:driverbooking/Screens/HomeScreen/MapScreen.dart';
import 'package:driverbooking/Screens/IntroScreens/IntroScreenMain.dart';
import './Screens/SplashScreen.dart';
import './Screens/Home.dart';
import './Screens/LoginScreen/Login_Screen.dart';


class MyApp extends StatefulWidget {
  final String userId;
  // const MyApp({super.key});

  const MyApp({super.key, required this.userId });

  @override
  State<MyApp> createState() => _MyAppState();
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SizerUtil().init(); // Initializes the SizerUtil

  // runApp(MyApp());
  runApp(MyApp(userId: "12345")); // Pass a sample userId here


}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "vehiclebooking App",
        theme: ThemeData(
          primarySwatch: Colors.blue
        ),
        home: SplashScreen(),
          routes: {
          'home':(context)=> const Home(),
            // 'login': (context) => const Login_Screen(),
            'login': (context) =>  Homescreen(userId: widget.userId),
            'intro_screen': (context) => const Introscreenmain(),
          },


      );
    });
  }
}

//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
