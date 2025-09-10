import 'dart:io';
import 'package:flutter/material.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';

            Future<void> S(BuildContext context) async {
  if (!Platform.isAndroid) return;

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool alreadyShown = prefs.getBool('battery_dialog_shown') ?? false;

  if (alreadyShown) return;

  // Show dialog
  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("Battery Optimization"),
      content: Text(
        "To keep Jessy Cabs running in the background:\n\n"
            "• Set battery usage to 'No restrictions'\n"
            "• Enable background activity\n"
            "• Enable auto-launch\n\n"
            "Would you like to open settings now?",
      ),
      actions: [
        TextButton(
          onPressed: () async {
            const intent = AndroidIntent(
              action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
              data: 'package:com.example.jessy_cabs', // ✅ Replace if your package is different
            );
            await intent.launch();
            Navigator.of(context).pop();
          },
          child: Text("Open Settings"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Maybe Later"),
        ),
      ],
    ),
  );

  await prefs.setBool('battery_dialog_shown', true); // Show only once
}

