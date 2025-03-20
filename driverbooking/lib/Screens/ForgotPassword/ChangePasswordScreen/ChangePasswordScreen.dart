import 'dart:math';
import 'package:jessy_cabs/Networks/Api_Service.dart';
import 'package:jessy_cabs/Screens/ForgotPassword/ForgotPasswordOtpScreen/ForgotPasswordOtpScreen.dart';
import 'package:jessy_cabs/Screens/HomeScreen/HomeScreen.dart';
import 'package:jessy_cabs/Screens/MenuListScreens/Settings/Settings.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jessy_cabs/Bloc/App_Bloc.dart';
import 'package:jessy_cabs/Bloc/AppBloc_State.dart';
import 'package:jessy_cabs/Bloc/AppBloc_Events.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String userId;

  const ChangePasswordScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isNewPasswordError = false;
  bool isConfirmPasswordError = false;

  // void _changePassword(BuildContext context) async {
  //   if (_formKey.currentState!.validate()) {
  //     final password = passwordController.text.trim();
  //     final confirmPassword = confirmPasswordController.text.trim();
  //
  //     // Check if the passwords match
  //     if (password != confirmPassword) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Passwords do not match.")),
  //       );
  //       return;
  //     }
  //
  //     // Trigger the Bloc event to change the password
  //     context.read<ChangePasswordForgotBloc>().add(
  //       ChangePasswordForgotAttempt(
  //         userId: widget.userId,
  //         password: password,
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePasswordForgotBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Change Password",
            style: TextStyle(
                color: Colors.white, fontSize: AppTheme.appBarFontSize),
          ),
          backgroundColor: AppTheme.Navblue1,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Enter your new password below to update it.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "New Password",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter new password",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isNewPasswordError
                          ? Colors.red
                          : Colors.grey, // Condition for border color
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isNewPasswordError
                          ? Colors.red
                          : Colors.blue, // Red when there's an error
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a password.";
                  } else if (value.length < 6) {
                    return "Password must be at least 6 characters.";
                  }
                  return null;
                },
                onChanged: (value) {
                  if(value.isEmpty || value.length < 6){
                    setState(() {
                      isNewPasswordError = true;
                    });
                  }
                   else {
                     setState(() {
                       isNewPasswordError = false;
                     });
                  }
                },
              ),
              if(isNewPasswordError) ...[
                Text('Password must be atleast 6 characters', style: TextStyle(color: Colors.red),),
              ],
              const SizedBox(height: 20),
              const Text(
                "Confirm Password",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Re-enter your password",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isConfirmPasswordError
                          ? Colors.red
                          : Colors.grey, // Condition for border color
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isConfirmPasswordError
                          ? Colors.red
                          : Colors.blue, // Red when there's an error
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm your password.";
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    isConfirmPasswordError = false;
                  });
                },
              ),
              if(isConfirmPasswordError) ...[
                Text('Password do not match', style: TextStyle(color: Colors.red),),
              ],
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: BlocConsumer<ChangePasswordForgotBloc,
                      ChangePasswordForgotState>(
                    listener: (context, state) {
                      if (state is ChangePasswordForgotLoading) {
                        // Show loading indicator
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('Changing password...')),
                        // );
                        showInfoSnackBar(context, "Changing password...");
                      } else if (state is ChangePasswordForgotCompleted) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //       content: Text('Password Changed Succesfully')),
                        // );
                        // Navigate to the ForgotPasswordOtpScreen after success
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => Homescreen(
                        //       userId: widget.userId,
                        //
                        //     ),
                        //   ),
                        // );
                        showSuccessSnackBar(context, "Password Changed Succesfully!");
                      } else if (state is ChangePasswordForgotFailure) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text(state.error)),
                        // );
                        showFailureSnackBar(context, "${state.error}");
                      }
                    },
                    builder: (context, state) {
                      if (state is ChangePasswordForgotLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ElevatedButton(
                        // onPressed: () => _changePassword(context),
                        child: const Text(
                          "Change Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.Navblue1,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          final newPassword = passwordController.text.trim();
                          final confirmPassword =
                              confirmPasswordController.text.trim();
                          if (newPassword.isEmpty || newPassword.length < 6) {
                            setState(() {
                              isNewPasswordError = true;
                            });
                            return;
                          } else {
                            setState(() {
                              isNewPasswordError = false;
                            });
                          }
                          // Check if the passwords match
                          if (newPassword == confirmPassword) {
                            context.read<ChangePasswordForgotBloc>().add(
                                  ChangePasswordForgotAttempt(
                                    userId: widget.userId,
                                    newPassword: newPassword,
                                  ),
                                );
                            setState(() {
                              isConfirmPasswordError = false;
                            });
                          } else {
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(
                            //     content: Text("Password do no match."),
                            //   ),
                            // );
                            setState(() {
                              isConfirmPasswordError = true;
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
