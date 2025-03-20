// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:jessy_cabs/Screens/LoginScreen/Login_Screen.dart';
// import 'package:jessy_cabs/Screens/OtpScreen/OtpScreen.dart';
// import 'package:jessy_cabs/Utils/AppConstants.dart';
// import '../../Utils/AppTheme.dart';
// import 'dart:math';
// import 'package:jessy_cabs/Networks/Api_Service.dart';
// import 'package:jessy_cabs/Utils/AllImports.dart';
// import 'package:jessy_cabs/Bloc/AppBloc_Events.dart';
// import 'package:jessy_cabs/Bloc/AppBloc_State.dart';
// import 'package:jessy_cabs/Bloc/App_Bloc.dart';
//
// class Register extends StatefulWidget {
//   const Register({super.key});
//
//   @override
//   State<Register> createState() => _RegisterState();
// }
//
// class _RegisterState extends State<Register> {
//   final _RegisterformKey = GlobalKey<FormState>();
//   final _usernameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _passwordicon = true;
//
//   void passwordiconChange() {
//     setState(() {
//       _passwordicon = !_passwordicon;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//         create: (_)=> RegisterBloc(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Register"),
//         ),
//         body: BlocListener<RegisterBloc, RegisterState>(
//           listener: (context, state) {
//             if (state is RegisterSuccess) {
//               // ScaffoldMessenger.of(context).showSnackBar(
//               //   SnackBar(content: Text('Registration successful, OTP sent to your email.')),
//               // );
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => OtpScreen(email: _emailController.text)),
//               );
//               showSuccessSnackBar(context, 'Registration successful, OTP sent to your email.');
//             } else if (state is RegisterFailure) {
//               showAlertDialog(context, state.error);
//             }
//             else if (state is RequestOtpFailure) {
//               // ScaffoldMessenger.of(context).showSnackBar(
//               //   SnackBar(content: Text('Username already exist, Please login.')),
//               // );
//               showFailureSnackBar(context, 'Username already exist, Please login.');
//             }
//           },
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(18.0),
//               child: Form(
//                 key: _RegisterformKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       AppConstants.registration,
//                       width: 400.0,
//                       height: 400.0,
//                     ),
//                     TextFormField(
//                       controller: _usernameController,
//                       decoration: InputDecoration(
//                         labelText: "Username",
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.person_2),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Username is required.';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 10.0),
//                     TextFormField(
//                       controller: _emailController,
//                       decoration: InputDecoration(
//                         labelText: "Email",
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.mail),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value)) {
//                           return 'Enter a valid email address.';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 10.0),
//                     TextFormField(
//                       controller: _phoneController,
//                       decoration: InputDecoration(
//                         labelText: "Phone Number",
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.phone),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Phone number cannot be empty.';
//                         } else if (!RegExp(r'^\d+$').hasMatch(value)) {
//                           return 'Enter a valid phone number with only numbers.';
//                         } else if (value.length < 10) {
//                           return 'Phone number must be at least 10 digits.';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 10.0),
//                     TextFormField(
//                       controller: _passwordController,
//                       obscureText: _passwordicon,
//                       decoration: InputDecoration(
//                         labelText: "Password",
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.lock),
//                         suffixIcon: IconButton(
//                           onPressed: passwordiconChange,
//                           icon: Icon(_passwordicon ? Icons.visibility : Icons.visibility_off),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty || value.length < 6) {
//                           return 'Password must be at least 6 characters long.';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 10.0),
//                     SizedBox(
//                       width: 200.0,
//                       child: BlocBuilder<RegisterBloc, RegisterState>(
//                         builder: (context, state) {
//                           return ElevatedButton(
//                             onPressed: state is RegisterLoading
//                                 ? null
//                                 : () {
//                               if (_RegisterformKey.currentState?.validate() ?? false) {
//                                 BlocProvider.of<RegisterBloc>(context).add(
//                                   RequestOtpAndRegister(
//                                     username: _usernameController.text.trim(),
//                                     email: _emailController.text.trim(),
//                                     phone: _phoneController.text.trim(),
//                                     password: _passwordController.text.trim(),
//                                   ),
//                                 );
//                               }
//                             },
//                             child: state is RegisterLoading
//                                 ? CircularProgressIndicator(color: Colors.white)
//                                 : Text("Register", style: TextStyle(fontSize: 20.0, color: Colors.white)),
//                             style: ElevatedButton.styleFrom(
//                               minimumSize: Size(double.infinity, 50),
//                               backgroundColor: AppTheme.Navblue1,
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 10.0),
//                     Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("Already registered? ", style: TextStyle(fontSize: 18.0)),
//                           GestureDetector(
//                             child: Text(
//                               " Login!",
//                               style: TextStyle(
//                                 fontSize: 18.0,
//                                 color: AppTheme.Navblue1,
//                                 decoration: TextDecoration.underline,
//                               ),
//                             ),
//                             onTap: () {
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => Login_Screen()));
//                             },
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//
//
//   }
// }

import 'package:jessy_cabs/Bloc/AppBloc_Events.dart';
import 'package:jessy_cabs/Bloc/AppBloc_State.dart';
import 'package:jessy_cabs/Bloc/App_Bloc.dart';
import 'package:flutter/material.dart';
import 'package:jessy_cabs/Screens/LoginScreen/Login_Screen.dart';
import 'package:jessy_cabs/Screens/OtpScreen/OtpScreen.dart';
import 'package:jessy_cabs/Utils/AppConstants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Utils/AppTheme.dart';
import 'package:jessy_cabs/Networks/Api_Service.dart';
import 'package:jessy_cabs/Utils/AppFunctions.dart';
import 'package:jessy_cabs/Utils/AppStyles.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _registerFormKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordIcon = true;

  void passwordIconChange() {
    setState(() {
      _passwordIcon = !_passwordIcon;
    });
  }

  // Future<void> registerUser() async {
  //
  //   if (_registerFormKey.currentState?.validate() ?? false) {
  //     final response = await ApiService.registerDriver(
  //       username: _usernameController.text.trim(),
  //       email: _emailController.text.trim(),
  //       password: _passwordController.text.trim(),
  //       mobileNumber: _phoneController.text.trim(),
  //     );
  //
  //     if (response["success"]) {
  //       showSuccessSnackBar(context, response["message"]);
  //       Navigator.push(
  //         context,
  //         // MaterialPageRoute(builder: (context) => OtpScreen(email: _emailController.text)),
  //         MaterialPageRoute(builder: (context) => Login_Screen()),
  //       );
  //     } else {
  //       showAlertDialog(context, response["message"]);
  //     }
  //   }
  // }

Future<void> registerUser() async {
    print("objecttt");
    // if(_registerFormKey.currentState?.validate()??false){
    //
    //   context.read<RegisterBloc>().add(RegisterUserEvent(
    //       username: _usernameController.text.trim(),
    //       email: _emailController.text.trim(),
    //       password: _passwordController.text.trim(),
    //       mobileNumber: _phoneController.text.trim(),
    //   ));
    // }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register"),
        ),
        body: BlocProvider(
          create: (context) => RegisterBloc(),
          child: BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state is RegisteringSucces) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Registration successful! Please log in."),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2), // Adjust duration as needed
                  ),
                );
                Future.delayed(Duration(seconds: 2), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Login_Screen()),
                            );
                });

              } else if (state is RegisteringFailure) {
                showAlertDialog(context, state.errormessage);
              }
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _registerFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppConstants.registration,
                        width: 400.0,
                        height: 400.0,
                      ),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: "Username",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_2),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username is required.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.mail),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                                  .hasMatch(value)) {
                            return 'Enter a valid email address.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number cannot be empty.';
                          } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                            return 'Enter a valid phone number with only numbers.';
                          } else if (value.length < 10) {
                            return 'Phone number must be at least 10 digits.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _passwordIcon,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: passwordIconChange,
                            icon: Icon(_passwordIcon
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 6) {
                            return 'Password must be at least 6 characters long.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.0),

                      BlocBuilder<RegisterBloc, RegisterState>(builder: (context ,state){
                        return  SizedBox(
                          width: 200.0,
                          child: ElevatedButton(
                            onPressed: (){
                              if(_registerFormKey.currentState?.validate()??false){

                                context.read<RegisterBloc>().add(RegisterUserEvent(
                                  username: _usernameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                  mobileNumber: _phoneController.text.trim(),
                                ));
                              }
                            },
                            child: state is RegisteringLoading ? CircularProgressIndicator(color: Colors.white) : Text("Register",
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              backgroundColor: AppTheme.Navblue1,
                            ),
                          ),
                        );
                      }),



                      SizedBox(height: 10.0),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already registeredd? ",
                                style: TextStyle(fontSize: 18.0)),
                            GestureDetector(
                              child: Text(
                                " Login!",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: AppTheme.Navblue1,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login_Screen()));
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
