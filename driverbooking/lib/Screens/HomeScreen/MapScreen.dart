import 'package:flutter/material.dart';
import 'package:jessy_cabs/models/login_dats.dart'; // Import the UserInfo model



class MapScreen extends StatefulWidget {

  // final String email;
  // final String phone;
  // final String password;

  // const MapScreen({
  //   Key? key,
  //   required this.email,
  //   required this.phone,
  //   required this.password,
  // }) : super(key: key);


  // final UserInfo userInfo;
  //
  // MapScreen({required this.userInfo});


  final Map<String, dynamic> userInfoJson;
  MapScreen({required this. userInfoJson});

  // const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late UserInfo userInfo; // Declare userInfo

  @override
  void initState() {
    super.initState();
    // Convert JSON map to UserInfo instance
    userInfo = UserInfo.fromJson(widget.userInfoJson);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // children: [
          //   Text('Email: ${widget.email}'),
          //   SizedBox(height: 10),
          //   Text('Phone: ${widget.phone}'),
          //   SizedBox(height: 10),
          //   Text('Password: ${widget.password}'),
          // ],
          children: [
            Text("Email: ${userInfo.email}"), // Accessing userInfo
            Text("Phone: ${userInfo.phone}"),
            Text("Password: ${userInfo.password}"),
          ],
        ),
      ),    );
  }
}

