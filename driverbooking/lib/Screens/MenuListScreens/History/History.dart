import 'dart:convert';

import 'package:driverbooking/Screens/MenuListScreens/History/EditTripDetails/EditTripDetails.dart';
import 'package:driverbooking/Utils/AllImports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:driverbooking/Networks/Api_Service.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Bloc/AppBloc_Events.dart';
import '../../../Bloc/AppBloc_State.dart';
import '../../../Bloc/App_Bloc.dart';


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
  Map<String, dynamic>? userData;


  //
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // _initializeData();
  // }
  //
  // Future<void> _initializeData() async {
  //   try {
  //     final data = await ApiService.fetchTripSheetClosedRides(
  //       userId: widget.userId,
  //       username: widget.username,
  //     );
  //
  //     setState(() {
  //       tripSheetData = data;
  //     });
  //   } catch (e) {
  //     print('Error initializing data: $e');
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    print("📢 Dispatching FetchTripSheetClosedRides event");
    // context.read<TripSheetBloc>().add(FetchTripSheetClosedRides(
    //   userId: widget.userId,
    //   drivername: widget.username,
    // ));

    _loadUserData();
  }


  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');

    print("Retrieved userData String: $userDataString");

    if (userDataString != null && userDataString.isNotEmpty) {
      try {
        Map<String, dynamic> decodedData = jsonDecode(userDataString);

        setState(() {
          userData = decodedData;
        });

        print("After setState, userDatam: $userData");

        // 🚀 Move the event dispatch here, after userData is loaded




        context.read<TripSheetBloc>().add(FetchTripSheetClosedRides(
          userId: widget.userId,
          drivername: userData?['drivername'] ?? 'Notttyu Found',
        ));

        // context.read<DrawerDriverDataBloc>().add(DrawerDriverData(widget.username));
      } catch (e) {
        print("Error decoding userData: $e");
      }
    } else {
      print("No userData found or it's empty in SharedPreferences.");
    }
  }

  // Future<void> selectDateRange() async {
  //   final picked = await showDateRangePicker(
  //     context: context,
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime.now(),
  //     initialDateRange: fromDate != null && toDate != null
  //         ? DateTimeRange(start: fromDate!, end: toDate!)
  //         : null,
  //   );
  //
  //   if (picked != null) {
  //     setState(() {
  //       fromDate = picked.start;
  //       toDate = picked.end;
  //     });
  //   }
  // }
  //
  // Future<void> fetchFilteredData() async {
  //   if (fromDate == null || toDate == null) {
  //     print('Date range is invalid');
  //     return; // Don't proceed if the dates are not selected
  //   }
  //
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   try {
  //     final data = await ApiService.fetchTripSheetFilteredRides(
  //       username: widget.username,
  //       startDate: fromDate,
  //       endDate: toDate,
  //     );
  //
  //     setState(() {
  //       tripSheetData = data;
  //     });
  //     print('Filtered data: $data');
  //   } catch (e) {
  //     print('Error fetching filtered data: $e');
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

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

  void fetchFilteredData() {
    if (fromDate == null || toDate == null) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Please select a valid date range')),
      // );
      showWarningSnackBar(context, 'Please select a valid date range');
      return;
    }

    context.read<FetchFilteredRidesBloc>().add(FetchFilteredRides(
      // username: widget.username,
      drivername: userData?['drivername'] ?? 'Notttyu Found',
      startDate: fromDate!,
      endDate: toDate!,
    ));
  }

  Future<void> _downloadExcel() async {
    var excel = Excel.createExcel();

    // Remove the default empty sheet
    String defaultSheet = excel.sheets.keys.first; // Get the first (default) sheet
    excel.delete(defaultSheet); // Delete it

    // Create a new sheet with your desired name
    Sheet sheet = excel['Trip Sheet'];

    // Add headers
    sheet.appendRow(['Start Time', 'Full Name', 'Address']);

    // Fetch data from the state
    final state = context.read<FetchFilteredRidesBloc>().state;
    if (state is FetchFilteredRidesLoaded) {
      for (var trip in state.tripSheetData) {
        sheet.appendRow([
          trip['tripid'].toString(),
          trip['guestname'],
          trip['useage'],
        ]);
      }
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('No data to export!')),
      // );
      showFailureSnackBar(context, 'No data to export!');
      return;
    }

    // Request storage permission
    // var status = await Permission.storage.request();
    var status = await Permission.manageExternalStorage.request();

    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission denied!')),
      );
      return;
    }

    // Save the file in the Downloads folder
    Directory? downloadsDirectory;
    if (Platform.isAndroid) {
      downloadsDirectory = Directory('/storage/emulated/0/Download'); // Android Downloads folder
    } else {
      downloadsDirectory = await getDownloadsDirectory(); // For iOS & other platforms
    }

    if (downloadsDirectory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not access Downloads folder!')),
      );
      return;
    }

    String filePath = path.join(downloadsDirectory.path, 'TripSheet.xlsx');

    // Write the file
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    // Open the file
    OpenFile.open(filePath);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('File saved to $filePath')),
    );
  }
  // Future<void> _downloadExcel() async {
  //   var excel = Excel.createExcel();
  //   Sheet sheet = excel['Trip Sheet'];
  //
  //   // Add headers
  //   sheet.appendRow(['Start Time', 'Full Name', 'Address']);
  //
  //   // Fetch data from the state
  //   final state = context.read<FetchFilteredRidesBloc>().state;
  //   if (state is FetchFilteredRidesLoaded) {
  //     for (var trip in state.tripSheetData) {
  //       sheet.appendRow([
  //         trip['tripid'].toString(),
  //         trip['guestname'],
  //         trip['useage'],
  //       ]);
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('No data to export!')),
  //     );
  //     return;
  //   }
  //
  //   // Request storage permission
  //   // var status = await Permission.storage.request();
  //     var status = await Permission.manageExternalStorage.request();
  //
  //   if (!status.isGranted) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Storage permission denied!')),
  //     );
  //     return;
  //   }
  //
  //   // Save the file in the Downloads folder
  //   Directory? downloadsDirectory;
  //   if (Platform.isAndroid) {
  //     downloadsDirectory = Directory('/storage/emulated/0/Download'); // Android Downloads folder
  //   } else {
  //     downloadsDirectory = await getDownloadsDirectory(); // For iOS & other platforms
  //   }
  //
  //   if (downloadsDirectory == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Could not access Downloads folder!')),
  //     );
  //     return;
  //   }
  //
  //   String filePath = path.join(downloadsDirectory.path, 'TripSheet.xlsx');
  //
  //   // Write the file
  //   File(filePath)
  //     ..createSync(recursive: true)
  //     ..writeAsBytesSync(excel.encode()!);
  //
  //   // Open the file
  //   OpenFile.open(filePath);
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('File saved to $filePath')),
  //   );
  // }

  // Future<void> _downloadExcel() async {
  //   var excel = Excel.createExcel();
  //   Sheet sheet = excel['Trip Sheet'];
  //
  //   // Add headers
  //   sheet.appendRow(['Start Time', 'Full Name', 'Address']);
  //
  //   // Fetch data from the state
  //   final state = context.read<FetchFilteredRidesBloc>().state;
  //   if (state is FetchFilteredRidesLoaded) {
  //     for (var trip in state.tripSheetData) {
  //       sheet.appendRow([
  //         trip['tripid'].toString(),
  //         trip['guestname'],
  //         trip['useage'],
  //       ]);
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('No data to export!')),
  //     );
  //     return;
  //   }
  //
  //   // Save to file
  //   // var status = await Permission.storage.request();
  //   var status = await Permission.manageExternalStorage.request();
  //
  //   if (!status.isGranted) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Storage permission denied!')),
  //     );
  //     return;
  //   }
  //
  //   // Get the directory and save the file
  //   final directory = await getApplicationDocumentsDirectory();
  //   String filePath = '${directory.path}/TripSheet.xlsx';
  //   File(filePath)
  //     ..createSync(recursive: true)
  //     ..writeAsBytesSync(excel.encode()!);
  //
  //   // Open the file
  //   OpenFile.open(filePath);
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('File saved to $filePath')),
  //   );
  // }


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
            // onPressed: () async {
            //   // Request storage permission
            //   // PermissionStatus status = await Permission.storage.request();
            //   PermissionStatus status = await Permission.manageExternalStorage.request();
            //
            //   if (status.isDenied) {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(content: Text('Storage permission is required to download the file.')),
            //     );
            //     return;
            //   } else if (status.isPermanentlyDenied) {
            //     openAppSettings(); // Open settings if permanently denied
            //     return;
            //   }
            //
            //   try {
            //     var excel = Excel.createExcel();
            //     Sheet sheetObject = excel['Sheet1'];
            //
            //     // Add header row
            //     sheetObject.appendRow(["Start Time", "Full Name", "Address"]);
            //
            //     // Add tripSheetData to the sheet
            //     for (var data in tripSheetData) {
            //       sheetObject.appendRow([
            //         data['startdate'],
            //         data['guestname'],
            //         data['useage'],
            //       ]);
            //     }
            //
            //     // Try to use the Downloads folder
            //     Directory? directory = Directory('/storage/emulated/0/Download');
            //
            //     // If directory does not exist, fallback to external storage
            //     if (!await directory.exists()) {
            //       directory = await getExternalStorageDirectory();
            //     }
            //
            //     // Handle null case
            //     if (directory == null) {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         const SnackBar(content: Text('Could not access storage. Please try again.')),
            //       );
            //       return;
            //     }
            //
            //     String filePath = "${directory.path}/TripDetails.xlsx";
            //
            //     // Save the file
            //     File(filePath)
            //       ..createSync(recursive: true)
            //       ..writeAsBytesSync(excel.save()!);
            //
            //     // Show success message
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(content: Text('Excel file downloaded to: $filePath')),
            //     );
            //   } catch (e) {
            //     print('Error creating Excel file: $e');
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(content: Text('Failed to download Excel file')),
            //     );
            //   }
            // },
            onPressed: () async {
              await _downloadExcel();
            },            tooltip: "Download as Excel",
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
          // Expanded(
          //   child: Card(
          //     margin: const EdgeInsets.symmetric(horizontal: 16),
          //     elevation: 4,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: BlocBuilder<TripSheetBloc, TripSheetState>(
          //         builder: (context, state) {
          //           print("🖥️ UI State: $state");
          //
          //           if (state is TripSheetLoading) {
          //             return const Center(child: CircularProgressIndicator());
          //           } else if (state is TripSheetLoaded) {
          //             print("🎉 Data loaded: ${state.tripSheetData.length} items");
          //
          //             if (state.tripSheetData.isEmpty) {
          //               return const Center(
          //                 child: Text(
          //                   "No records found for the selected date range.",
          //                   style: TextStyle(fontSize: 16, color: Colors.grey),
          //                 ),
          //               );
          //             }
          //
          //             return ListView(
          //               children: state.tripSheetData.map((item) {
          //                 var trip = item['tripid'].toString();
          //                 return Row(
          //                   children: [
          //                     Expanded(
          //                       flex: 3,
          //                       child: Padding(
          //                         padding: const EdgeInsets.all(8.0),
          //                         child: Text(trip),
          //                       ),
          //                     ),
          //                     Expanded(
          //                       flex: 2,
          //                       child: Padding(
          //                         padding: const EdgeInsets.all(8.0),
          //                         child: Text(item['guestname']),
          //                       ),
          //                     ),
          //                     Expanded(
          //                       flex: 2,
          //                       child: Padding(
          //                         padding: const EdgeInsets.all(8.0),
          //                         child: Text(item['useage']),
          //                       ),
          //                     ),
          //                     Expanded(
          //                       flex: 2,
          //                       child: Padding(
          //                         padding: const EdgeInsets.all(8.0),
          //                         child: TextButton(
          //                           onPressed: () {
          //                             Navigator.push(
          //                               context,
          //                               MaterialPageRoute(
          //                                 builder: (context) => EditTripDetails(tripId: trip),
          //                               ),
          //                             );
          //                           },
          //                           child: const Text(
          //                             "View",
          //                             style: TextStyle(fontSize: 16.0),
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 );
          //               }).toList(),
          //             );
          //           } else if (state is TripSheetError) {
          //             print("❗ Error State: ${state.message}");
          //             return Center(child: Text(state.message));
          //           }
          //
          //           return const Center(child: Text('No data available'));
          //         },
          //       ),
          //     ),
          //   ),
          // ),

          // Expanded(
          //   child: BlocBuilder<FetchFilteredRidesBloc, FetchFilteredRidesState>(
          //     builder: (context, state) {
          //       if (state is FetchFilteredRidesLoading) {
          //         return const Center(child: CircularProgressIndicator());
          //       } else if (state is FetchFilteredRidesLoaded) {
          //         final tripSheetData = state.tripSheetData;
          //         return
          //
          //           ListView.builder(
          //           itemCount: tripSheetData.length,
          //           itemBuilder: (context, index) {
          //             final data = tripSheetData[index];
          //             return ListTile(
          //               title: Text(data['guestname']),
          //               subtitle: Text(data['useage']),
          //               trailing: Text(data['startdate']),
          //             );
          //           },
          //         );
          //       } else if (state is FetchFilteredRidesError) {
          //         return Center(child: Text(state.message));
          //       }
          //       return const Center(child: Text("Select a date range to fetch data."));
          //     },
          //   ),
          // ),


          Expanded(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<FetchFilteredRidesBloc, FetchFilteredRidesState>(
                  builder: (context, state) {
                    if (state is FetchFilteredRidesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is FetchFilteredRidesLoaded) {
                      final tripSheetData = state.tripSheetData;
                      return

                        ListView.builder(
                            itemCount: tripSheetData.length,
                            itemBuilder: (context, index) {
                              final data = tripSheetData[index];
                              var trip = data['tripid'].toString();
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
                                  child: Text(data['guestname']),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(data['useage']),
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
                                          builder: (context) => EditTripDetails(tripId: trip),
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
                        });
                      // );
                    } else if (state is FetchFilteredRidesError) {
                      return Center(child: Text(state.message));
                    }
                    return const Center(child: Text("Select a date range to fetch data."));
                  },
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }




  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text(
  //         "History",
  //         style: TextStyle(color: Colors.white, fontSize: AppTheme.appBarFontSize),
  //       ),
  //       backgroundColor: AppTheme.Navblue1,
  //       iconTheme: const IconThemeData(color: Colors.white),
  //     ),
  //     body: Column(
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     fromDate != null
  //                         ? "From: ${DateFormat('dd MMM yyyy').format(fromDate!)}"
  //                         : "From: Not Selected",
  //                     style: const TextStyle(fontSize: 16),
  //                   ),
  //                   const SizedBox(height: 5),
  //                   Text(
  //                     toDate != null
  //                         ? "To: ${DateFormat('dd MMM yyyy').format(toDate!)}"
  //                         : "To: Not Selected",
  //                     style: const TextStyle(fontSize: 16),
  //                   ),
  //                 ],
  //               ),
  //               Column(
  //                 children: [
  //                   ElevatedButton.icon(
  //                     onPressed: selectDateRange,
  //                     icon: const Icon(Icons.date_range),
  //                     label: const Text("Pick Dates"),
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: AppTheme.Navblue1,
  //                       foregroundColor: Colors.white,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 10),
  //                   ElevatedButton(
  //                     onPressed: fetchFilteredData,
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.green,
  //                       foregroundColor: Colors.white,
  //                     ),
  //                     child: const Text("Apply Filter"),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //         Expanded(
  //           child: BlocBuilder<FetchFilteredRidesBloc, FetchFilteredRidesState>(
  //             builder: (context, state) {
  //               if (state is FetchFilteredRidesLoading) {
  //                 return const Center(child: CircularProgressIndicator());
  //               } else if (state is FetchFilteredRidesLoaded) {
  //                 final tripSheetData = state.tripSheetData;
  //                 return ListView.builder(
  //                   itemCount: tripSheetData.length,
  //                   itemBuilder: (context, index) {
  //                     final data = tripSheetData[index];
  //                     return ListTile(
  //                       title: Text(data['guestname']),
  //                       subtitle: Text(data['useage']),
  //                       trailing: Text(data['startdate']),
  //                     );
  //                   },
  //                 );
  //               } else if (state is FetchFilteredRidesError) {
  //                 return Center(child: Text(state.message));
  //               }
  //               return const Center(child: Text("Select a date range to fetch data."));
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

}
