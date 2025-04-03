import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart'; // For a modern icon

class NoInternetBanner extends StatelessWidget {
  final bool isConnected;

  const NoInternetBanner({Key? key, required this.isConnected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500), // Smooth animation
      child: !isConnected
          ? Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Colors.redAccent, Colors.deepOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.wifiOff, color: Colors.white, size: 24), // Modern icon
            const SizedBox(width: 10),
            const Text(
              "No Internet Connection!",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      )
          : const SizedBox.shrink(),
    );
  }
}
