import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

void showSuccessSnackBar(BuildContext context, String message) {
  Flushbar(
    message: message,
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    duration: const Duration(seconds: 2),
    backgroundColor: Colors.green,
    flushbarPosition: FlushbarPosition.TOP,
    icon: const Icon(
      Icons.check_circle,
      size: 28.0,
      color: Colors.white,
    ),
  ).show(context);
}

void showFailureSnackBar(BuildContext context, String message) {
  Flushbar(
    message: message,
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.red,
    flushbarPosition: FlushbarPosition.TOP,
    icon: const Icon(
      Icons.close,
      size: 28.0,
      color: Colors.white,
    ),
  ).show(context);
}

void showWarningSnackBar(BuildContext context, String message) {
  Flushbar(
    message: message,
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.orange,
    flushbarPosition: FlushbarPosition.TOP,
    icon: const Icon(
      Icons.warning,
      size: 28.0,
      color: Colors.white,
    ),
  ).show(context);
}

void showInfoSnackBar(BuildContext context, String message) {
  Flushbar(
    message: message,
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.blue,
    flushbarPosition: FlushbarPosition.TOP,
    icon: const Icon(
      Icons.info_outline,
      size: 28.0,
      color: Colors.white,
    ),
  ).show(context);
}


