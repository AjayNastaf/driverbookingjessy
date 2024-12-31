import 'package:driverbooking/Utils/AllImports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:driverbooking/Bloc/AppBloc_Events.dart';
import 'package:driverbooking/Bloc/AppBloc_State.dart';
import 'package:driverbooking/Bloc/App_Bloc.dart';
import 'package:driverbooking/Screens/HomeScreen/HomeScreen.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatelessWidget {
  final String userId, username, password, phonenumber, email;

  const ProfileScreen({
    Key? key,
    required this.userId,
    required this.username,
    required this.password,
    required this.phonenumber,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateUserBloc(),
      child: ProfileScreenContent(
        userId: userId,
        username: username,
        password: password,
        phonenumber: phonenumber,
        email: email,
      ),
    );
  }
}

class ProfileScreenContent extends StatefulWidget {
  final String userId, username, password, phonenumber, email;

  const ProfileScreenContent({
    Key? key,
    required this.userId,
    required this.username,
    required this.password,
    required this.phonenumber,
    required this.email,
  }) : super(key: key);

  @override
  State<ProfileScreenContent> createState() => _ProfileScreenContentState();
}

class _ProfileScreenContentState extends State<ProfileScreenContent> {
  late TextEditingController nameController;
  late TextEditingController mobileController;
  late TextEditingController passwordController;
  late TextEditingController emailController;

  File? profileImage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.username);
    mobileController = TextEditingController(text: widget.phonenumber);
    passwordController = TextEditingController(text: widget.password);
    emailController = TextEditingController(text: widget.email);
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image first")),
      );
      return;
    }

    try {
      const String apiUrl = "${AppConstants.baseUrl}/upload-image";
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add the image file with the correct key
      request.files.add(await http.MultipartFile.fromPath(
        'image', // Match this with the key expected in your API
        profileImage!.path,
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image uploaded successfully!")),
        );
        debugPrint("Response: $responseBody");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to upload image")),
        );
        debugPrint("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
      debugPrint("Exception: $e");
    }

    context.read<UpdateUserBloc>().add(
      UpdateUserAttempt(
        userId: widget.userId,
        username: nameController.text,
        password: passwordController.text,
        phone: mobileController.text,
        email: emailController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style:
          TextStyle(color: Colors.white, fontSize: AppTheme.appBarFontSize),
        ),
        backgroundColor: AppTheme.Navblue1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<UpdateUserBloc, UpdateUserState>(
        listener: (context, state) {
          if (state is UpdateUserCompleted) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('Details updated')),
            // );
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Homescreen(userId: widget.userId,
                      username: widget.username,  // Add this line to pass username

                    )));

            showSuccessSnackBar(context, 'Details updated');
          } else if (state is UpdateUserFailure) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text(state.error)),
            // );
            showFailureSnackBar(context, "${state.error}");
          }
        },
        builder: (context, state) {
          if (state is UpdateUserLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage!)
                            : null,
                        child: profileImage == null
                            ? const Icon(Icons.person, size: 50)
                            : null,
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
                buildTextField("Name", nameController),
                const SizedBox(height: 10),
                buildTextField("Phone", mobileController),
                const SizedBox(height: 10),
                buildTextField("Password", passwordController,
                    obscureText: true),
                const SizedBox(height: 10),
                buildTextField("Email", emailController),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    //   context.read<UpdateUserBloc>().add(
                    //         UpdateUserAttempt(
                    //           userId: widget.userId,
                    //           username: nameController.text,
                    //           password: passwordController.text,
                    //           phone: mobileController.text,
                    //           email: emailController.text,
                    //         ),
                    //       );
                    _uploadImage();
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.Navblue1,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

// Widget _buildTextField(String label, TextEditingController controller,
//     {bool obscureText = false}) {
//   return TextField(
//     controller: controller,
//     obscureText: obscureText,
//     decoration: InputDecoration(
//       labelText: label,
//       border: const OutlineInputBorder(),
//     ),
//   );
// }
}