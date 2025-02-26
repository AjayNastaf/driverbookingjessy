import 'package:driverbooking/Screens/MenuListScreens/History/EditTripDetails/EditTripDetails.dart';
import 'package:driverbooking/Utils/AllImports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:driverbooking/Networks/Api_Service.dart';

class History extends StatefulWidget {
  final String userId;
  final String username;
  const History({Key? key , required this.username, required this.userId} ) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  DateTime? fromDate;
  DateTime? toDate;
  List<Map<String, dynamic>> tripSheetData = [];
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _initializeData();
  }
  // Future<void> _initializeData() async {
  //   try {
  //     print('Fetching trip sheet data...'); // Before the API call
  //     final data = await ApiService.fetchTripSheetClosedRides(
  //       userId: widget.userId,
  //       username: widget.username,
  //     );
  //     print('User details fetched History: $data'); // After successful data fetch
  //
  //     setState(() {
  //       tripSheetData = data;
  //     });
  //   } catch (e) {
  //     print('Error initializing data: $e'); // On error
  //   } finally {
  //     print('Setting loading state to false...'); // Before setting loading state
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "History",
            style: TextStyle(color: Colors.white, fontSize: AppTheme.appBarFontSize)
        ),
        backgroundColor: AppTheme.Navblue1,
        iconTheme: const IconThemeData(
          color:
              Colors.white, // Change back button (leading icon) color to white
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.download,
              color: Colors.white,
            ),
            onPressed: (){},
            tooltip: "Download as Excel",
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            // color: Color(0xFF373751).withOpacity(0.1),
            child: Column(
              // children: [
              //   const Text(
              //     "Filter by Date Range",
              //     style: TextStyle(
              //       fontSize: 18,
              //       fontWeight: FontWeight.bold,
              //       color: AppTheme.Navblue1,
              //     ),
              //   ),
              //   const SizedBox(height: 10),
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             fromDate != null
              //                 ? "From: ${DateFormat('dd MMM yyyy').format(fromDate!)}"
              //                 : "From: Not Selected",
              //             style: const TextStyle(fontSize: 16),
              //           ),
              //           const SizedBox(height: 5),
              //           Text(
              //             toDate != null
              //                 ? "To: ${DateFormat('dd MMM yyyy').format(toDate!)}"
              //                 : "To: Not Selected",
              //             style: const TextStyle(fontSize: 16),
              //           ),
              //         ],
              //       ),
              //       ElevatedButton.icon(
              //         onPressed: selectDateRange,
              //         icon: const Icon(Icons.date_range),
              //         label: const Text("Pick Dates"),
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: AppTheme.Navblue1,
              //           foregroundColor: Colors.white,
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(8),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ],
            ),
          ),

          const SizedBox(height: 20),
          Expanded(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                // child: filteredData.isEmpty
                //     ? const Center(
                //   child: Text(
                //     "No records found for the selected date range.",
                //     style: TextStyle(fontSize: 16, color: Colors.grey),
                //   ),
                // )
                //     :
                child:   Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Fixed Header Row
                    Container(
                      color: AppTheme.lightBlue,
                      child: Row(
                        children: const [
                          Expanded(
                            flex: 2, // Adjust flex for column width
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Date",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3, // Adjust flex for column width
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Customer Name",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3, // Adjust flex for column width
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "From To",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1, // Adjust flex for column width
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.remove_red_eye, // Use eye-like icon
                                color: Colors.white, // Set color to white
                                size: 24.0, // Optional: Adjust size if needed
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Scrollable Data Rows
                    SizedBox(
                      height: 400.0,

                      child: SingleChildScrollView(
                        child: Column(
                          children: tripSheetData.map((item) { {
                            return Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      item['startdate'],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(item['guestname']),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(item['useage']),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                      onPressed: () {
                                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>EditTripDetails()));
                                      },
                                      child: Text(
                                        "View",
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                  ),
                                ),


                              ],
                            );
                          }}
                          ).toList(),

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
