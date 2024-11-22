import 'package:flutter/material.dart';
import 'package:driverbooking/Utils/AllImports.dart';

class Ridescreen extends StatefulWidget {
  const Ridescreen({super.key});

  @override
  State<Ridescreen> createState() => _RidescreenState();
}

class _RidescreenState extends State<Ridescreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
     appBar: AppBar(
       title: Text("My Rides"),
       
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

      body:SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Add spacing
              padding: EdgeInsets.all(16), // Inner padding
              decoration: BoxDecoration(
                color: Colors.white, // Card background color
                borderRadius: BorderRadius.circular(12), // Rounded corners
                border: Border.all(color: Colors.grey.shade300), // Border color
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Shadow color
                    blurRadius: 5,
                    offset: Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                          // 'https://via.placeholder.com/150',
                            AppConstants.sample// Replace with your image URL
                        ),
                      ),
                      SizedBox(width: 12), // Space between avatar and details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ajay',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '\$300.50',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'BMW',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                            ),
                            Text(
                              'Tue 19 Nov, 2024 11:05 am',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16), // Space between rows
                  Row(
                    children: [
                      Column(
                        children: [
                          Icon(Icons.circle, color: Colors.green, size: 12),
                          Container(
                            width: 2,
                            height: 30,
                            color: Colors.grey.shade400,
                          ),
                          Icon(Icons.location_on, color: Colors.red, size: 18),
                        ],
                      ),
                      SizedBox(width: 12), // Space between icon and address
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '9 Nastaf, Saidhapet, Chennai 32',
                              style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '10 Thiruvalluvar puram, west Tambaram, chennai 45',
                              style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Add spacing
              padding: EdgeInsets.all(16), // Inner padding
              decoration: BoxDecoration(
                color: Colors.white, // Card background color
                borderRadius: BorderRadius.circular(12), // Rounded corners
                border: Border.all(color: Colors.grey.shade300), // Border color
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Shadow color
                    blurRadius: 5,
                    offset: Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                          // 'https://via.placeholder.com/150',
                            AppConstants.sample// Replace with your image URL
                        ),
                      ),
                      SizedBox(width: 12), // Space between avatar and details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ajay',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '\$300.50',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'BMW',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                            ),
                            Text(
                              'Tue 19 Nov, 2024 11:05 am',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16), // Space between rows
                  Row(
                    children: [
                      Column(
                        children: [
                          Icon(Icons.circle, color: Colors.green, size: 12),
                          Container(
                            width: 2,
                            height: 30,
                            color: Colors.grey.shade400,
                          ),
                          Icon(Icons.location_on, color: Colors.red, size: 18),
                        ],
                      ),
                      SizedBox(width: 12), // Space between icon and address
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '9 Nastaf, Saidhapet, Chennai 32',
                              style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '10 Thiruvalluvar puram, west Tambaram, chennai 45',
                              style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Add spacing
              padding: EdgeInsets.all(16), // Inner padding
              decoration: BoxDecoration(
                color: Colors.white, // Card background color
                borderRadius: BorderRadius.circular(12), // Rounded corners
                border: Border.all(color: Colors.grey.shade300), // Border color
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Shadow color
                    blurRadius: 5,
                    offset: Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                          // 'https://via.placeholder.com/150',
                            AppConstants.sample// Replace with your image URL
                        ),
                      ),
                      SizedBox(width: 12), // Space between avatar and details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ajay',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '\$300.50',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'BMW',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                            ),
                            Text(
                              'Tue 19 Nov, 2024 11:05 am',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16), // Space between rows
                  Row(
                    children: [
                      Column(
                        children: [
                          Icon(Icons.circle, color: Colors.green, size: 12),
                          Container(
                            width: 2,
                            height: 30,
                            color: Colors.grey.shade400,
                          ),
                          Icon(Icons.location_on, color: Colors.red, size: 18),
                        ],
                      ),
                      SizedBox(width: 12), // Space between icon and address
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '9 Nastaf, Saidhapet, Chennai 32',
                              style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '10 Thiruvalluvar puram, west Tambaram, chennai 45',
                              style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Add spacing
              padding: EdgeInsets.all(16), // Inner padding
              decoration: BoxDecoration(
                color: Colors.white, // Card background color
                borderRadius: BorderRadius.circular(12), // Rounded corners
                border: Border.all(color: Colors.grey.shade300), // Border color
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Shadow color
                    blurRadius: 5,
                    offset: Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                          // 'https://via.placeholder.com/150',
                            AppConstants.sample// Replace with your image URL
                        ),
                      ),
                      SizedBox(width: 12), // Space between avatar and details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ajay',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '\$300.50',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'BMW',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                            ),
                            Text(
                              'Tue 19 Nov, 2024 11:05 am',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16), // Space between rows
                  Row(
                    children: [
                      Column(
                        children: [
                          Icon(Icons.circle, color: Colors.green, size: 12),
                          Container(
                            width: 2,
                            height: 30,
                            color: Colors.grey.shade400,
                          ),
                          Icon(Icons.location_on, color: Colors.red, size: 18),
                        ],
                      ),
                      SizedBox(width: 12), // Space between icon and address
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '9 Nastaf, Saidhapet, Chennai 32',
                              style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '10 Thiruvalluvar puram, west Tambaram, chennai 45',
                              style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Add spacing
              padding: EdgeInsets.all(16), // Inner padding
              decoration: BoxDecoration(
                color: Colors.white, // Card background color
                borderRadius: BorderRadius.circular(12), // Rounded corners
                border: Border.all(color: Colors.grey.shade300), // Border color
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Shadow color
                    blurRadius: 5,
                    offset: Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                          // 'https://via.placeholder.com/150',
                            AppConstants.sample// Replace with your image URL
                        ),
                      ),
                      SizedBox(width: 12), // Space between avatar and details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ajay',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '\$300.50',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'BMW',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                            ),
                            Text(
                              'Tue 19 Nov, 2024 11:05 am',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16), // Space between rows
                  Row(
                    children: [
                      Column(
                        children: [
                          Icon(Icons.circle, color: Colors.green, size: 12),
                          Container(
                            width: 2,
                            height: 30,
                            color: Colors.grey.shade400,
                          ),
                          Icon(Icons.location_on, color: Colors.red, size: 18),
                        ],
                      ),
                      SizedBox(width: 12), // Space between icon and address
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '9 Nastaf, Saidhapet, Chennai 32',
                              style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '10 Thiruvalluvar puram, west Tambaram, chennai 45',
                              style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      )




    );
  }
}
