import 'package:driverbooking/Screens/MenuListScreens/History/EditTripDetails/EditTripDetails.dart';
import 'package:driverbooking/Utils/AllImports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:driverbooking/Networks/Api_Service.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class History extends StatefulWidget {
  final String userId;
  final String username;
  final List<Map<String, dynamic>> tripSheetData;


  const History({Key? key, required this.username, required this.userId , required this.tripSheetData})
      : super(key: key);

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

  Future<void> selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: fromDate != null && toDate != null
          ? DateTimeRange(start: fromDate!, end: toDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        fromDate = picked.start;
        toDate = picked.end;
      });
    }
  }

  Future<void> fetchFilteredData() async {
    if (fromDate == null || toDate == null) {
      print('Date range is invalid');
      return; // Don't proceed if the dates are not selected
    }

    setState(() {
      isLoading = true;
    });

    try {
      final data = await ApiService.fetchTripSheetFilteredRides(
        username: widget.username,
        startDate: fromDate,
        endDate: toDate,
      );

      setState(() {
        tripSheetData = data;
      });
      print('Filtered data: $data');
    } catch (e) {
      print('Error fetching filtered data: $e');
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
          "History",
          style: TextStyle(color: Colors.white, fontSize: AppTheme.appBarFontSize),
        ),
        backgroundColor: AppTheme.Navblue1,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () async {
              try {
                var excel = Excel.createExcel(); // Create an Excel file
                Sheet sheetObject = excel['Sheet1']; // Add data to the first sheet

                // Add header row
                sheetObject.appendRow(["Start Time", "Full Name", "Address"]);

                // Add tripSheetData to the sheet
                for (var data in tripSheetData) {
                  sheetObject.appendRow([
                    data['startdate'],
                    data['guestname'],
                    data['useage'],
                  ]);
                }

                // Get the directory to save the file
                var directory = await getApplicationDocumentsDirectory();
                String filePath = "${directory.path}/TripDetails.xlsx";

                // Save the file
                File(filePath)
                  ..createSync(recursive: true)
                  ..writeAsBytesSync(excel.save()!);

                // Show a success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Excel file saved at $filePath')),
                );
              } catch (e) {
                print('Error creating Excel file: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to save Excel file')),
                );
              }
            },
            tooltip: "Download as Excel",
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fromDate != null
                          ? "From: ${DateFormat('dd MMM yyyy').format(fromDate!)}"
                          : "From: Not Selected",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      toDate != null
                          ? "To: ${DateFormat('dd MMM yyyy').format(toDate!)}"
                          : "To: Not Selected",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: selectDateRange,
                      icon: const Icon(Icons.date_range),
                      label: const Text("Pick Dates"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.Navblue1,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (fromDate == null || toDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select a valid date range')),
                          );
                          return;
                        }
                        fetchFilteredData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Apply Filter"),
                    ),

                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              color: AppTheme.Navblue1,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                children: const [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Start Time",
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Full Name",
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Address",
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.visibility, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          // const SizedBox(height: 5),
          const SizedBox(height: 0.0),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: tripSheetData.isEmpty
                    ? const Center(
                  child: Text(
                    "No records found for the selected date range.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
                    : ListView(
                  children: tripSheetData.map((item) {
                    var trip = item['tripid'].toString();
                    return Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(trip),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditTripDetails( tripId: trip.toString()),
                                  ),
                                );
                              },
                              child: const Text(
                                "View",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
