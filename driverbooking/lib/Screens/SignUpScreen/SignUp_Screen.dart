// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:jessy_cabs/Screens/LoginScreen/Login_Screen.dart';
// import 'package:jessy_cabs/Utils/AllImports.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_bloc/flutter_bloc.dart'; // Assuming you're using Bloc

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   final _formKey = GlobalKey<FormState>();

//   bool changeState = true;
//   String? userId;
//   String? otp;

//   String? number;
//   String? name;
//   String email;


//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();

//   final List<TextEditingController> otpControllers =
//       List.generate(4, (_) => TextEditingController());
//   final List<FocusNode> otpFocusNodes = List.generate(4, (_) => FocusNode());

//   Timer? _timer;
//   int _remainingSeconds = 120;
//   bool _showResendButton = false;



//   void _startOtpTimer() {
//     _remainingSeconds = 120;
//     _showResendButton = false;

//     _timer?.cancel();
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_remainingSeconds == 0) {
//         setState(() {
//           _showResendButton = true;
//         });
//         timer.cancel();
//       } else {
//         setState(() {
//           _remainingSeconds--;
//         });
//       }
//     });
//   }

//   void _saveLoginDetails(String username, String userId) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('username', username);
//     await prefs.setString('userId', userId);
//   }


//   @override
//   void dispose() {
//     _timer?.cancel();
//     for (var controller in otpControllers) {
//       controller.dispose();
//     }
//     for (var node in otpFocusNodes) {
//       node.dispose();
//     }
//     _emailController.dispose();
//     _phoneController.dispose();
//     _usernameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: MultiBlocListener(
//         listeners: [
//           BlocListener<SignupBloc, SignupState>(
//             listener: (context, state) {
//               if (state is OtpSentForSignup) {
//                 setState(() {
//                   changeState = false;
//                   userId = state.userId;
//                   otp = state.otp;
//                 });
//                 _startOtpTimer();
//               }
//             },
//           ),
//            BlocListener<SignupBloc, SignupState>(
//             listener: (context, state) {
//               if (state is SignUpSuccess) {
//                 setState(() {
//                   changeState = false;
//                   otp = state.otp;
//                 });
//                 _startOtpTimer();
//               }
//             },
//           ),

//         ],
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: Container(
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage(AppConstants.signup),
//                     fit: BoxFit.contain,
//                     alignment: Alignment.topCenter,
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: SingleChildScrollView(
//                 child: Container(
//                   constraints: BoxConstraints(
//                     minHeight: 350.0,
//                     maxHeight: MediaQuery.of(context).size.height * 0.6,
//                   ),
//                   color: Colors.white.withOpacity(0.8),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: 10.0),
//                           Text(
//                             "Enter Your details to continue.",
//                             style:
//                                 TextStyle(fontSize: 20.0, color: AppTheme.grey1),
//                           ),
//                           SizedBox(height: 10.0),
//                           if (changeState) ...[
//                             TextFormField(
//                               controller: _usernameController,
//                               decoration: InputDecoration(
//                                 labelText: 'Name',
//                                 border: OutlineInputBorder(),
//                                 prefixIcon: Icon(Icons.verified_user),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your username';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(height: 16.0),
//                             TextFormField(
//                               controller: _emailController,
//                               decoration: InputDecoration(
//                                 labelText: 'Email',
//                                 border: OutlineInputBorder(),
//                                 prefixIcon: Icon(Icons.email),
//                               ),
//                             ),
//                             SizedBox(height: 16.0),
//                             TextFormField(
//                               controller: _phoneController,
//                               decoration: InputDecoration(
//                                 labelText: 'Phone',
//                                 border: OutlineInputBorder(),
//                                 prefixIcon: Icon(Icons.phone),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your phone number';
//                                 } else if (value.length != 10) {
//                                   return 'Please enter a valid 10-digit number';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ] else ...[
//                             SizedBox(height: 12.0),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: List.generate(4, (index) {
//                                 return SizedBox(
//                                   width: 50,
//                                   child: TextField(
//                                     controller: otpControllers[index],
//                                     focusNode: otpFocusNodes[index],
//                                     maxLength: 1,
//                                     textAlign: TextAlign.center,
//                                     keyboardType: TextInputType.number,
//                                     decoration: InputDecoration(
//                                       counterText: '',
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                     ),
//                                     onChanged: (value) {
//                                       if (value.isNotEmpty && index < 3) {
//                                         FocusScope.of(context).requestFocus(
//                                             otpFocusNodes[index + 1]);
//                                       } else if (value.isEmpty && index > 0) {
//                                         FocusScope.of(context).requestFocus(
//                                             otpFocusNodes[index - 1]);
//                                       }
//                                     },
//                                   ),
//                                 );
//                               }),
//                             ),
//                             SizedBox(height: 12),
//                             if (!_showResendButton)
//                               Center(
//                                 child: Text(
//                                   'Resend OTP in $_remainingSeconds seconds',
//                                   style: TextStyle(color: Colors.grey[700]),
//                                 ),
//                               )
//                             else
//                               Center(
//                                 child: TextButton(
//                                   onPressed: () {
//                                     // Resend OTP logic here
//                                     _startOtpTimer();
//                                   },
//                                   child: Text("Resend OTP"),
//                                 ),
//                               )
//                           ],
//                           SizedBox(height: 20.0),
//                           ElevatedButton(
//                             onPressed: () {
//                               if (changeState) {
//                                 if (_formKey.currentState!.validate()) {
//                                    name = _usernameController.text;
//                                   email = _emailController.text;
//                                   number = _phoneController.text;
//                                   // Trigger send OTP event here
//                                 }
//                               } else {
//                                 final enteredOtp = otpControllers
//                                     .map((c) => c.text)
//                                     .join();
//                                 print("Entered OTP: $enteredOtp");
//                               }
//                             },
//                             child: Text(
//                               changeState ? 'Send OTP' : 'Verify OTP',
//                               style: TextStyle(
//                                   fontSize: 23.0, color: AppTheme.white1),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               minimumSize: Size(double.infinity, 50),
//                               backgroundColor: AppTheme.Navblue1,
//                             ),
//                           ),
//                           SizedBox(height: 12.0),
//                           Center(
//                             child: TextButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => Login_Screen()));
//                               },
//                               child: Text(
//                                 "Already have an account? Sign In",
//                                 style: TextStyle(
//                                   fontSize: 14.0,
//                                   color: AppTheme.Navblue1,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jessy_cabs/Screens/HomeScreen/HomeScreen.dart';
import 'package:jessy_cabs/Screens/LoginScreen/Login_Screen.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Assuming you're using Bloc

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  bool changeState = true;
  String? userId;
  String? otp;

  String? number;
  String? name;
  String? email;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final List<TextEditingController> otpControllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> otpFocusNodes = List.generate(4, (_) => FocusNode());

  Timer? _timer;
  int _remainingSeconds = 120;
  bool _showResendButton = false;

  void _startOtpTimer() {
    _remainingSeconds = 120;
    _showResendButton = false;

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        setState(() {
          _showResendButton = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void _saveLoginDetails(String username, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('userId', userId);
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    _emailController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MultiBlocListener(
        listeners: [
          BlocListener<SignupBloc, SignupState>(
            listener: (context, state) {
              if (state is OtpSentForSignup) {
                setState(() {
                  changeState = false;
                  userId = state.userId;
                  otp = state.otp;
                });
                _startOtpTimer();
              }
            },
          ),
          BlocListener<SignupBloc, SignupState>(
            listener: (context, state) {
              if (state is SignUpSuccess) {
                setState(() {
                  changeState = false;
                  otp = state.otp;
                });
                _startOtpTimer();
              }
            },
          ),
        ],
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppConstants.signup),
                    fit: BoxFit.contain,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 350.0,
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  color: Colors.white.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.0),
                          Text(
                            "Enter Your details to continue.",
                            style: TextStyle(
                                fontSize: 20.0, color: AppTheme.grey1),
                          ),
                          SizedBox(height: 10.0),
                          if (changeState) ...[
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.verified_user),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.email),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                labelText: 'Phone',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.phone),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                } else if (value.length != 10) {
                                  return 'Please enter a valid 10-digit number';
                                }
                                return null;
                              },
                            ),
                          ] else ...[
                            SizedBox(height: 12.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(4, (index) {
                                return SizedBox(
                                  width: 50,
                                  child: TextField(
                                    controller: otpControllers[index],
                                    focusNode: otpFocusNodes[index],
                                    maxLength: 1,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      counterText: '',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      if (value.isNotEmpty && index < 3) {
                                        FocusScope.of(context).requestFocus(
                                            otpFocusNodes[index + 1]);
                                      } else if (value.isEmpty && index > 0) {
                                        FocusScope.of(context).requestFocus(
                                            otpFocusNodes[index - 1]);
                                      }
                                    },
                                  ),
                                );
                              }),
                            ),
                            SizedBox(height: 12),
                            if (!_showResendButton)
                              Center(
                                child: Text(
                                  'Resend OTP in $_remainingSeconds seconds',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              )
                            else
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    if (number != null && number!.isNotEmpty) {
                                      print('second dispatch completed');
                                      BlocProvider.of<SignupBloc>(context).add(
                                          OtpverificationRequested(phone: number!)
                                      );
                                      _startOtpTimer();
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text("Phone number missing. Please try again.")
                                          )
                                      );
                                    }
                                  },
                                  child: Text("Resend OTP"),
                                ),
                              )
                          ],
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              if (changeState) {
                                if (_formKey.currentState!.validate()) {
                                  name = _usernameController.text;
                                  email = _emailController.text;
                                  number = _phoneController.text;

                                  print('first dispatch completed');
                                  BlocProvider.of<SignupBloc>(context).add(
                                      SignupRequested(
                                          name: name!,
                                          email: email!,
                                          phone: number!
                                      )
                                  );
                                }
                              } else {
                                final enteredOtp = otpControllers.map((c) => c.text).join();

                                if (enteredOtp.length < 4) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Please enter the full 4-digit OTP")),
                                  );
                                  return;
                                }

                                if (enteredOtp != otp) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Incorrect OTP. Please try again")),
                                  );
                                  return;
                                }
                                if(enteredOtp == otp){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Homescreen(userId: "", username: name!)));
                                }

                                // BlocProvider.of<SignupBloc>(context).add(
                                //   OtpverificationRequested(phone: number!)
                                // );
                              }
                            },

                            child: Text(
                              changeState ? 'Send OTP' : 'Verify OTP',
                              style: TextStyle(
                                  fontSize: 23.0, color: AppTheme.white1),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              backgroundColor: AppTheme.Navblue1,
                            ),
                          ),
                          SizedBox(height: 12.0),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>Login_Screen()));
                              },
                              child: Text(
                                "Already have an account? Sign In",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: AppTheme.Navblue1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
