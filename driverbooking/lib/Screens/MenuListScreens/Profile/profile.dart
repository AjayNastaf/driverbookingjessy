// import 'package:jessy_cabs/Utils/AllImports.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:jessy_cabs/Bloc/AppBloc_Events.dart';
// import 'package:jessy_cabs/Bloc/AppBloc_State.dart';
// import 'package:jessy_cabs/Bloc/App_Bloc.dart';
// import 'package:jessy_cabs/Screens/HomeScreen/HomeScreen.dart';
// import 'package:http/http.dart' as http;
//
// class ProfileScreen extends StatelessWidget {
//   final String userId, username, password, phonenumber, email;
//
//   const ProfileScreen({
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
//     return BlocProvider(
//       create: (context) => UpdateUserBloc(),
//       child: ProfileScreenContent(
//         userId: userId,
//         username: username,
//         password: password,
//         phonenumber: phonenumber,
//         email: email,
//       ),
//     );
//   }
// }
//
// class ProfileScreenContent extends StatefulWidget {
//   final String userId, username, password, phonenumber, email;
//
//   const ProfileScreenContent({
//     Key? key,
//     required this.userId,
//     required this.username,
//     required this.password,
//     required this.phonenumber,
//     required this.email,
//   }) : super(key: key);
//
//   @override
//   State<ProfileScreenContent> createState() => _ProfileScreenContentState();
// }
//
// class _ProfileScreenContentState extends State<ProfileScreenContent> {
//   late TextEditingController nameController;
//   late TextEditingController mobileController;
//   late TextEditingController passwordController;
//   late TextEditingController emailController;
//
//   File? profileImage;
//
//   @override
//   void initState() {
//     super.initState();
//     nameController = TextEditingController(text: widget.username);
//     mobileController = TextEditingController(text: widget.phonenumber);
//     passwordController = TextEditingController(text: widget.password);
//     emailController = TextEditingController(text: widget.email);
//     print('Userphone: ${widget.phonenumber}, Usernameddd: ${widget.username},Userpass: ${widget.password}, Usernameddd: ${widget.email}');
//
//   }
//
//   Future<void> pickImage(ImageSource source) async {
//     final pickedFile = await ImagePicker().pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         profileImage = File(pickedFile.path);
//       });
//     }
//   }
//
//   Future<void> _uploadImage() async {
//     if (profileImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select an image first")),
//       );
//       return;
//     }
//
//     try {
//       const String apiUrl = "${AppConstants.baseUrl}/upload-image";
//       final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
//
//       // Add the image file with the correct key
//       request.files.add(await http.MultipartFile.fromPath(
//         'image', // Match this with the key expected in your API
//         profileImage!.path,
//       ));
//
//       final response = await request.send();
//
//       if (response.statusCode == 200) {
//         final responseBody = await response.stream.bytesToString();
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Image uploaded successfully!")),
//         );
//         debugPrint("Response: $responseBody");
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to upload image")),
//         );
//         debugPrint("Error: ${response.reasonPhrase}");
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//       debugPrint("Exception: $e");
//     }
//
//     context.read<UpdateUserBloc>().add(
//       UpdateUserAttempt(
//         userId: widget.userId,
//         username: nameController.text,
//         password: passwordController.text,
//         phone: mobileController.text,
//         email: emailController.text,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Profile",
//           style:
//           TextStyle(color: Colors.white, fontSize: AppTheme.appBarFontSize),
//         ),
//         backgroundColor: AppTheme.Navblue1,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: BlocConsumer<UpdateUserBloc, UpdateUserState>(
//         listener: (context, state) {
//           if (state is UpdateUserCompleted) {
//             // ScaffoldMessenger.of(context).showSnackBar(
//             //   SnackBar(content: Text('Details updated')),
//             // );
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => Homescreen(userId: widget.userId,
//                       username: widget.username,  // Add this line to pass username
//
//                     )));
//
//             showSuccessSnackBar(context, 'Details updated');
//           } else if (state is UpdateUserFailure) {
//             // ScaffoldMessenger.of(context).showSnackBar(
//             //   SnackBar(content: Text(state.error)),
//             // );
//             showFailureSnackBar(context, "${state.error}");
//           }
//         },
//         builder: (context, state) {
//           if (state is UpdateUserLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Center(
//                   child: Stack(
//                     children: [
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundImage: profileImage != null
//                             ? FileImage(profileImage!)
//                             : null,
//                         child: profileImage == null
//                             ? const Icon(Icons.person, size: 50)
//                             : null,
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: IconButton(
//                           icon: const Icon(Icons.edit),
//                           onPressed: () {
//                             showModalBottomSheet(
//                               context: context,
//                               builder: (_) {
//                                 return Wrap(
//                                   children: [
//                                     ListTile(
//                                       leading: const Icon(Icons.camera),
//                                       title: const Text("Camera"),
//                                       onTap: () {
//                                         Navigator.pop(context);
//                                         pickImage(ImageSource.camera);
//                                       },
//                                     ),
//                                     ListTile(
//                                       leading: const Icon(Icons.photo_library),
//                                       title: const Text("Gallery"),
//                                       onTap: () {
//                                         Navigator.pop(context);
//                                         pickImage(ImageSource.gallery);
//                                       },
//                                     ),
//                                   ],
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 buildTextField("Name", nameController),
//                 const SizedBox(height: 10),
//                 buildTextField("Phone", mobileController),
//                 const SizedBox(height: 10),
//                 buildTextField("Password", passwordController,
//                     obscureText: true),
//                 const SizedBox(height: 10),
//                 buildTextField("Email", emailController),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     //   context.read<UpdateUserBloc>().add(
//                     //         UpdateUserAttempt(
//                     //           userId: widget.userId,
//                     //           username: nameController.text,
//                     //           password: passwordController.text,
//                     //           phone: mobileController.text,
//                     //           email: emailController.text,
//                     //         ),
//                     //       );
//                     _uploadImage();
//                   },
//                   child: const Text(
//                     "Save",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppTheme.Navblue1,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
// // Widget _buildTextField(String label, TextEditingController controller,
// //     {bool obscureText = false}) {
// //   return TextField(
// //     controller: controller,
// //     obscureText: obscureText,
// //     decoration: InputDecoration(
// //       labelText: label,
// //       border: const OutlineInputBorder(),
// //     ),
// //   );
// // }
// }



//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// class ProfileScreen extends StatefulWidget {
//   final String  username;
//
//   const ProfileScreen({
//     Key? key,
//     required this.username,
//   }) : super(key: key);
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//
//
//   File? profileImage;
//
//   @override
//   void initState() {
//     super.initState();
//     // nameController = TextEditingController(text: widget.username);
//
//   }
//
//   Future<void> pickImage(ImageSource source) async {
//     final pickedFile = await ImagePicker().pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         profileImage = File(pickedFile.path);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Profile"),
//         backgroundColor: Colors.blue,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Center(
//               child: Stack(
//                 children: [
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundImage: profileImage != null
//                         ? FileImage(profileImage!)
//                         : null,
//                     child: profileImage == null
//                         ? const Icon(Icons.person, size: 50)
//                         : null,
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: IconButton(
//                       icon: const Icon(Icons.edit),
//                       onPressed: () {
//                         showModalBottomSheet(
//                           context: context,
//                           builder: (_) {
//                             return Wrap(
//                               children: [
//                                 ListTile(
//                                   leading: const Icon(Icons.camera),
//                                   title: const Text("Camera"),
//                                   onTap: () {
//                                     Navigator.pop(context);
//                                     pickImage(ImageSource.camera);
//                                   },
//                                 ),
//                                 ListTile(
//                                   leading: const Icon(Icons.photo_library),
//                                   title: const Text("Gallery"),
//                                   onTap: () {
//                                     Navigator.pop(context);
//                                     pickImage(ImageSource.gallery);
//                                   },
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             _buildTextField("Name", nameController),
//             const SizedBox(height: 10),
//             _buildTextField("Phone", mobileController),
//             const SizedBox(height: 10),
//             _buildTextField("Password", passwordController, obscureText: true),
//             const SizedBox(height: 10),
//             _buildTextField("Email", emailController),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Handle save action
//               },
//               child: const Text("Save"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(String label, TextEditingController controller,
//       {bool obscureText = false}) {
//     return TextField(
//       controller: controller,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         labelText: label,
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }
// }




import 'package:jessy_cabs/Screens/HomeScreen/HomeScreen.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jessy_cabs/Utils/AppConstants.dart';
import 'package:jessy_cabs/Networks/Api_Service.dart';

import '../../../Bloc/AppBloc_Events.dart';
import '../../../Bloc/AppBloc_State.dart';
import '../../../Bloc/App_Bloc.dart';

import 'package:jessy_cabs/Screens/NoInternetBanner/NoInternetBanner.dart';
import 'package:provider/provider.dart';
import 'package:jessy_cabs/Screens/network_manager.dart';



class ProfileScreen extends StatefulWidget {
  final String username;

  const ProfileScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController mobileController;
  late TextEditingController passwordController;
  late TextEditingController emailController;



  File? profileImage;
  bool isLoading = true;
  String? errorMessage;
  File? _selectedImage; // Store selected image

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    mobileController = TextEditingController();
    passwordController = TextEditingController();
    emailController = TextEditingController();

    fetchProfile(); // Fetch the API data when screen initializes

  }
  Future<void> _refreshProfile() async {
    await fetchProfile();

  }

  Future<void> fetchProfile() async {
    try {
      final profileData = await getDriverProfile(widget.username);
      if (profileData != null) {
        setState(() {
          nameController.text = profileData['username'] ?? '';
          mobileController.text = profileData['Mobileno'] ?? '';
          passwordController.text = profileData['userpassword'] ?? '';
          emailController.text = profileData['Email'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Failed to load profile data.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>?> getDriverProfile(String username) async {
    final url = Uri.parse('${AppConstants.baseUrl}/getDriverProfile');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Driver not found');
      } else {
        throw Exception('Failed to fetch driver profile');
      }
    } catch (e) {
      print('Error fetching driver profile: $e');
      return null;
    }
  }

  // Future<void> pickImage(ImageSource source) async {
  //   final pickedFile = await ImagePicker().pickImage(source: source);
  //   if (pickedFile != null) {
  //     setState(() {
  //       profileImage = File(pickedFile.path);
  //     });
  //   }
  // }

  // Future<void> _pickImage() async {
  //   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _selectedImage = File(pickedFile.path);
  //     });
  //   }
  // }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      print("Image selected: ${_selectedImage!.path}"); // Debugging log
    } else {
      print("No image selected");
    }
  }

  Future<void> _uploadProfilePhoto() async {
    // if (_selectedImage == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Please select an image first')),
    //   );
    //   return;
    // }
    //
    // print("Uploading image: ${_selectedImage!.path}"); // Debugging log
    //
    // bool success = await ApiService.uploadProfilePhoto(
    //   username: widget.username,
    //   imageFile: _selectedImage!,
    // );
    //
    // if (success) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Profile photo uploaded successfully')),
    //   );
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Failed to upload profile photo')),
    //   );
    // }


    // if (_selectedImage == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Please select an image first')),
    //   );
    //   return;
    // }

    context.read<ProfileBloc>().add(
      UploadProfilePhotoEvent(
        username: widget.username,
        imageFile: _selectedImage!,
      ),
    );
  }

  Future<void> handleUpdateProfile() async {
    // bool success = await ApiService.updateProfile(
    //   username: widget.username,
    //   mobileNo: mobileController.text,
    //   password: passwordController.text,
    //   email: emailController.text,
    // );

    context.read<ProfileBloc>().add(
      UpdateProfileEvent(
        username: widget.username,
        mobileNo: mobileController.text,
        password: passwordController.text,
        email: emailController.text,
      ),
    );

  }

  Future<void> handleUpdateProfileAndImage() async {
    handleUpdateProfile();
    _uploadProfilePhoto();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Homescreen(userId: '', username: widget.username)));

  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text("Profile"), backgroundColor: Colors.blue),
  //     body: isLoading
  //         ? const Center(child: CircularProgressIndicator())
  //         : errorMessage != null
  //         ? Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.red)))
  //         : SingleChildScrollView(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         children: [
  //           Center(
  //             child: Stack(
  //               children: [
  //         CircleAvatar(
  //         radius: 50,
  //         backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
  //         child: _selectedImage == null ? const Icon(Icons.person, size: 50) : null,
  //       ),
  //       Positioned(
  //         bottom: 0,
  //         right: 0,
  //         child: IconButton(
  //           icon: const Icon(Icons.edit),
  //           onPressed: () {
  //             showModalBottomSheet(
  //               context: context,
  //               builder: (_) {
  //                 return Wrap(
  //                   children: [
  //                     ListTile(
  //                       leading: const Icon(Icons.camera),
  //                       title: const Text("Camera"),
  //                       onTap: () {
  //                         Navigator.pop(context);
  //                         pickImage(ImageSource.camera);
  //                       },
  //                     ),
  //                     ListTile(
  //                       leading: const Icon(Icons.photo_library),
  //                       title: const Text("Gallery"),
  //                       onTap: () {
  //                         Navigator.pop(context);
  //                         pickImage(ImageSource.gallery);
  //                       },
  //                     ),
  //                   ],
  //                 );
  //               },
  //             );
  //           },
  //         ),
  //       ),
  //               ],
  //             ),
  //           ),
  //           const SizedBox(height: 20),
  //           _buildTextField("Name", nameController , readOnly: true),
  //           const SizedBox(height: 10),
  //           _buildTextField("Phone", mobileController),
  //           const SizedBox(height: 10),
  //           _buildTextField("Password", passwordController),
  //           const SizedBox(height: 10),
  //           _buildTextField("Email", emailController),
  //           const SizedBox(height: 20),
  //           ElevatedButton(
  //             onPressed: () {
  //               // Handle save action
  //               handleUpdateProfileAndImage();
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.blue,
  //               padding: const EdgeInsets.symmetric(vertical: 16),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //             ),
  //             child: const Text("Save"),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false,bool readOnly = false}) {
  //   return TextField(
  //     controller: controller,
  //     obscureText: obscureText,
  //     readOnly: readOnly, // Disable the text field if readOnly is true
  //
  //     decoration: InputDecoration(
  //       labelText: label,
  //       border: const OutlineInputBorder(),
  //     ),
  //   );
  // }




  @override
  Widget build(BuildContext context) {
    bool isConnected = Provider.of<NetworkManager>(context).isConnected;

    return BlocProvider(
      create: (context) => ProfileBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Profile", style: TextStyle(color:AppTheme.white1, ),),
          backgroundColor: AppTheme.Navblue1,
          iconTheme: IconThemeData(color: AppTheme.white1), // Changes the back button color
        ),
        // body: RefreshIndicator( onRefresh: _refreshProfile,
        //
        //   child:  BlocListener<ProfileBloc, ProfileState>(
        //   listener: (context, state) {
        //     if (state is ProfileLoading) {
        //       setState(() {
        //         isLoading = true;
        //         errorMessage = null;
        //       });
        //     } else if (state is ProfileUpdated) {
        //       setState(() {
        //         isLoading = false;
        //       });
        //       // ScaffoldMessenger.of(context).showSnackBar(
        //       //   const SnackBar(content: Text("Profile updated successfully!")),
        //       // );
        //       showSuccessSnackBar(context, "Profile updated successfully!");
        //     } else if (state is ProfilePhotoUploaded) {
        //       setState(() {
        //         isLoading = false;
        //       });
        //       // ScaffoldMessenger.of(context).showSnackBar(
        //       //   const SnackBar(content: Text("Profile photo uploaded successfully!")),
        //       // );
        //       showSuccessSnackBar(context, "Profile photo uploaded successfully!");
        //     } else if (state is ProfilePhotoUploadError) {
        //       setState(() {
        //         isLoading = false;
        //         errorMessage = state.message;
        //       });
        //       // ScaffoldMessenger.of(context).showSnackBar(
        //       //   SnackBar(content: Text(state.message)),
        //       // );
        //       showFailureSnackBar(context, 'state.message');
        //     } else if (state is ProfileError) {
        //       setState(() {
        //         isLoading = false;
        //         errorMessage = state.message;
        //       });
        //       // ScaffoldMessenger.of(context).showSnackBar(
        //       //   SnackBar(content: Text(state.message)),
        //       // );
        //       showFailureSnackBar(context, 'state.message');
        //
        //     }
        //   },
        //   child: isLoading
        //       ? const Center(child: CircularProgressIndicator())
        //       : errorMessage != null
        //       ? Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.red)))
        //       : SingleChildScrollView(
        //     padding: const EdgeInsets.all(16),
        //     child: Column(
        //       children: [
        //         Center(
        //           child: Stack(
        //             children: [
        //               CircleAvatar(
        //                 radius: 50,
        //                 backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
        //                 child: _selectedImage == null ? const Icon(Icons.person, size: 50) : null,
        //               ),
        //               Positioned(
        //                 bottom: 0,
        //                 right: 0,
        //                 child: IconButton(
        //                   icon: const Icon(Icons.edit),
        //                   onPressed: () {
        //                     showModalBottomSheet(
        //                       context: context,
        //                       builder: (_) {
        //                         return Wrap(
        //                           children: [
        //                             ListTile(
        //                               leading: const Icon(Icons.camera),
        //                               title: const Text("Camera"),
        //                               onTap: () {
        //                                 Navigator.pop(context);
        //                                 pickImage(ImageSource.camera);
        //                               },
        //                             ),
        //                             ListTile(
        //                               leading: const Icon(Icons.photo_library),
        //                               title: const Text("Gallery"),
        //                               onTap: () {
        //                                 Navigator.pop(context);
        //                                 pickImage(ImageSource.gallery);
        //                               },
        //                             ),
        //                           ],
        //                         );
        //                       },
        //                     );
        //                   },
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //         const SizedBox(height: 20),
        //         _buildTextField("Name", nameController, readOnly: true),
        //         const SizedBox(height: 10),
        //         _buildTextField("Phone", mobileController),
        //         const SizedBox(height: 10),
        //         _buildTextField("Password", passwordController, obscureText: true),
        //         const SizedBox(height: 10),
        //         _buildTextField("Email", emailController),
        //         const SizedBox(height: 20),
        //         SizedBox(
        //           width: double.infinity,
        //           child: ElevatedButton(
        //             onPressed: handleUpdateProfileAndImage,
        //             style: ElevatedButton.styleFrom(
        //
        //               backgroundColor: AppTheme.Navblue1,
        //               padding: const EdgeInsets.symmetric(vertical: 16),
        //
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(8),
        //               ),
        //             ),
        //             child: const Text("Save", style: TextStyle(color: AppTheme.white1, ),),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),)
        body:
            Stack(children: [
              Positioned(
                top: 15,
                left: 0,
                right: 0,
                child: NoInternetBanner(isConnected: isConnected),
              ),

        RefreshIndicator(
        onRefresh: _refreshProfile,
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoading) {
              setState(() {
                isLoading = true;
                errorMessage = null;
              });
            } else if (state is ProfileUpdated) {
              setState(() {
                isLoading = false;
              });
              showSuccessSnackBar(context, "Profile updated successfully!");
            } else if (state is ProfilePhotoUploaded) {
              setState(() {
                isLoading = false;
              });
              showSuccessSnackBar(context, "Profile photo uploaded successfully!");
            } else if (state is ProfilePhotoUploadError) {
              setState(() {
                isLoading = false;
                errorMessage = state.message;
              });
              showFailureSnackBar(context, state.message);
            } else if (state is ProfileError) {
              setState(() {
                isLoading = false;
                errorMessage = state.message;
              });
              showFailureSnackBar(context, state.message);
            }
          },
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.red)))
              : ListView( // <-- Wrap everything inside ListView
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                      child: _selectedImage == null ? const Icon(Icons.person, size: 50) : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) {
                              return Wrap(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.camera),
                                    title: const Text("Camera"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      pickImage(ImageSource.camera);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text("Gallery"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      pickImage(ImageSource.gallery);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField("Name", nameController, readOnly: true),
              const SizedBox(height: 10),
              _buildTextField("Phone", mobileController),
              const SizedBox(height: 10),
              _buildTextField("Password", passwordController, obscureText: true),
              const SizedBox(height: 10),
              _buildTextField("Email", emailController),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: handleUpdateProfileAndImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.Navblue1,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Save", style: TextStyle(color: AppTheme.white1)),
                ),
              ),
            ],
          ),
        ),
      ),
            ],)
    ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false, bool readOnly = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }





}
