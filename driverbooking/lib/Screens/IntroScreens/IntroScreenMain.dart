import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:jessy_cabs/Screens/HomeScreen/HomeScreen.dart';
import 'package:jessy_cabs/Screens/IntroScreens/IntroScreenOne.dart';
import 'package:jessy_cabs/Screens/IntroScreens/IntroScreenThree.dart';
import 'package:jessy_cabs/Screens/IntroScreens/IntroScreenTwo.dart';
import 'package:jessy_cabs/Screens/LoginScreen/Login_Screen.dart';

class Introscreenmain extends StatefulWidget {
  final String userId;
  final String username; // Add username as a required parameter
  const Introscreenmain({
    super.key,
    required this.userId,
    required this.username,


  });

  @override
  State<Introscreenmain> createState() => _IntroscreenmainState();
}

class _IntroscreenmainState extends State<Introscreenmain> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_pageController.page != null && _pageController.page! < 2) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to the Login page once the last page is reached
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homescreen(
            userId: widget.userId,
          username: widget.username,
        )), // Change to your login screen
      );
    }
  }

  void _goToPreviousPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Homescreen(
          userId: widget.userId,
        username: widget.username,
      )), // Change to your login screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: [
              IntroScreenOne(),
              IntroScreenTwo(),
              IntroScreenThree()
            ],
          ),
          Container(
            alignment: Alignment(0, 0.7),
            child: SmoothPageIndicator(controller: _pageController, count: 3),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            child: TextButton(
              onPressed: _goToPreviousPage,
              child: Text(
                'Skip',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 20,
            child: IconButton(
              onPressed: _goToNextPage,
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              ),
              iconSize: 30.0,
            ),
          ),
        ],
      ),
    );
  }
}
