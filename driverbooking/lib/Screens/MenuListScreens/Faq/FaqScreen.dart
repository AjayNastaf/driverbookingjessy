import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  final List<Map<String, String>> data = [
    {'title': 'What is this app about?', 'content': 'This app helps you book vehicles quickly and conveniently.'},
    {'title': 'How can I book a ride?', 'content': 'Navigate to the booking section and select your ride.'},
    {'title': 'Can I cancel my booking?', 'content': 'Yes, cancellations can be done in the "My Bookings" section.'},
    {'title': 'How do I contact support?', 'content': 'You can contact support via email or the app support page.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs', style: TextStyle(color: Colors.white, fontSize: AppTheme.appBarFontSize),),
        backgroundColor: AppTheme.Navblue1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ExpansionTile(
              title: Text(data[index]['title']!),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(data[index]['content']!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}