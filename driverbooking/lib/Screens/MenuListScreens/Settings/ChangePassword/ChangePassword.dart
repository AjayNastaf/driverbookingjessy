import 'package:jessy_cabs/Screens/ForgotPassword/ForgotPassword.dart';
import 'package:jessy_cabs/Screens/LoginScreen/Login_Screen.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:jessy_cabs/Bloc/App_Bloc.dart';
import 'package:jessy_cabs/Bloc/AppBloc_Events.dart';
import 'package:jessy_cabs/Bloc/AppBloc_State.dart';
import 'package:another_flushbar/flushbar.dart';

class ChangePasswordScreen extends StatelessWidget {
  final String userId;

  const ChangePasswordScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CheckCurrentPasswordBloc()),
        BlocProvider(create: (_) => UpdatePasswordBloc()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Change Password",
            style: TextStyle(
                color: Colors.white, fontSize: AppTheme.appBarFontSize),
          ),
          backgroundColor: AppTheme.Navblue1,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: ChangePasswordScreenContent(userId: userId),
      ),
    );
  }
}

class ChangePasswordScreenContent extends StatefulWidget {
  final String userId;

  const ChangePasswordScreenContent({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<ChangePasswordScreenContent> createState() =>
      _ChangePasswordScreenContentState();
}

class _ChangePasswordScreenContentState
    extends State<ChangePasswordScreenContent> {
  late TextEditingController currentPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController reEnterNewPasswordController;
  bool isVerified = false; // Toggles the new password field visibility
  bool isCurrentPasswordEmpty = false;
  bool isNewpasswordError = false;
  bool isReEnterpasswordError = false;

  @override
  void initState() {
    super.initState();
    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    reEnterNewPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CheckCurrentPasswordBloc, CheckCurrentPasswordState>(
          listener: (context, state) {
            if (state is CheckCurrentPasswordLoading) {
              // _showSnackBar(context, "Verifying current password...");
            } else if (state is CheckCurrentPasswordCompleted) {
              // _showSnackBar(context, "Password verified successfully!");
              showSuccessSnackBar(context, "Password verified successfully!");
              setState(() {
                isVerified = true;
              });
            } else if (state is CheckCurrentPasswordFailure) {
              // _showSnackBar(context, "Error: ${state.error}");
              showFailureSnackBar(context, "Password verification failed!");
            }
          },
        ),
        BlocListener<UpdatePasswordBloc, UpdatePasswordState>(
          listener: (context, state) {
            if (state is UpdatePasswordLoading) {
              // _showSnackBar(context, "Updating password...");
            } else if (state is UpdatePasswordCompleted) {
              // _showSnackBar(context, "Password updated successfully!");
              Navigator.pop(context);
              showSuccessSnackBar(context, "Password updated successfully!");
            } else if (state is UpdatePasswordFailure) {
              // _showSnackBar(context, "Error: ${state.error}");
              showFailureSnackBar(context, "Password Update failed!");
            }
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentPasswordField(context),
            if (isVerified) _buildNewPasswordField(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPasswordField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Enter Current Password",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter Current Password",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isCurrentPasswordEmpty
                          ? Colors.red
                          : Colors.grey, // Condition for border color
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isCurrentPasswordEmpty
                          ? Colors.red
                          : Colors.blue, // Red when there's an error
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      isCurrentPasswordEmpty = true;
                    });
                  } else {
                    setState(() {
                      isCurrentPasswordEmpty = false;
                    });
                  }
                },
              ),
            ),
            if (!isVerified) ...[
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  final password = currentPasswordController.text.trim();
                  if (password.isNotEmpty) {
                    setState(() {
                      isCurrentPasswordEmpty = false;
                    });
                    context.read<CheckCurrentPasswordBloc>().add(
                          CheckCurrentPasswordAttempt(
                            userId: widget.userId,
                            password: password,
                          ),
                        );
                  } else {
                    _showSnackBar(context, "Please enter a valid password.");
                    setState(() {
                      isCurrentPasswordEmpty = true;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppTheme.Navblue1, // Set background color here
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ]
          ],
        ),
        if (isCurrentPasswordEmpty) ...[
          Text(
            'This field should not be empty',
            style: TextStyle(color: Colors.red),
          ),
        ],
        if (!isVerified) ...[
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ForgotPassword()));
            },
            child: Text('Forgot Password?'),
          ),
          const SizedBox(height: 10),
        ]
      ],
    );
  }

  Widget _buildNewPasswordField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          "Enter New Password",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: newPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Enter New Password",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isNewpasswordError
                    ? Colors.red
                    : Colors.grey, // Condition for border color
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isNewpasswordError
                    ? Colors.red
                    : Colors.blue, // Red when there's an error
                width: 2,
              ),
            ),
          ),
          onChanged: (value) {
            if (value.isEmpty || value.length < 6) {
              setState(() {
                isNewpasswordError = true;
              });
            } else {
              setState(() {
                isNewpasswordError = false;
              });
            }
          },
        ),
        if (isNewpasswordError) ...[
          Text(
            'Password should have minimum 6 characters',
            style: TextStyle(color: Colors.red),
          ),
        ],
        const SizedBox(height: 20),
        const Text(
          "Re-enter New Password",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: reEnterNewPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Re-enter New Password",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isReEnterpasswordError
                    ? Colors.red
                    : Colors.grey, // Condition for border color
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isReEnterpasswordError
                    ? Colors.red
                    : Colors.blue, // Red when there's an error
                width: 2,
              ),
            ),
          ),
        ),
        if (isReEnterpasswordError) ...[
          Text(
            'Password do not match',
            style: TextStyle(color: Colors.red),
          ),
        ],
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final newPassword = newPasswordController.text.trim();
            final reEnterNewPassword = reEnterNewPasswordController.text.trim();
            if (newPassword.isEmpty || newPassword.length < 6) {
              setState(() {
                isNewpasswordError = true;
              });
              return;
            } else {
              setState(() {
                isNewpasswordError = false;
              });
            }
            if (newPassword != reEnterNewPassword ||
                reEnterNewPassword.isEmpty) {
              _showSnackBar(context, "password is not matching.");
              setState(() {
                isReEnterpasswordError = true;
              });
              return;
            } else {
              setState(() {
                isReEnterpasswordError = false;
              });
            }
            if (newPassword.isNotEmpty &&
                reEnterNewPassword.isNotEmpty &&
                newPassword == reEnterNewPassword) {
              context.read<UpdatePasswordBloc>().add(
                    UpdatePasswordAttempt(
                      userId: widget.userId,
                      newPassword: newPassword,
                    ),
                  );
            } else {
              _showSnackBar(context, "Please enter a new password.");
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.Navblue1, // Set background color here
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text("Submit", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
