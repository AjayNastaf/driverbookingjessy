import 'package:driverbooking/Screens/MenuListScreens/History/EditTripDetails/EditTripDetails.dart';
import 'package:driverbooking/Utils/AllImports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:driverbooking/Utils/AllImports.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  DateTime? fromDate;
  DateTime? toDate;

  final List<Map<String, dynamic>> allData = [
    {'date': DateTime(2024, 11, 1), 'CustomerName': 'Ajay', 'FromTo': 'Tambaram - Central'},
    {'date': DateTime(2024, 11, 1), 'CustomerName': 'Ajay', 'FromTo': 'Tambaram - Central'},
    {'date': DateTime(2024, 11, 1), 'CustomerName': 'Ajay', 'FromTo': 'Tambaram - Central'},
    {'date': DateTime(2024, 11, 1), 'CustomerName': 'Ajay', 'FromTo': 'Tambaram - Central'},





  ];

  List<Map<String, dynamic>> filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData = List.from(allData);
  }

  void filterData() {
    setState(() {
      if (fromDate != null && toDate != null) {
        filteredData = allData.where((item) {
          final date = item['date'] as DateTime;
          return date.isAfter(fromDate!.subtract(const Duration(days: 1))) &&
              date.isBefore(toDate!.add(const Duration(days: 1)));
        }).toList();
      } else {
        filteredData = List.from(allData);
      }
    });
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
      filterData();
    }
  }

  Future<void> downloadTableAsExcel() async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['History'];

    // Add headers
    sheetObject.appendRow(["Date", "CustomerName", "FromTo"]);

    // Add rows
    for (var row in filteredData) {
      sheetObject.appendRow([
        DateFormat('dd MMM yyyy').format(row['date']),
        row['CustomerName'],
        row['FromTo'],
      ]);
    }

    // Save file
    final fileBytes = excel.save();
    if (fileBytes != null) {
      try {
        final directory = Directory(
            '/storage/emulated/0/Documents'); // Android Downloads folder
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        String baseName = "History";
        String extension = ".xlsx";
        String filePath = "${directory.path}/$baseName$extension";

        int counter = 1;
        while (await File(filePath).exists()) {
          filePath = "${directory.path}/$baseName$counter$extension";
          counter++;
        }

        final file = File(filePath);
        await file.writeAsBytes(fileBytes, flush: true);

        // Notify the user
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('File downloaded to $filePath')),
        // );
        showInfoSnackBar(context, 'File downloaded to $filePath');
      } catch (e) {
        // Handle errors
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error saving file: $e')),
        // );
        showFailureSnackBar(context, 'Error saving file: $e');
      }
    }
  }

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
            onPressed: downloadTableAsExcel,
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
              children: [
                const Text(
                  "Filter by Date Range",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.Navblue1,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
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
                  ],
                ),
              ],
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
                child: filteredData.isEmpty
                    ? const Center(
                  child: Text(
                    "No records found for the selected date range.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
                    : Column(
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
                      height: 200.0,
                      child: SingleChildScrollView(
                        child: Column(
                          children: filteredData.map((item) {
                            return Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      DateFormat('dd MMM yyyy').format(item['date']),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(item['CustomerName']),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(item['FromTo']),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                      onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EditTripDetails()));
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
                          }).toList(),
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
