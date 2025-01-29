import 'package:flutter/material.dart';
import 'package:driverbooking/Utils/AllImports.dart';
import 'package:driverbooking/Networks/Api_Service.dart';

class Ridescreen extends StatefulWidget {
  final String userId ;
  final String username;

  // const Ridescreen({super.key, required this.userId});
  const Ridescreen({Key? key, required this.userId, required this.username})
      : super(key: key);
  @override
  State<Ridescreen> createState() => _RidescreenState();
}

class _RidescreenState extends State<Ridescreen> {
  List<Map<String, dynamic>> tripSheetData = [];
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeData();
  }
  Future<void> _initializeData() async {
    try {
      final data = await ApiService.fetchTripSheetClosedRides(
        userId: widget.userId,
        username: widget.username,
      );
      setState(() {
        tripSheetData = data;
      });
    } catch (e) {
      print('Error initializing data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "My Rides",
            style: TextStyle(
                color: Colors.white, fontSize: AppTheme.appBarFontSize),
          ),
          backgroundColor: AppTheme.Navblue1,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        // body: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Container(
        //       decoration: BoxDecoration(
        //         color: Colors.white, // Background color of the container
        //         borderRadius: BorderRadius.circular(8), // Rounded corners
        //         border: Border.all(
        //           color: Colors.grey, // Border color
        //           width: 2, // Border width
        //         ),
        //       ),
        //       child: Card(
        //         color: Colors.pink,
        //         elevation: 15.0,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(8), // Match border radius
        //         ),
        //         child: Padding(
        //           padding: const EdgeInsets.all(16.0), // Add padding inside the card
        //           child: Row(
        //             children: [
        //               // Circular Image
        //               CircleAvatar(
        //                 radius: 30,
        //                 backgroundImage: AssetImage('assets/sample.jpg'), // Replace with your image asset
        //               ),
        //               SizedBox(width: 16), // Spacing between image and text
        //
        //               // Text and Amount
        //               Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Text(
        //                     "Name or Label",
        //                     style: TextStyle(
        //                       color: Colors.white,
        //                       fontSize: 18,
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                   ),
        //                   SizedBox(height: 8), // Spacing between label and amount
        //                   Text(
        //                     "\$123.45",
        //                     style: TextStyle(
        //                       color: Colors.white,
        //                       fontSize: 16,
        //                       fontWeight: FontWeight.w600,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //
        //
        //   ],
        // ),

        // body: const SingleChildScrollView(
        //   child: Column(
        //     // mainAxisAlignment: MainAxisAlignment.start,
        //     children: [
        //       CustomCard(
        //         name: 'Ajay',
        //         image: AppConstants.sample,
        //         vehicle: 'BMW',
        //         price: '\$300.50',
        //         dateTime: 'Tue 19 Nov, 2024 11:05 am',
        //         startAddress: '9 Nastaf, Saidhapet, Chennai 32',
        //         endAddress: '10 Thiruvalluvar puram, west Tambaram, Chennai 45',
        //       ),
        //       CustomCard(
        //         name: 'Rohit',
        //         image: AppConstants.sample,
        //         vehicle: 'Mercedes',
        //         price: '\$500.75',
        //         dateTime: 'Wed 20 Nov, 2024 9:00 am',
        //         startAddress: '12 MG Road, Bangalore',
        //         endAddress: '24 Residency Road, Bangalore',
        //       ),
        //     ],
        //   ),
        // )

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : tripSheetData.isEmpty
          ? const Center(
        child: Text('No trip sheet data found.'),
      )
          : ListView.builder(
        itemCount: tripSheetData.length,
        itemBuilder: (context, index) {
          final trip = tripSheetData[index];
          return Column(
            children: [
              buildSection(
                context,
                title: '${trip['duty']}',
                dateTime: ' ${trip['tripid']}',
                buttonText: '${trip['apps']}',
                onTap: () {

                },
              ),
            ],
          );
        },
      ),

    );

  }
}
