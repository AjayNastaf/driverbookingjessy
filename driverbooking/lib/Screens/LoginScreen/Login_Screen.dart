import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jessy_cabs/Bloc/AppBloc_Events.dart';
import 'package:jessy_cabs/Bloc/AppBloc_State.dart';
import 'package:jessy_cabs/Bloc/App_Bloc.dart';
import 'package:jessy_cabs/Screens/Home.dart';
import 'package:jessy_cabs/Screens/HomeScreen/HomeScreen.dart';
import 'package:jessy_cabs/Screens/HomeScreen/MapScreen.dart';
import 'package:jessy_cabs/Screens/IntroScreens/IntroScreenMain.dart';
import 'package:jessy_cabs/Screens/ListScreen/listviewpage.dart';
import 'package:jessy_cabs/Screens/Registeration/Register.dart';
import 'package:jessy_cabs/Screens/SignUpScreen/SignUp_Screen.dart';
import 'package:jessy_cabs/models/login_dats.dart'; // Import the UserInfo model
import '../../Networks/Api_Service.dart';
import '../../Utils/AppConstants.dart';
import '../../Utils/AppTheme.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jessy_cabs/Screens/LoginViaMobileScreen/LoginViaMobile.dart';
import 'package:jessy_cabs/Screens/SignUpScreen/SignUp_Screen.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  // final _usernameController = TextEditingController();
  // final _passwordController = TextEditingController();
  String? _usernameError;
  String? _passwordError;

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // void _login() async {
  //   // print("Initiating login...");
  //   // print("Username: ${_usernameController.text}");
  //   // print("Password: ${_passwordController.text}");
  //
  //   final success = await ApiService.login(
  //     context: context,
  //     username: _usernameController.text,
  //     password: _passwordController.text,
  //   );
  //
  //   if (!success) {
  //     // print("Login failed, showing snackbar...");
  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   SnackBar(content: Text('Login failed')),
  //     // );
  //     showAlertDialog(context, "Login failed,     Check UserName And Password");
  //
  //   } else {
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
  //     // print("Login successful, navigating...");
  //     showAlertDialog(context, "Login successful, navigating...");
  //
  //   }
  // }

  // bgmain

// local storage for user details
  void _saveLoginDetails(String username, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('userId', userId);

    // Debugging print statements
    print("Saved username: $username");
    print("Saved userId: $userId");
  }


  Future<Map<String, dynamic>?> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');

    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }


  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('last_screen');
    await prefs.remove('trip_id');
    await prefs.remove('user_id');
    await prefs.remove('username');
    await prefs.remove('address');
    await prefs.remove('drop_location');
    print("SharedPreferences cleared successfully");
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => LoginBloc(),
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,  // Removes the back button

              // title: Text("Login"),
              // actions: [
              //   IconButton(onPressed: (){}, icon: Icon(Icons.logout,))
              // ],
              ),
          body: BlocListener<LoginBloc, LoginState>(listener: (context, state) {
            if (state is LoginCompleted) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text("Login Successful! User ID: ${state.userId}")),
              // );
              _saveLoginDetails(_usernameController.text, state.userId);
              // context.read<AuthenticationBloc>().add(LoggedIn());
              context.read<AuthenticationBloc>().add(
                LoggedIn(userId: state.userId, username: _usernameController.text),
              );

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Homescreen(userId: state.userId ,username: _usernameController.text,)),
              );
              // showSuccessSnackBar(context, "Login Successful! User Name: ${_usernameController.text}");
              print('Navigating to HomeScreen with userId: ${state.userId}');
              print('Navigating to HomeScreen with username: ${_usernameController.text}');
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => Introscreenmain(userId: state.userId)),
              // );
            } else if (state is LoginFailure) {
              // ScaffoldMessenger.of(context)
              //     .showSnackBar(SnackBar(content: Text(state.error)));

              showFailureSnackBar(context, "${state.error}");
            }
          }, child:
              BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
            if (state is LoginLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        // image: AssetImage(AppConstants.nastafLogo),bgmain
                        image: AssetImage(
                          AppConstants.bgmain,
                        ), // Replace with your image asset path
// Replace with your image asset path
                        fit: BoxFit.contain,
                        alignment: Alignment.topCenter,
                        // Makes the image cover the entire screen
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 380.0,
                    color: Colors.white.withOpacity(
                        0.8), // Set your desired background color with opacity
                    // color: AppTheme.white1, // Set your desired background color with opacity

                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Text(
                            //   "Welcome to jessy Cabs ..",
                            //   style: TextStyle(
                            //       fontSize: 28.0,
                            //       fontWeight: FontWeight.bold,
                            //       color: AppTheme.Navblue1),
                            // ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Enter Your details to continue.",
                              style: TextStyle(
                                  fontSize: 20.0, color: AppTheme.grey1),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),

                            // Email Field
                            // TextFormField(
                            //   controller: _emailController,
                            //   decoration: InputDecoration(
                            //     labelText: 'Email',
                            //     border: OutlineInputBorder(),
                            //     prefixIcon: Icon(Icons.email),
                            //   ),
                            //   keyboardType: TextInputType.emailAddress,
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return 'Please enter your email';
                            //     } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value)) {
                            //       return 'Please enter a valid email';
                            //     }
                            //     return null;
                            //   },
                            // ),
                            // SizedBox(height: 16.0), // Space between fields
                            //
                            // // Phone Number Field
                            // TextFormField(
                            //   controller: _phoneController,
                            //   decoration: InputDecoration(
                            //     labelText: 'Phone Number',
                            //     border: OutlineInputBorder(),
                            //     prefixIcon: Icon(Icons.phone),
                            //   ),
                            //   keyboardType: TextInputType.phone,
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return 'Please enter your phone number';
                            //     } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                            //       return 'Please enter a valid 10-digit phone number';
                            //     }
                            //     return null;
                            //   },
                            // ),
                            // SizedBox(height: 16.0),

                            // Username Field
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
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
                            SizedBox(height: 20.0),

                            // Password Field
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: _togglePasswordVisibility,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                } else if (value.length < 3) {
                                  return 'Password must be at least 3 characters';
                                }
                                return null;
                              },
                            ),


                            SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Loginviamobile()),
                                    );
                                  },
                                  child: Text(
                                    'Login Via Phone Number',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: AppTheme.Navblue1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Login Button


                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUp()));
                                },
                                child: Text(
                                  "Don't have an account? Sign Up",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: AppTheme.Navblue1,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              // onPressed: () {
                              //   if (_formKey.currentState!.validate()) {
                              //     // Perform login logic
                              //     ScaffoldMessenger.of(context).showSnackBar(
                              //       SnackBar(content: Text('Logging in...')),
                              //     );
                              //     // UserInfo userInfo = UserInfo(
                              //     //   email: _emailController.text,
                              //     //   phone: _phoneController.text,
                              //     //   password: _passwordController.text,
                              //     // );
                              //
                              //
                              //
                              //   UserInfo userInfo = UserInfo(
                              //     email: _emailController.text,
                              //     phone: _phoneController.text,
                              //     password: _passwordController.text,
                              //   );
                              //   Map<String ,dynamic>userInfoJson = userInfo.toJson();
                              //
                              //   // Navigate to the next page and replace the current page
                              //   Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         // builder: (context) => MapScreen( userInfo: userInfo,)
                              //       // builder: (context) => MapScreen(userInfoJson: userInfoJson),
                              //       builder: (context) => listviewpage(),
                              //
                              //   ),
                              //   );
                              //
                              //
                              //   print(_passwordController);
                              //   print( _emailController);
                              //   print(_phoneController);
                              //   };
                              //   // _login
                              // },
                              // onPressed: _login,
                              onPressed: () {
                                final username = _usernameController.text;
                                final password = _passwordController.text;
                                context.read<LoginBloc>().add(LoginAtempt(
                                    username: username, password: password));
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(fontSize: 23.0,color: AppTheme.white1),

                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
                                backgroundColor: AppTheme.Navblue1,
                              ),
                            ),

                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Text(
                            //         "Don't Have the Account? ",
                            //         style: TextStyle(fontSize: 15.0),
                            //       ),
                            //       GestureDetector(
                            //         child: Text(
                            //           " Register!",
                            //           style: TextStyle(
                            //               fontSize: 15.0,
                            //               color: AppTheme.Navblue1,
                            //               decoration: TextDecoration.underline),
                            //         ),
                            //         onTap: () {
                            //           Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //                 builder: (context) => Register()),
                            //           );
                            //         },
                            //       )
                            //     ],
                            //   ),
                            //   // child: Text("Don't Have the Account"),
                            // )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          })),
        ));
  }
}
