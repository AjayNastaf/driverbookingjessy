import 'package:driverbooking/Screens/HomeScreen/HomeScreen.dart';
import 'package:driverbooking/Screens/LoginScreen/Login_Screen.dart';
import 'package:driverbooking/Screens/PickupScreen/PickupScreen.dart';
import 'package:driverbooking/Utils/AppTheme.dart';
import 'package:flutter/material.dart';

class Bookingdetails extends StatefulWidget {
  const Bookingdetails({super.key});

  @override
  State<Bookingdetails> createState() => _BookingdetailsState();
}

class _BookingdetailsState extends State<Bookingdetails> {

  String address = 'no 17 Thiruvalluvar puram, West Tambaram, irumbiliyur, chennai-45'; // The value you want to send


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Booking Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
             Table(
              border: TableBorder.all(
                color: Colors.grey, // Border color
                width: 1.0, // Border width
              ),
              columnWidths: {
                0: FlexColumnWidth(1), // First column takes 1 part of space
                1: FlexColumnWidth(1), // Second column takes 2 parts of space
              },
              children: [
                // Table Header
                TableRow(
                  decoration: BoxDecoration(
                    color: AppTheme.Navblue1, // Header background color
                  ),
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Content',
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Details',
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                      ),
                    ),
                  ],
                ),
                // Table Rows
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Trip sheet number'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('1175'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Trip Date'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('2024-04-19'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Report Time'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('18:19'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Duty Type'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Local'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Report Time'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('18:19'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Vehicle Time'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('sedan BMW'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Company Name'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('natsaf'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Guest Name'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Ajay'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Contact Number'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('8667551412'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Address'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(address),
                    ),
                  ],
                ),

              ],

            ),
            SizedBox(height: 20.0,),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Pickupscreen(address: address)));
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), // Add padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  side: BorderSide(color:AppTheme.Navblue1, width: 2.0), // Add border
                ),
                backgroundColor: AppTheme.Navblue1, // Background color
                foregroundColor: Colors.white, // Text color
              ),
              child: Text(
                "Accept",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold), // Increase font size
              ),
            ),
            
          ],
        ),



      ),
    );
  }
}
