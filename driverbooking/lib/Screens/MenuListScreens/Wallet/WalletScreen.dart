import 'package:flutter/material.dart';

class Walletscreen extends StatefulWidget {
  const Walletscreen({super.key});

  @override
  State<Walletscreen> createState() => _WalletscreenState();
}

class _WalletscreenState extends State<Walletscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Info'),),
      body: Center(
        child: Text(
          "Current Apk version is 7 (16.06.2025),",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
