import 'package:flutter/material.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:flutter/services.dart';

class Contactscreen extends StatefulWidget {
  const Contactscreen({Key? key}) : super(key: key);

  @override
  State<Contactscreen> createState() => _ContactscreenState();
}

class _ContactscreenState extends State<Contactscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "History",
          style: TextStyle(color: Colors.white, fontSize: AppTheme.appBarFontSize),
        ),
        backgroundColor: Color(0xff4424A9),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xff4424A9),
      // body: SafeArea(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       // Current Balance Section
      //       Padding(
      //         padding: const EdgeInsets.all(16.0),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             const Text(
      //               "Current balance",
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 24,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //             const SizedBox(height: 8),
      //             const Text(
      //               "₹ 50000",
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 32,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //       // White Container with Form and History
      //       Expanded(
      //         child: Container(
      //           width: double.infinity,
      //           decoration: const BoxDecoration(
      //             color: Colors.white,
      //             borderRadius: BorderRadius.only(
      //               topLeft: Radius.circular(30),
      //               topRight: Radius.circular(30),
      //             ),
      //           ),
      //           child: Padding(
      //             padding: const EdgeInsets.all(16.0),
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 // Enter Amount Section
      //                 TextFormField(
      //                   keyboardType: TextInputType.number, // Display numeric keyboard
      //                   inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Accept only digits
      //                   decoration: InputDecoration(
      //                     hintText: "Enter Amount",
      //                     border: OutlineInputBorder(
      //                       borderRadius: BorderRadius.circular(12),
      //                     ),
      //                     suffixIcon: Container(
      //                       margin: const EdgeInsets.all(4),
      //                       decoration: BoxDecoration(
      //                         color: const Color(0xff4424A9),
      //                         borderRadius: BorderRadius.circular(8),
      //                       ),
      //                       child: const Icon(
      //                         Icons.arrow_forward,
      //                         color: Colors.white,
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //
      //                 const SizedBox(height: 16),
      //                 // History Section
      //                 const Text(
      //                   "History",
      //                   style: TextStyle(
      //                     fontSize: 20,
      //                     fontWeight: FontWeight.bold,
      //                     color: Colors.black54,
      //                   ),
      //                 ),
      //                 const SizedBox(height: 16),
      //                 // History List
      //                 Expanded(
      //                   child: ListView.builder(
      //                     itemCount: 8,
      //                     itemBuilder: (context, index) {
      //                       final isDebit = index % 2 != 0;
      //                       return Padding(
      //                         padding: const EdgeInsets.symmetric(vertical: 8.0),
      //                         child: Row(
      //                           children: [
      //                             Container(
      //                               width: 35,
      //                               height: 35,
      //                               decoration: BoxDecoration(
      //                                 color: isDebit ? Colors.red : Colors.green,
      //                                 borderRadius: BorderRadius.circular(4),
      //                               ),
      //                             ),
      //                             const SizedBox(width: 16),
      //                             Expanded(
      //                               child: Column(
      //                                 crossAxisAlignment: CrossAxisAlignment.start,
      //                                 children: [
      //                                   Text(
      //                                     "400000 ${isDebit ? '-' : '+'} 10000",
      //                                     style: const TextStyle(
      //                                       fontSize: 16,
      //                                       fontWeight: FontWeight.bold,
      //                                     ),
      //                                   ),
      //                                   const Text(
      //                                     "22/01/2024",
      //                                     style: TextStyle(
      //                                       fontSize: 14,
      //                                       color: Colors.grey,
      //                                     ),
      //                                   ),
      //                                 ],
      //                               ),
      //                             ),
      //                             const Text(
      //                               "₹ 50000",
      //                               style: TextStyle(
      //                                 fontSize: 17,
      //                                 fontWeight: FontWeight.bold,
      //                                 color: Colors.black54,
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                       );
      //                     },
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}