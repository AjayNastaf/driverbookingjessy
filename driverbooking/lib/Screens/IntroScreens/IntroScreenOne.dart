import 'package:flutter/material.dart';
import 'package:jessy_cabs/Utils/AppConstants.dart';

class IntroScreenOne extends StatefulWidget {
  const IntroScreenOne({super.key});

  @override
  State<IntroScreenOne> createState() => _IntroScreenOneState();
}

class _IntroScreenOneState extends State<IntroScreenOne> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppConstants.intro_one), // Replace with your asset
          fit: BoxFit.contain, // Adjust the fit to your preference
          alignment: Alignment.center, // Adjust alignment
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment(0, 0.5),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Shrinks to fit content
                children: [
                  Text(
                    'Choose Location',
                    style: TextStyle(
                      fontSize: 28, // Font size
                      fontWeight: FontWeight.bold, // Bold text
                      color: Colors.black, // Text color
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0), // Space between the two texts
                  Text(
                    'Easily select your pickup and drop-off points.', // Second sentence
                    style: TextStyle(
                      fontSize: 16, // Slightly smaller font
                      fontWeight: FontWeight.normal, // Normal text weight
                      color: Colors.black87, // Slightly lighter black
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
