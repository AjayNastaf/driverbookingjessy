import 'package:flutter/material.dart';
import 'package:jessy_cabs/Screens/ListScreen/listviewpage.dart';
import 'package:jessy_cabs/Screens/LoginScreen/Login_Screen.dart';
import 'package:jessy_cabs/Utils/AppStyles.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // void logout(BuildContext context){
  //   print("Ajay");
  //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login_Screen()));
  // }

  void logout(BuildContext context) {
    print("Ajay");
    // Navigate back to the login screen
    Navigator.pushReplacement(
      context,
        MaterialPageRoute(builder: (context) => Login_Screen()), // Replace `LoginPage` with your actual login screen
    // MaterialPageRoute(builder: (context) => listviewpage()), // Replace `LoginPage` with your actual login screen
    );

    // Optionally show a confirmation message
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('You have been logged out')),
    // );
    showAlertDialog(context, "You have been logged out..");

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(onPressed: () => logout(context), icon: Icon(Icons.logout)),
        ],
      ),
      body: Column(
        children: [
          Text("dddddddd",),
          IconButton(onPressed:() {
            showAlertDialog(context, "Data fetched successfully!");

          }, icon: Icon(Icons.save))
        ],
      ),

    );
  }
}
