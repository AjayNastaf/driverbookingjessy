import 'dart:math';

import 'package:jessy_cabs/Networks/Api_Service.dart';
import 'package:jessy_cabs/Screens/ForgotPassword/ForgotPasswordOtpScreen/ForgotPasswordOtpScreen.dart';
import 'package:jessy_cabs/Screens/LoginScreen/Login_Screen.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jessy_cabs/Bloc/App_Bloc.dart';
import 'package:jessy_cabs/Bloc/AppBloc_State.dart';
import 'package:jessy_cabs/Bloc/AppBloc_Events.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();

  bool isEmailEmpty = false;

  void _forgotPasswordOtpEmail(userId, email) async {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Email Verified')),
    // );
    final random = Random();
    final forgotPasswordOtp = (1000 + random.nextInt(9000)).toString();
    final forgotPasswordOtpEmailSentResult =
        await ApiService.forgotPasswordOtpEmailSentResult(
            userId, email, forgotPasswordOtp);
    if (forgotPasswordOtpEmailSentResult) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ForgotPasswordOtpScreen(userId: userId, email: email)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordEmailVerificationBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Reset Password",
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
                "Enter the email associated with your account and we'll send an email with instructions to reset your password.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Email Address",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  hintText: "Enter your email",
                ),
                onChanged: (value) {
                  if(value.isEmpty){
                    setState(() {
                      isEmailEmpty = true;
                    });
                  }
                  else{
                    setState(() {
                      isEmailEmpty = false;
                    });
                  }
                },
              ),
              if(isEmailEmpty) ...[
                Text('Email should not be empty', style: TextStyle(color: Colors.red),)
              ],
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: BlocConsumer<ForgotPasswordEmailVerificationBloc,
                      ForgotPasswordEmailVerificationState>(
                    listener: (context, state) {
                      if (state is ForgotPasswordEmailVerificationCompleted) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('Email Verified')),
                        // );
                        showSuccessSnackBar(context, 'Email verified');
                        _forgotPasswordOtpEmail(
                            state.userId, emailController.text);
                      } else if (state
                          is ForgotPasswordEmailVerificationFailure) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('Email is not registered')),
                        // );
                        showFailureSnackBar(context, 'Email is not registered');
                      }
                    },
                    builder: (context, state) {
                      if (state is ForgotPasswordEmailVerificationLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ElevatedButton(
                        child: const Text(
                          "Submit",
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
                          final email = emailController.text.trim();
                          if (email.isNotEmpty) {
                            setState(() {
                              isEmailEmpty = false;
                            });
                            context
                                .read<ForgotPasswordEmailVerificationBloc>()
                                .add(
                                  ForgotPasswordEmailVerificationAttempt(
                                      email: email),
                                );
                          } else {
                            setState(() {
                              isEmailEmpty = true;
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
