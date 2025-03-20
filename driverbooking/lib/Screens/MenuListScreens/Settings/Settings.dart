// import 'package:jessy_cabs/Screens/MenuListScreens/Profile/profile.dart';
// import 'package:jessy_cabs/Screens/MenuListScreens/Settings/ChangePassword/ChangePassword.dart';
// import 'package:flutter/material.dart';
// import 'package:jessy_cabs/Utils/AppTheme.dart';
//
// class Settings extends StatelessWidget {
//   final String userId, username, password, phonenumber, email;
//
//   const Settings({
//     Key? key,
//     required this.userId,
//     required this.username,
//     required this.password,
//     required this.phonenumber,
//     required this.email,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Settings",
//           style: TextStyle(color: Colors.white, fontSize: AppTheme.appBarFontSize),
//         ),
//         backgroundColor: AppTheme.Navblue1,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextButton(
//               child: const Text(
//                 "User Details",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: AppTheme.Navblue1,
//                 ),
//               ),
//               style: TextButton.styleFrom(
//                 padding: EdgeInsets.zero,
//                 alignment: Alignment.centerLeft,
//               ),
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => ProfileScreen(
//                             // userId: userId,
//                             username: username,
//                             // password: password,
//                             // phonenumber: phonenumber,
//                             // email: email
//                         )));
//               },
//             ),
//
//             // const SizedBox(height: 10),
//             const Divider(),
//             // const SizedBox(height: 10),
//             TextButton(
//               child: const Text(
//                 "Change Password",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: AppTheme.Navblue1,
//                 ),
//               ),
//               style: TextButton.styleFrom(
//                 padding: EdgeInsets.zero,
//                 alignment: Alignment.centerLeft,
//               ),
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             ChangePasswordScreen(userId: userId)));
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
