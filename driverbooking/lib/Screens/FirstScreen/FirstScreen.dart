import 'package:flutter/material.dart';
import 'package:jessy_cabs/Screens/LoginScreen/Login_Screen.dart';
import 'package:jessy_cabs/Screens/LoginViaMobileScreen/LoginViaMobile.dart';
import 'package:jessy_cabs/Screens/SignUpScreen/SignUp_Screen.dart';
import 'package:jessy_cabs/Screens/Terms/TermsScreen.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:lottie/lottie.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "JESSY CABS PVT LTD",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Lottie Animation - takes remaining space
          Expanded(
            child: Transform.translate(
              offset: Offset(0, -40), // Move 30 pixels up
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Lottie.asset(
                  'assets/animations/Animationii.json',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Button section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
            child: Column(
              children: [
                // Login via number button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Loginviamobile()));
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      side: const BorderSide(color: AppTheme.Navblue1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone, color: AppTheme.Navblue1),
                        const SizedBox(width: 50),
                        const Text(
                          "Login via Phone Number",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.Navblue1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // OR divider
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Login_Screen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.Navblue1,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.Navblue1,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Terms and Conditions
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsAndPoliciesPage()));
                }, child:Text(
                  "Terms of Service | Privacy Policy",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ), ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}