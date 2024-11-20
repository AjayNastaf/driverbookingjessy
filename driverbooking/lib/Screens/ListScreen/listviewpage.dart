import 'package:flutter/material.dart';
 import '../../Utils/AppTheme.dart';
import '../../Networks/Api_Service.dart';
import '../../Networks/Api_Config.dart';
import 'dart:async';

class listviewpage extends StatefulWidget {
  const listviewpage({super.key});

  @override
  State<listviewpage> createState() => _listviewpageState();
}

class _listviewpageState extends State<listviewpage> {



  // final ApiService apiService = ApiService(apiUrl: 'https://jsonplaceholder.typicode.com/posts'); // Ensure this is correctly defined

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List View", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0,),),
        backgroundColor: AppTheme.whatsappGreen,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search)),
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert)),

        ],
      ),

      body: FutureBuilder<List<dynamic>>(
        future: apiService.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}'); // Log error for debugging

            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            final items = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey.shade300,
                    child: Text(
                      item['id'].toString(), // Render ID in CircleAvatar
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    item['title'], // Render title
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(item['body']), // Render body in subtitle
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "10:30 AM", // You can replace this with actual time if needed
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green, // Replace with your desired color
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                            item['userId'].toString(), // Unread message count, adjust as necessary
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Handle tap to open chat or perform another action
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
