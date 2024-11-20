import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
// import 'package:vehiclebooking/Utils/AppConstants.dart';
import '../Utils/AppConstants.dart';
import './LoginScreen/Login_Screen.dart';

class loadingscreen extends StatefulWidget {
  const loadingscreen({super.key});

  @override
  State<loadingscreen> createState() => _loadingscreenState();
}

class _loadingscreenState extends State<loadingscreen>

  with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
  super.initState();

  _controller = AnimationController(
  duration: const Duration(seconds: 3),
  vsync: this,
  )..repeat(reverse: true);

  _animation = CurvedAnimation(
  parent: _controller,
  curve: Curves.easeInOut,
  );
  }

  @override
  void dispose() {
  _controller.dispose();
  super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: Image.asset(
                AppConstants.nastafLogo,
                // Replace with your logo's asset path
                width: 350, // Adjust size as needed
                height: 350,
              ),
            ),
            const SizedBox(height: 20),
            // const CircularProgressIndicator(),
          ],
        ),
      ),
    );
    // );
  }
}
