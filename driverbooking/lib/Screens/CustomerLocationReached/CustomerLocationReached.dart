import 'package:flutter/material.dart';

class Customerlocationreached extends StatefulWidget {
  const Customerlocationreached({super.key});

  @override
  State<Customerlocationreached> createState() => _CustomerlocationreachedState();
}

class _CustomerlocationreachedState extends State<Customerlocationreached> {
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Text("Customer"),
      ),
      body: SingleChildScrollView(
        child: Text("customer location"),
      ),
    );
  }
}
