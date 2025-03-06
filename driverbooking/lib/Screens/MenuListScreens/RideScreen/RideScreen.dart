import 'dart:convert';

import 'package:driverbooking/Bloc/AppBloc_State.dart';
import 'package:driverbooking/Bloc/App_Bloc.dart';
import 'package:driverbooking/Bloc/AppBloc_Events.dart';
import 'package:flutter/material.dart';
import 'package:driverbooking/Utils/AllImports.dart';
import 'package:driverbooking/Networks/Api_Service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();

    // BlocProvider.of<TripSheetClosedValuesBloc>(context).add(
    //   TripsheetStatusClosed(username: widget.username, userid: widget.userId),
    // );
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


        BlocProvider.of<TripSheetClosedValuesBloc>(context).add(
          TripsheetStatusClosed(
              drivername: userData?['drivername'] ?? 'Notttyu Found',
              userid: widget.userId),
        );

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


        body: BlocBuilder<TripSheetClosedValuesBloc,TripSheetClosedValuesState>(builder: (context, state){
          if(state is TripSheetStatusClosedLoading){
            return CircularProgressIndicator();
          } else if(state is TripsheetStatusClosedLoaded){
            return state.tripSheetClosedData.isEmpty ?
            const Center(
              child: Text('No trip sheet data found.', style: TextStyle(color:Colors.green ),),
            ):ListView.builder(
              itemCount: state.tripSheetClosedData.length,
              itemBuilder: (context, index) {
                final trip = state.tripSheetClosedData[index];
                return SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomCard(
                name: '${trip['guestname']}',
                // image: AppConstants.sample,
                vehicle: '${trip['vehicleName']}',
                status: '${trip['apps']}',
                dateTime: '${trip['tripsheetdate']}',
                startAddress: '${trip['address1']}',
                endAddress: '${trip['useage']}',
              ),
              // CustomCard(
              //   name: 'Rohit',
              //   // image: AppConstants.sample,
              //   vehicle: 'Mercedes',
              //   price: '\$500.75',
              //   dateTime: 'Wed 20 Nov, 2024 9:00 am',
              //   startAddress: '12 MG Road, Bangalore',
              //   endAddress: '24 Residency Road, Bangalore',
              // ),
            ],
          ),
        );

            },
          );

        } else {
        return const Center(child: Text('Something went wrong.'));
        }
        })

      // body:BlocBuilder<TripSheetClosedValuesBloc,TripSheetClosedValuesState>(builder: (context, state){
      //   if(state is TripSheetStatusClosedLoading){
      //     return CircularProgressIndicator();
      //   } else if(state is TripsheetStatusClosedLoaded){
      //     return state.tripSheetClosedData.isEmpty ?
      //         const Center(
      //       child: Text('No trip sheet data found.', style: TextStyle(color:Colors.green ),),
      //     ):ListView.builder(
      //       itemCount: state.tripSheetClosedData.length,
      //       itemBuilder: (context, index) {
      //         final trip = state.tripSheetClosedData[index];
      //         return Column(
      //           children: [
      //             buildSection(
      //               context,
      //               title: '${trip['duty']}',
      //               dateTime: ' ${trip['tripid']}',
      //               buttonText: '${trip['apps']}',
      //               onTap: () {
      //
      //               },
      //             ),
      //           ],
      //         );
      //       },
      //     );
      //
      // } else {
      //     return const Center(child: Text('Something went wrong.'));
      //   }
      // })

    );

  }
}
