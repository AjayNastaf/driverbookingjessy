import 'package:flutter/material.dart';
import './Home.dart';
import './HomeScreen/MapScreen.dart';
import './loading_screen.dart';
import '../Utils/AllImports.dart';





class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    // Simulate a loading process, such as fetching data
    await Future.delayed(const Duration(seconds: 3), () {});

    // Navigate to the login screen after the loading is done
    Navigator.pushReplacementNamed(context, 'login');
    // Navigator.pushReplacementNamed(context, 'intro_screen');
  }


  @override
  Widget build(BuildContext context) {
    // return  MapScreen();
    return LoadingScreen();
  }
}
