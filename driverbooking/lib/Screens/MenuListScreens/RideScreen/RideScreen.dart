import 'dart:convert';

import 'package:jessy_cabs/Bloc/AppBloc_State.dart';
import 'package:jessy_cabs/Bloc/App_Bloc.dart';
import 'package:jessy_cabs/Bloc/AppBloc_Events.dart';
import 'package:jessy_cabs/Screens/MenuListScreens/RideScreen/EditRideDetails/EditRideDetails.dart';
import 'package:flutter/material.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:jessy_cabs/Networks/Api_Service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:jessy_cabs/Screens/NoInternetBanner/NoInternetBanner.dart';
import 'package:provider/provider.dart';
import 'package:jessy_cabs/Screens/network_manager.dart';


class Ridescreen extends StatefulWidget {
  final String userId ;
  final String username;

  // final String trip;

  // const Ridescreen({super.key, required this.userId});
  const Ridescreen({Key? key, required this.userId, required this.username})
      : super(key: key);
  @override
  State<Ridescreen> createState() => _RidescreenState();
}

class _RidescreenState extends State<Ridescreen> {
  List<Map<String, dynamic>> tripSheetData = [];
  bool isLoading = true;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();

    // BlocProvider.of<TripSheetClosedValuesBloc>(context).add(
    //   TripsheetStatusClosed(username: widget.username, userid: widget.userId),
    // );
    _loadUserData();
    // context.read<TripClosedTodayBloc>().add(FetchTripClosedToday(widget.username));

  }

  Future<void> _refreshridescreen() async {
    _loadUserData();
    // context.read<TripClosedTodayBloc>().add(FetchTripClosedToday(widget.username));

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
        String driverName = decodedData['drivername']; // Change key if needed
        context.read<TripClosedTodayBloc>().add(FetchTripClosedToday(driverName));





        // BlocProvider.of<TripSheetClosedValuesBloc>(context).add(
        //   TripsheetStatusClosed(
        //       drivername: userData?['drivername'] ?? 'Notttyu Found',
        //       userid: widget.userId),
        // );

        // context.read<DrawerDriverDataBloc>().add(DrawerDriverData(widget.username));
      } catch (e) {
        print("Error decoding userData: $e");
      }
    } else {
      print("No userData found or it's empty in SharedPreferences.");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _initializeData();
  }
  Future<void> _initializeData() async {
    try {
      final data = await ApiService.fetchTripSheetClosedRides(
        userId: widget.userId,
        // username: widget.username,
        drivername: userData?['drivername'] ?? 'Notttyu Found',

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

  String setFormattedDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "Not available"; // Handle null case

    try {
      DateTime parsedDate = DateTime.parse(dateStr); // Parse the date from DB
      return DateFormat('dd-MM-yyyy').format(parsedDate); // Format to dd/MM/yyyy
    } catch (e) {
      return "Invalid date"; // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isConnected = Provider.of<NetworkManager>(context).isConnected;

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


        // body: BlocBuilder<TripSheetClosedValuesBloc,TripSheetClosedValuesState>(builder: (context, state){
        //   if(state is TripSheetStatusClosedLoading){
        //     return CircularProgressIndicator();
        //   } else if(state is TripsheetStatusClosedLoaded){
        //     return state.tripSheetClosedData.isEmpty ?
        //     const Center(
        //       child: Text('No trip sheet data found.', style: TextStyle(color:Colors.green ),),
        //     ):ListView.builder(
        //       itemCount: state.tripSheetClosedData.length,
        //       itemBuilder: (context, index) {
        //         final trip = state.tripSheetClosedData[index];
        //         var tripId = trip['tripid'].toString();
        //
        //         return SingleChildScrollView(
        //   child: Column(
        //     // mainAxisAlignment: MainAxisAlignment.start,
        //     children: [
        //       GestureDetector(
        //       onTap: () {
        //             // Handle navigation or any other action
        //             print("Card tapped: ${trip['tripid']}");
        //             print("Card tapped: ${userData?['tripid']}");
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => EditRideDetails(tripId: tripId),
        //           ),
        //         );
        //       },
        //         child:
        //       CustomCard(
        //         // name: '${trip['guestname']}',
        //         name: '${trip['tripid']}',
        //         // image: AppConstants.sample,
        //         vehicle: '${trip['vehicleName']}',
        //         status: '${trip['apps']}',
        //
        //         // dateTime: '${trip['tripsheetdate']}',
        //         dateTime: setFormattedDate(trip['tripsheetdate']),
        //         startAddress: '${trip['address1']}',
        //         endAddress: '${trip['useage']}',
        //       ),
        //       )
        //     ],
        //   ),
        // );
        //
        //     },
        //   );
        //
        // } else {
        // return const Center(child: Text('Something went wrong.'));
        // }
        // })

      // body: BlocBuilder<TripClosedTodayBloc, TripClosedTodayState>(
      //   builder: (context, state) {
      //     if (state is TripClosedTodayLoading) {
      //       return Center(child: CircularProgressIndicator());
      //     } else if (state is TripClosedTodayLoaded) {
      //       if (state.trips.isEmpty) {
      //         return Center(child: Text('No closed trips found.'));
      //       }
      //       return ListView.builder(
      //         itemCount: state.trips.length,
      //         itemBuilder: (context, index) {
      //           return ListTile(
      //             title: Text(state.trips[index]['tripid'].toString() ?? 'Unnamed Trip'),
      //             subtitle: Text(state.trips[index]['closedate'] ?? 'No Date'),
      //           );
      //         },
      //       );
      //     } else if (state is TripClosedTodayError) {
      //       return Center(child: Text('Error: ${state.message}'));
      //     }
      //     return Center(child: Text('No Data Available'));
      //   },
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     context.read<TripClosedTodayBloc>().add(FetchTripClosedToday(widget.username));
      //   },
      //   child: Icon(Icons.refresh),
      // ),


      body:

          Stack(
            children: [
              Positioned(
                top: 15,
                left: 0,
                right: 0,
                child: NoInternetBanner(isConnected: isConnected),
              ),

      RefreshIndicator(
        onRefresh: _refreshridescreen, // This function is triggered on pull-to-refresh
        // Ensures pull-to-refresh always works

        child:  BlocBuilder<TripClosedTodayBloc, TripClosedTodayState>(
        builder: (context, state) {
          if (state is TripClosedTodayLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TripClosedTodayLoaded) {
            if (state.trips.isEmpty) {
              return const Center(
                child: Text('No trip sheet data found.', style: TextStyle(color: Colors.green)),
              );
            }
            return ListView.builder(
              itemCount: state.trips.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final trip = state.trips[index];
                var tripId = trip['tripid'].toString();

                return GestureDetector(
                  onTap: () {
                    print("Card tapped: ${trip['tripid']}");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditRideDetails(tripId: tripId),
                      ),
                    );
                  },
                  child: CustomCard(
                    // name: trip['guestname'].toString() ?? 'Unknown Trip',
                    name: trip['tripid'].toString() ?? 'Unknown Trip',
                    vehicle: trip['vehicleName'] ?? 'Unknown Vehicle',
                    status: trip['apps'] ?? 'Unknown Status',
                    dateTime: setFormattedDate(trip['tripsheetdate']),
                    startAddress: trip['address1'] ?? 'No Address',
                    endAddress: trip['useage'] ?? 'Unknown Usage',
                  ),
                );
              },
            );
          } else if (state is TripClosedTodayError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Something went wrong.'));
        },
      ),),

            ],
          )
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     context.read<TripClosedTodayBloc>().add(FetchTripClosedToday(widget.username));
      //   },
      //   child: const Icon(Icons.refresh),
      // ),


    );



  }
}
