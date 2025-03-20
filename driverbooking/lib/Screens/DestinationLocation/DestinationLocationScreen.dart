import 'package:flutter/material.dart';
import 'package:jessy_cabs/Utils/AppFunctions.dart';


class Destinationlocationscreen extends StatefulWidget {
  const Destinationlocationscreen({super.key});

  @override
  State<Destinationlocationscreen> createState() => _DestinationlocationscreenState();
}

class _DestinationlocationscreenState extends State<Destinationlocationscreen> {

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();


  // final List<Map<String, String>> recentLocations = [
  //   {
  //     'title': 'Anna Salai, Chennai',
  //     'subtitle': '123 Anna Salai, Chennai, Tamil Nadu 600002'
  //   },
  //   {
  //     'title': 'Velachery Main Road, Chennai',
  //     'subtitle': '45 Velachery Main Road, Chennai, Tamil Nadu 600042'
  //   },
  //   {
  //     'title': 'OMR, Chennai',
  //     'subtitle': '99 Old Mahabalipuram Road, Chennai, Tamil Nadu 600097'
  //   },
  //   {
  //     'title': 'Poonamallee High Road, Chennai',
  //     'subtitle': '78 Poonamallee High Road, Chennai, Tamil Nadu 600010'
  //   },
  // ];





  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Location Input
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left-side icons
                Column(
                  children: [
                    Icon(Icons.my_location, color: Colors.green, size: 24),
                    Container(
                      width: 2,
                      height: 80,
                      color: Colors.grey.shade400,
                    ),
                    Icon(Icons.location_on, color: Colors.red, size: 24),
                  ],
                ),
                SizedBox(width: 10), // Add spacing between icons and fields

                // Input fields
                Expanded(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Current Location",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter your destination",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

            SizedBox(height: 20),

            // Home and Work
            ListTile(
              leading: Icon(Icons.home, color: Colors.green),
              title: Text("Home"),
            ),
            ListTile(
              leading: Icon(Icons.work, color: Colors.green),
              title: Text("Work"),
            ),
            SizedBox(height: 20),

            // Recent Locations
            Text("Recent", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: recentLocations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.location_on, color: Colors.grey),
                    title: Text(recentLocations[index]['title'] ?? ''),
                    subtitle: Text(recentLocations[index]['subtitle'] ?? ''),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
