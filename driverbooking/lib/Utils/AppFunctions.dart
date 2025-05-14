import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

void showSuccessSnackBar(BuildContext context, String message) {
  Flushbar(
    message: message,
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    duration: const Duration(seconds: 2),
    backgroundColor: Colors.green,
    flushbarPosition: FlushbarPosition.TOP,
    icon: const Icon(
      Icons.check_circle,
      size: 28.0,
      color: Colors.white,
    ),
  ).show(context);
}

void showFailureSnackBar(BuildContext context, String message) {
  Flushbar(
    message: message,
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.red,
    flushbarPosition: FlushbarPosition.TOP,
    icon: const Icon(
      Icons.close,
      size: 28.0,
      color: Colors.white,
    ),
  ).show(context);
}

void showWarningSnackBar(BuildContext context, String message) {
  Flushbar(
    message: message,
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.orange,
    flushbarPosition: FlushbarPosition.TOP,
    icon: const Icon(
      Icons.warning,
      size: 28.0,
      color: Colors.white,
    ),
  ).show(context);
}

void showInfoSnackBar(BuildContext context, String message) {
  Flushbar(
    message: message,
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.blue,
    flushbarPosition: FlushbarPosition.TOP,
    icon: const Icon(
      Icons.info_outline,
      size: 28.0,
      color: Colors.white,
    ),
  ).show(context);
}



// from DestinationLocationScreen
final List<Map<String, String>> recentLocations = [
  {
    'title': 'Anna Salai, Chennai',
    'subtitle': '123 Anna Salai, Chennai, Tamil Nadu 600002'
  },
  {
    'title': 'Velachery Main Road, Chennai',
    'subtitle': '45 Velachery Main Road, Chennai, Tamil Nadu 600042'
  },
  {
    'title': 'OMR, Chennai',
    'subtitle': '99 Old Mahabalipuram Road, Chennai, Tamil Nadu 600097'
  },
  {
    'title': 'Poonamallee High Road, Chennai',
    'subtitle': '78 Poonamallee High Road, Chennai, Tamil Nadu 600010'
  },
];



//home page
// Widget buildSection(
//     BuildContext context, {
//       required String title,
//       required String dateTime,
//       required String buttonText,
//       required VoidCallback onTap,
//     }) {
//   return GestureDetector(
//     onTap: onTap,
//     child: Container(
//       margin: EdgeInsets.only(bottom: 16.0),
//       padding: EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 6.0,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
//           ),
//           Divider(thickness: 1, color: Colors.grey.shade300),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 dateTime,
//                 style: TextStyle(color: Colors.grey, fontSize: 14.0),
//               ),
//               ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orange,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20.0),
//                   ),
//                 ),
//                 child: Text(buttonText),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }


//
// Widget buildSection(
//     BuildContext context, {
//       required String title,
//       required String dateTime,
//       required String buttonText,
//       required VoidCallback onTap,
//     }) {
//   // Determine button color based on buttonText value
//   Color buttonColor;
//   switch (buttonText.toLowerCase()) {
//     case "waiting":
//       buttonColor = Colors.orange;
//       break;
//     case "accept":
//       buttonColor = Colors.green;
//       break;
//     case "on_going":
//       buttonColor = Colors.red;
//       break;
//     default:
//       buttonColor = Colors.blue; // Default color if no match
//   }
//
//   return GestureDetector(
//     onTap: onTap,
//     child: Container(
//       margin: EdgeInsets.only(bottom: 16.0),
//       padding: EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 6.0,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
//           ),
//           Divider(thickness: 1, color: Colors.grey.shade300),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 dateTime,
//                 style: TextStyle(color: Colors.grey, fontSize: 14.0),
//               ),
//               ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: buttonColor,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20.0),
//                   ),
//                 ),
//                 child: Text(buttonText),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }



Widget buildSection(
    BuildContext context, {
      required String title,
      required String dateTime,
      required String buttonText,
      required VoidCallback? onTap,
      required bool isEnabled,  // New parameter to control button state
    }) {
  // Determine button color based on buttonText value
  Color buttonColor;
  switch (buttonText.toLowerCase()) {
    case "waiting":
      buttonColor = Colors.orange;
      break;
    case "accept":
      buttonColor = Colors.green;
      break;
    case "on_going":
      buttonColor = Colors.red;
      break;
    default:
      buttonColor = Colors.blue;
  }

  return GestureDetector(
    onTap: isEnabled ? onTap : null,  // Disable onTap if not enabled
    child: Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          Divider(thickness: 1, color: Colors.grey.shade300),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateTime,
                style: const TextStyle(color: Colors.grey, fontSize: 14.0),
              ),
              ElevatedButton(
                onPressed: isEnabled ? onTap : null,  // Disable button if not enabled
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEnabled ? buttonColor : Colors.grey,  // Show disabled color
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(buttonText),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
















//profile page
Widget buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
  );
}



// rideScreen'
class CustomCard extends StatelessWidget {
  final String name;
  // final String image;
  final String vehicle;
  final String status;
  final String dateTime;
  final String startAddress;
  final String endAddress;

  const CustomCard({
    required this.name,
    // required this.image,
    required this.vehicle,
    required this.status,
    required this.dateTime,
    required this.startAddress,
    required this.endAddress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Spacing
      padding: const EdgeInsets.all(16), // Inner padding
      decoration: BoxDecoration(
        color: Colors.white, // Card background color
        borderRadius: BorderRadius.circular(12), // Rounded corners
        border: Border.all(color: Colors.grey.shade300), // Border color
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Shadow color
            blurRadius: 5,
            offset: const Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CircleAvatar(
              //   radius: 30,
              //   backgroundImage: AssetImage(image), // Dynamic image
              // ),
              const SizedBox(width: 12), // Space between avatar and details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Adjust padding as needed
                          decoration: BoxDecoration(
                            color: Colors.orange, // Background color
                            borderRadius: BorderRadius.circular(8), // Rounded corners
                          ),
                          child: Text(
                            status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),

                      ],
                    ),
                    Text(
                      vehicle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      dateTime,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16), // Space between rows
          Row(
            children: [
              Column(
                children: [
                  const Icon(Icons.circle, color: Colors.green, size: 12),
                  Container(
                    width: 2,
                    height: 30,
                    color: Colors.grey.shade400,
                  ),
                  const Icon(Icons.location_on, color: Colors.red, size: 18),
                ],
              ),
              const SizedBox(width: 12), // Space between icon and address
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      startAddress,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      endAddress,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


// Edit trip detials screen
Widget buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}





