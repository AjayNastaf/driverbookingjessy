//
//
// import 'package:flutter/material.dart';
// import 'package:jessy_cabs/Screens/TripDetailsUpload/TripDetailsUpload.dart';
// import 'package:jessy_cabs/Utils/AllImports.dart';
// import 'package:lottie/lottie.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class Notificationscreen extends StatefulWidget {
//   final String tripId;
//   const Notificationscreen({super.key, required this.tripId});
//
//   @override
//   State<Notificationscreen> createState() => _NotificationscreenState();
// }
//
// class _NotificationscreenState extends State<Notificationscreen> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//
//   late AnimationController _textController;
//   late Animation<double> _textOpacity;
//   bool _visible = false;
//
//   String? otp;
//
//
//   List<TextEditingController> otpControllers = List.generate(4, (_) => TextEditingController());
//   List<FocusNode> otpFocusNodes = List.generate(4, (_) => FocusNode());
//
//   bool isOtpComplete() {
//     return otpControllers.every((controller) => controller.text.trim().isNotEmpty);
//   }
//   bool showCheckmark = false;
//   bool hideButton = false;
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       setState(() {
//         _visible = true;
//       });
//     });
//     // Text animation for pulsating effect
//     _textController = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );
//
//     _textOpacity = Tween<double>(begin: 0.6, end: 1.0).animate(
//       CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
//     );
//
//     _textController.repeat(reverse: true);  // Start the text animation
//   }
//
//   @override
//   void dispose() {
//     _textController.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('OTP Verification', style: TextStyle(color: Colors.white)),
//         backgroundColor: AppTheme.Navblue1,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Flexible(
//             child: SizedBox(
//               height: MediaQuery.of(context).size.height * 0.6,
//               width: MediaQuery.of(context).size.width,
//               child: Lottie.asset(
//                 'assets/animations/otpverify.json',
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//           // FadeTransition(
//           //   opacity: _textOpacity,
//           //   child: Text(
//           //     'Lets Start the Ride',
//           //     style: GoogleFonts.roboto(
//           //       fontSize: 28,
//           //       color: Colors.black,
//           //       fontWeight: FontWeight.bold,
//           //     ),
//           //     textAlign: TextAlign.center,
//           //   ),
//           // ),
//           // const SizedBox(height: 8),
//           //
//           AnimatedOpacity(
//             opacity: _visible ? 1.0 : 0.0,
//             duration: const Duration(seconds: 2),
//             child: Text(
//               'Lets  End the Ride',
//               style: GoogleFonts.roboto(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           Text(
//             'We Hope our customer had a great ride!',
//             style: GoogleFonts.roboto(
//               fontSize: 18,
//               color: Colors.black,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 10,),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: List.generate(4, (index) {
//               return SizedBox(
//                 width: 50,
//                 child: TextField(
//                   controller: otpControllers[index],
//                   focusNode: otpFocusNodes[index],
//                   maxLength: 1,
//                   textAlign: TextAlign.center,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     counterText: '',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12), // Curved edges
//                     ),
//                   ),
//                   onChanged: (value) {
//                     if (value.isNotEmpty && index < 3) {
//                       FocusScope.of(context).requestFocus(otpFocusNodes[index + 1]);
//                     } else if (value.isEmpty && index > 0) {
//                       FocusScope.of(context).requestFocus(otpFocusNodes[index - 1]);
//                     }
//                   },
//                 ),
//               );
//             }),
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             width: 400,
//             child: ElevatedButton(
//
//               onPressed: () {
//                 if (!isOtpComplete()) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("Please fill all OTP fields")),
//                   );
//                   return;
//                 }
//                 // _showEndRideConfirmationDialog(context);
//                 //  _isLoading ? null : () => _handleSubmit(context),
//
//                 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>TripDetailsUpload(tripId: widget.tripId,)),(route)=>false);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(
//                 'Verify OTP',
//                 style: TextStyle(fontSize: 20.0, color: Colors.white),
//               ),
//             ),
//           ),
//
//
//
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:jessy_cabs/Screens/TripDetailsUpload/TripDetailsUpload.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class VerifyDeBoardimgOtp extends StatefulWidget {
  final String tripId;

  const VerifyDeBoardimgOtp({super.key, required this.tripId});

  @override
  State<VerifyDeBoardimgOtp> createState() => _VerifyDeBoardimgOtpState();
}

class _VerifyDeBoardimgOtpState extends State<VerifyDeBoardimgOtp> with SingleTickerProviderStateMixin{
  late AnimationController _controller;

  late AnimationController _textController;
  late Animation<double> _textOpacity;
  bool _visible = false;



  int _otpTimerCount = 5; // 5 minutes in seconds
  late Timer _otpResendTimer;

  String? guestMobileNo;

// Add this method to your state class


  void startOtpResendTimer() {
    _otpResendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_otpTimerCount > 0) {
        setState(() {
          _otpTimerCount--;
        });
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>TripDetailsUpload(tripId: widget.tripId,)),(route)=>false);
        timer.cancel();
      }
    });
  }

  List<TextEditingController> otpControllers = List.generate(4, (_) => TextEditingController());
  List<FocusNode> otpFocusNodes = List.generate(4, (_) => FocusNode());

  bool isOtpComplete() {
    return otpControllers.every((controller) => controller.text.trim().isNotEmpty);
  }
  String getEnteredOtp() {
    return otpControllers.map((c) => c.text.trim()).join();
  }

  bool isOtpValid() {
    return getEnteredOtp() == otp;
  }

  bool showCheckmark = true;
  bool hideButton = true;
  String? otp;


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _visible = true;
      });
    });
    _loadTripSheetDetailsByTripId();
    startOtpResendTimer();
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


  Future<void> _loadTripSheetDetailsByTripId() async {
    try {
      // Fetch trip details from the API

      final tripDetails = await ApiService.fetchTripDetails(widget.tripId);

      print('Trip details fetchedd: $tripDetails');

      if (tripDetails != null) {

        var guestNumber = tripDetails['guestmobileno'].toString();

        print("Trip guest number ${guestNumber}");

        setState(() {
          guestMobileNo = guestNumber;
        });

      } else {
        print('No trip details found.');
      }
    } catch (e) {
      print('Error loading trip details: $e');
    }
  }


  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
    _otpResendTimer.cancel();

  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LastOtBloc, OtpVerifyState>(
            listener: (context, state){
              if(state is LastOtpSuccess){
                otp = state.otp;
                print("Otp received in verifyotppage${state.otp}");
              }
            }),
        BlocListener<LoginViaBloc, LoginViaState>(
            listener: (context, state){
              if(state is LoginViaSuccess){
                setState(() {
                  otp = state.otp;
                  print('resend otp received in verifyotp ${otp}');
                });
              }
            })
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('OTP Verification', style: TextStyle(color: Colors.white)),
          backgroundColor: AppTheme.Navblue1,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                child: Lottie.asset(
                  'assets/animations/otpverify.json',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // FadeTransition(
            //   opacity: _textOpacity,
            //   child: Text(
            //     'Lets Start the Ride',
            //     style: GoogleFonts.roboto(
            //       fontSize: 28,
            //       color: Colors.black,
            //       fontWeight: FontWeight.bold,
            //     ),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            // const SizedBox(height: 8),
            //
            AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(seconds: 2),
              child: Text(
                'Lets  End the Ride',
                style: GoogleFonts.roboto(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              'We Hope our customer had a great ride!',
              style: GoogleFonts.roboto(
                fontSize: 18,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 35,
                  child: TextField(
                    controller: otpControllers[index],
                    focusNode: otpFocusNodes[index],
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Curved edges
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        FocusScope.of(context).requestFocus(otpFocusNodes[index + 1]);
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).requestFocus(otpFocusNodes[index - 1]);
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${(_otpTimerCount ~/ 60).toString().padLeft(2, '0')}:${(_otpTimerCount % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 14, color: const Color.fromARGB(255, 137, 136, 136)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(

                onPressed: () {
                  if (!isOtpComplete()) {
                    showFailureSnackBar(context, 'Please fill all OTP fields');

                    return;
                  }
                  if (isOtpValid()) {
                    setState(() {
                      showCheckmark = false;
                      hideButton = false;
                    });

                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>TripDetailsUpload(tripId: widget.tripId,)),(route)=>false);

                  } else {
                    showFailureSnackBar(context, 'Invalid OTP ❌');
                  }
                  // _showEndRideConfirmationDialog(context);
                  //  _isLoading ? null : () => _handleSubmit(context),

                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>TripDetailsUpload(tripId: widget.tripId,)),(route)=>false);

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Verify OTP',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),


            SizedBox(height: 15,),

          ],
        ),
      ),
    );
  }
}

