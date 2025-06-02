import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../NoInternetBanner/NoInternetBanner.dart';
import '../network_manager.dart';



class AnimatedPageTracking extends StatefulWidget {



  const AnimatedPageTracking({super.key});

  @override
  State<AnimatedPageTracking> createState() => _AnimatedPageTrackingState();
}

class _AnimatedPageTrackingState extends State<AnimatedPageTracking> with SingleTickerProviderStateMixin {
  late AnimationController _textController;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();

    // Text animation for pulsating effect
    _textController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _textOpacity = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    _textController.repeat(reverse: true);  // Start the text animation
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isConnected = Provider.of<NetworkManager>(context).isConnected;

    return Stack(
      children: [
        Positioned(
          top: 15,
          left: 0,
          right: 0,
          child: NoInternetBanner(isConnected: isConnected),
        ),
        // Full-Screen Background
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // Centered Animated Cab
// Centered Animated Cab
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Constrained Lottie Animation
              Flexible(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,  // Adjusted height
                  width: MediaQuery.of(context).size.width,
                  child: Lottie.asset(
                    'assets/animations/Animationtrack.json',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Animated Text
              FadeTransition(
                opacity: _textOpacity,
                child: Text(
                  'Lets Start the Ride',
                  style: GoogleFonts.roboto(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'Make them to enjoy the ride!',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
