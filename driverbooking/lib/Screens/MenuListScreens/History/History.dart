import 'package:driverbooking/Utils/AllImports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  DateTime? fromDate;
  DateTime? toDate;

  final List<Map<String, dynamic>> allData = [
    {'date': DateTime(2024, 11, 1), 'description': 'Order #1', 'amount': 100},
    {'date': DateTime(2024, 11, 10), 'description': 'Order #2', 'amount': 200},
    {'date': DateTime(2024, 11, 20), 'description': 'Order #3', 'amount': 300},
    {'date': DateTime(2024, 11, 25), 'description': 'Order #4', 'amount': 150},
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
    sheetObject.appendRow(["Date", "Description", "Amount"]);

    // Add rows
    for (var row in filteredData) {
      sheetObject.appendRow([
        DateFormat('dd MMM yyyy').format(row['date']),
        row['description'],
        row['amount'],
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File downloaded to $filePath')),
        );
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving file: $e')),
        );
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
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.resolveWith(
                            (states) => AppTheme.lightBlue,
                          ),
                          columns: const [
                            DataColumn(
                              label: Text(
                                "Date",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Description",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Amount",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                          rows: filteredData.map((item) {
                            return DataRow(
                              cells: [
                                DataCell(Text(DateFormat('dd MMM yyyy')
                                    .format(item['date']))),
                                DataCell(Text(item['description'])),
                                DataCell(Text("\$${item['amount']}")),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
