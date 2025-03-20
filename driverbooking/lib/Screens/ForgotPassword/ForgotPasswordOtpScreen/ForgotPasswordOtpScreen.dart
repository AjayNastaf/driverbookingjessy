import 'package:jessy_cabs/Screens/ForgotPassword/ChangePasswordScreen/ChangePasswordScreen.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jessy_cabs/Bloc/AppBloc_Events.dart';
import 'package:jessy_cabs/Bloc/AppBloc_State.dart';
import 'package:jessy_cabs/Bloc/App_Bloc.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  final String userId;
  final String email;

  const ForgotPasswordOtpScreen({
    Key? key,
    required this.userId,
    required this.email,
  }) : super(key: key);

  @override
  State<ForgotPasswordOtpScreen> createState() =>
      _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  final List<String> otp = ["", "", "", ""];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckForgotPasswordOtpBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Verify OTP",
            style: TextStyle(color: Colors.white, fontSize: AppTheme.appBarFontSize),
          ),
          backgroundColor: AppTheme.Navblue1,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocConsumer<CheckForgotPasswordOtpBloc, CheckForgotPasswordOtpState>(
          listener: (context, state) {
            if (state is CheckForgotPasswordOtpCompleted) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text("OTP Verified Successfully")),
              // );
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChangePasswordScreen(
                  userId: widget.userId,
              ))); // Navigate to the next screen or close
              showSuccessSnackBar(context, "OTP Verified Successfully!");
            } else if (state is CheckForgotPasswordOtpFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
              showFailureSnackBar(context, "${state.error}");
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Enter the 4-digit OTP sent to your registered email or phone number to verify your identity.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Enter OTP",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        width: 50,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: AppTheme.Navblue1, width: 2),
                            ),
                            counterText: "", // Remove counter text
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              otp[index] = value; // Update the OTP digit
                              if (index < 3) {
                                FocusScope.of(context)
                                    .nextFocus(); // Move to next field
                              }
                            } else {
                              otp[index] = ""; // Clear the OTP digit
                              if (index > 0) {
                                FocusScope.of(context)
                                    .previousFocus(); // Move to previous field
                              }
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final enteredOtp = otp.join(); // Combine the digits
                          if (enteredOtp.length == 4) {
                            context.read<CheckForgotPasswordOtpBloc>().add(
                              CheckForgotPasswordOtpAttempt(
                                email: widget.email,
                                otp: enteredOtp,
                              ),
                            );
                          } else {
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(
                            //     content: Text("Please enter a valid 4-digit OTP."),
                            //   ),
                            // );
                            showWarningSnackBar(context, "Please enter a valid 4-digit OTP.");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.Navblue1,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: state is CheckForgotPasswordOtpLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text(
                          "Verify OTP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
