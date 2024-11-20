import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  final String username;
  final String password;
  final String phonenumber;
  final String email;

  const ProfileScreen({
    Key? key,
    required this.username,
    required this.password,
    required this.phonenumber,
    required this.email,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers to manage input field values
  late final TextEditingController nameController;
  late final TextEditingController mobileController;
  late final TextEditingController passwordController;
  late final TextEditingController emailController;

  bool isValueCorrect = false;

  File? _profileImage; // To store the selected image
  final ImagePicker _picker = ImagePicker(); // ImagePicker instance

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with initial values from the widget
    nameController = TextEditingController(text: widget.username);
    mobileController = TextEditingController(text: widget.phonenumber);
    passwordController = TextEditingController(text: widget.password);
    emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    nameController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  // Function to pick an image from the gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!) as ImageProvider
                          : null,
                      child: _profileImage == null
                          ? const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey,
                      )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.black),
                        onPressed: () {
                          // Show options to pick image
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SafeArea(
                                child: Wrap(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.camera),
                                      title: const Text('Camera'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _pickImage(ImageSource.camera);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.photo_library),
                                      title: const Text('Gallery'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _pickImage(ImageSource.gallery);
                                      },
                                    ),
                                  ],
                                ),
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
              _buildInputField("${widget.phonenumber}", nameController),
              const SizedBox(height: 16),
              _buildInputField("Mobile Number", mobileController, keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              _buildInputField("Password", passwordController, obscureText: true),
              const SizedBox(height: 16),
              _buildInputField("Email ID", emailController, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: isValueCorrect,
                    onChanged: (value) {
                      setState(() {
                        isValueCorrect = value ?? false;
                      });
                    },
                  ),
                  const Text('Above Mentioned values are correct'),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Save changes logic
                    print("Name: ${nameController.text}");
                    print("Mobile: ${mobileController.text}");
                    print("Password: ${passwordController.text}");
                    print("Email: ${emailController.text}");
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
        ),
      ],
    );
  }
}
