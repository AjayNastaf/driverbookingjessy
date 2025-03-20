import 'package:flutter/material.dart';
import '../Utils/AppConstants.dart'; // Ensure this imports the correct constants file.

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: false); // Smooth animation loop.

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
            FadeTransition(
              opacity: _animation,
              child: ScaleTransition(
                scale: _animation,
                child: Image.asset(
                  // AppConstants.nastafLogo,
                  AppConstants.jessyLogo,
                  // AppConstants.jessyLogonav,
                  width: 250, // Adjusted for better aesthetics.
                  height: 250,
                ),
              ),
            ),
            // const SizedBox(height: 30),
            // const Text(
            //   "Welcome to Nastaf",
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black54,
            //   ),
            // ),
            // const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Colors.green, // Adjusted to match theme colors.
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
