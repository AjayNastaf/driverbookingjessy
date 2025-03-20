import 'package:flutter/material.dart';
import 'package:jessy_cabs/Screens/Home.dart';
import 'package:jessy_cabs/Screens/LoginScreen/Login_Screen.dart';
import '../../Networks/Api_Service.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({super.key , required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpFormKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers = List.generate(4, (index) => TextEditingController());
  String get enteredOtp => _otpControllers.map((controller) => controller.text).join();

  void _checkOtp() async {
    final getOtpEmail = await ApiService.retrieveOtpFromDatabase(widget.email);
    if (getOtpEmail != null) {
      String? otpEmail = getOtpEmail['otp'];
      String? username = getOtpEmail['username'];
      String? password = getOtpEmail['password'];
      String? phonenumber = getOtpEmail['phonenumber'];
      if(enteredOtp == otpEmail){
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Success otp')),
        // );
        showAlertDialog(context, "Otp verified successfully!,"
            "UserNAme and password sent to email");

        final sendUsernamePasswordEmail = await ApiService.sendUsernamePasswordEmail(username!, password!, widget.email);
        if(sendUsernamePasswordEmail == true){
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('password send to mail')),
          // );
          final sendRegisterDetailsDatabase = await ApiService.sendRegisterDetailsDatabase(username!, password!, widget.email, phonenumber!);
          if(sendRegisterDetailsDatabase == true){
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('inserted register')),
            // );
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login_Screen()));
          }
          else{
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registeration failed, Already Registerd ')),
            );

          }
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('sendUsernamePasswordEmail failed')),
          );
        }

      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed otp')),
        );
      }
    }
    else{
      print("Failed to retrieve OTP details.");
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter OTP"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: _otpFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Enter the 4-digit OTP sent to your phone",
                  style: TextStyle(fontSize: 18.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.0),
                // OTP Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return SizedBox(
                      width: 50,
                      child: TextFormField(
                        controller: _otpControllers[index],
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counterText: "",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 3) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "";
                          }
                          return null;
                        },
                      ),
                    );
                  }),
                ),
                SizedBox(height: 20.0),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_otpFormKey.currentState!.validate()) {
                        // Process OTP
                        _checkOtp();
                      }
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
