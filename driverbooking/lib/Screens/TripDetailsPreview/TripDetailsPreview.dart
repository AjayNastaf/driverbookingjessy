import 'package:jessy_cabs/Networks/Api_Service.dart';
import 'package:jessy_cabs/Screens/TollParkingUpload/TollParkingUpload.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:flutter/material.dart';
import 'package:jessy_cabs/Screens/SignatureEndRide/SignatureEndRide.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jessy_cabs/Bloc/App_Bloc.dart';
import 'package:jessy_cabs/Bloc/AppBloc_Events.dart';
import 'package:jessy_cabs/Bloc/AppBloc_State.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../NoInternetBanner/NoInternetBanner.dart';
import 'package:provider/provider.dart';
import '../network_manager.dart';
import '../HomeScreen/HomeScreen.dart';


class TripDetailsPreview extends StatefulWidget {
  final String tripId;
  const TripDetailsPreview({super.key, required this.tripId});

  @override
  State<TripDetailsPreview> createState() => _TripDetailsPreviewState();
}

class _TripDetailsPreviewState extends State<TripDetailsPreview> {

  DateTime? startingDate;
  DateTime? closingDate;
  bool isStartKmEnabled = true; // Only Start KM and Close KM are enabled
  bool isCloseKmEnabled = true;

  final TextEditingController tripIdController = TextEditingController();
  final TextEditingController guestNameController = TextEditingController();
  final TextEditingController guestMobileController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController startKmController = TextEditingController();
  final TextEditingController closeKmController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController closeDateController = TextEditingController();

  String? startingImageUrl;
  String? endingImageUrl;
  bool isLoading = true;




  @override
  void initState() {
    super.initState();
    // _loadTripSheetDetailsByTripId();
    context.read<TripSheetDetailsTripIdBloc>().add(FetchTripDetailsByTripIdEventClass(tripId: widget.tripId));
      fetchImages(); // Make sure fetchImages is being called
    saveScreenData();
  }

  Future<void> _refreshTripDetails() async {
    // Re-fetch the trip details using BLoC
    context.read<TripSheetDetailsTripIdBloc>().add(FetchTripDetailsByTripIdEventClass(tripId: widget.tripId));
    saveScreenData();
    fetchImages(); // Make sure fetchImages is being called


  }



  Future<void> saveScreenData() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('last_screen', 'TripDetailsPreview');

    await prefs.setString('trip_id', widget.tripId);





    print('Saved screen data:');

    print('last_screen: TripDetailsPreview');

    print('trip_id: ${widget.tripId}');



  }



  Future<void> _loadTripSheetDetailsByTripId() async {
    try {
      // Fetch trip details from the API
      final tripDetails = await ApiService.fetchTripDetails(widget.tripId);
      print('Trip details fetchedd: $tripDetails');
      if (tripDetails != null) {

        var tripIdvalue = tripDetails['tripid'].toString();
        var guestNameValue = tripDetails['guestname'];
        var guestmobilevalue = tripDetails['guestmobileno'].toString();
        var vectypeValue = tripDetails['vehType'].toString();
        var startkmvalue = tripDetails['startkm'].toString();
        var closekmvalue = tripDetails['closekm'].toString();
        var startdatevalue = tripDetails['startdate'].toString();
        var closedatevalue = tripDetails['closedate'].toString();
        print('Trip details guest: $tripDetails');

        setState(() {
          // Populate the form fields with the fetched data
          tripIdController.text = tripIdvalue ?? '';
          guestNameController.text = guestNameValue ?? '';
          guestMobileController.text = guestmobilevalue?? '';
          vehicleTypeController.text = vectypeValue ?? '';
          startKmController.text = startkmvalue ?? '';
          closeKmController.text = closekmvalue ?? '';
          startDateController.text = startdatevalue ?? '';
          closeDateController.text = closedatevalue ?? '';
        });

      } else {
        print('No trip details found.');
      }
    } catch (e) {
      print('Error loading trip details: $e');
    }
  }

  Future<void> _pickDate(BuildContext context, bool isStartingDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartingDate) {
          startingDate = pickedDate;
        } else {
          closingDate = pickedDate;
        }
      });
    }
  }

  void _openCameraOrFiles() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Open Camera'),
              onTap: () {
                Navigator.pop(context);
                // Add camera logic
              },
            ),
            ListTile(
              leading: Icon(Icons.file_upload),
              title: Text('Upload File'),
              onTap: () {
                Navigator.pop(context);
                // Add file upload logic
              },
            ),
          ],
        );
      },
    );
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



  Future<void> fetchImages() async {
    final String apiUrll = '${AppConstants.baseUrl}/get-images'; // Your server URL

    try {
      final response = await http.get(Uri.parse(apiUrll));
      print('Request URL: $apiUrll');
      print('Response received, Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Print the full response for debugging
        print('Fetched Data: $data');

        // Ensure 'images' exists and is not empty
        if (data['images'] != null && data['images'].isNotEmpty) {
          setState(() {
            // startingImageUrl = data['images'][0]['startingimage'] ?? null;
            // endingImageUrl = data['images'][0]['endingimage'] ?? null;
            startingImageUrl = '${data['images'][0]['startingimage']}';
            endingImageUrl = '${data['images'][0]['endingimage']}';

          });
          print("${AppConstants.baseUrl}/backend/uploads/$startingImageUrl");
        } else {
          print('No images found in the response');
        }
      } else {
        print('Failed to load images, Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   fetchImages(); // Make sure fetchImages is being called
  // }


//local storage of username
  void _loadLoginDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String storedUsername = prefs.getString('username') ?? "Guest";
    String storedUserId = prefs.getString('userId') ?? "N/A";

    // Debugging print statements
    print("Local Storage - username: $storedUsername");
    print("Local Storage - userId: $storedUserId");

    // Navigate to Homescreen with stored values
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Homescreen(userId: storedUserId, username: storedUsername),
      ),
    );
  }




  void _handleSubmitModal() {
    // Show the popup dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'End Ride',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you  want to Upload toll and parking?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop(); // Close the dialog
                _loadLoginDetails();              },
              child: Text(
                'No',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // _handleUpload();
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>TripDetailsPreview(tripId: widget.tripId,)));
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TollParkingUpload(tripId:widget.tripId ,)));

                // Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    bool isConnected = Provider.of<NetworkManager>(context).isConnected;

    return BlocListener<TripSheetDetailsTripIdBloc, TripSheetDetailsTripIdState>(listener: (context, state){
      if(state is TripDetailsByTripIdLoaded){
        setState(() {

          tripIdController.text = state.tripDetails['tripid'].toString() ?? '';
          guestNameController.text = state.tripDetails['guestname'] ?? '';
          guestMobileController.text = state.tripDetails['guestmobileno'].toString()?? '';
          vehicleTypeController.text = state.tripDetails['vehType'].toString() ?? '';
          startKmController.text = state.tripDetails['startkm'].toString() ?? '';
          closeKmController.text = state.tripDetails['closekm'].toString() ?? '';
          // startDateController.text = state.tripDetails['startdate'].toString() ?? '';
          startDateController.text = setFormattedDate(state.tripDetails['startdate'].toString()) ?? '';
          closeDateController.text = setFormattedDate(state.tripDetails['closedate'].toString()) ?? '';
          // closeDateController.text = state.tripDetails['closedate'].toString() ?? '';
        });
        print('Trip details guest: ${state.tripDetails}');
      }else if(state is TripDetailsByTripIdError){
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(state.message)),
        // );
        showFailureSnackBar(context, state.message);
      }
    },child:Scaffold(
      appBar: AppBar(
        title: const Text("Trip Preview"),
        automaticallyImplyLeading: false,

      ),
      body: Stack(
        children: [



      RefreshIndicator(
          onRefresh: _refreshTripDetails, // Pull to refresh logic
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(), // Ensures pull-to-refresh works


            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Trip ID
              TextField(
                controller: tripIdController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Trip ID",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Guest Name
              TextField(
                controller: guestNameController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Guest Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Guest Mobile Number
              TextField(
                controller: guestMobileController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Guest Mobile Number",
                  border: OutlineInputBorder(),
                ),
              ),
              // const SizedBox(height: 16),
              //
              // // Vehicle Type
              // TextField(
              //   controller: vehicleTypeController,
              //   enabled: false,
              //   decoration: const InputDecoration(
              //     labelText: "Vehicle Type",
              //     border: OutlineInputBorder(),
              //   ),
              // ),
              const SizedBox(height: 16),

              // Starting Date
              TextField(
                readOnly: true,
                enabled: false,
                controller: startDateController,
                decoration: const InputDecoration(
                  labelText: "Starting Date",
                  border: OutlineInputBorder(),
                ),

                // decoration: InputDecoration(
                //   hintText: startingDate == null
                //       ? "Select Starting Date"
                //       : "${startingDate!.toLocal()}".split(' ')[0],
                //   border: const OutlineInputBorder(),
                // ),
              ),
              const SizedBox(height: 16),

              // Closing Date
              TextField(
                readOnly: true,
                enabled: false,
                controller: closeDateController,
                decoration: const InputDecoration(
                  labelText: "closing Date",
                  border: OutlineInputBorder(),
                ),

                // decoration: InputDecoration(
                //   hintText: closingDate == null
                //       ? "Select Closing Date"
                //       : "${closingDate!.toLocal()}".split(' ')[0],
                //   border: const OutlineInputBorder(),
                // ),
              ),
              const SizedBox(height: 16),

              // Starting Kilometer

              TextField(
                readOnly: true, // Makes the field read-only
                enabled: false, // Disables editing
                controller: startKmController,
                decoration: const InputDecoration(
                  labelText: "Starting Kilometer",
                  border: OutlineInputBorder(),
                ),
              ),
              // Image.asset(
              //   AppConstants.intro_one, // Replace with your image path
              //   height: 100, // Set the desired height
              //   width: 100, // Set the desired width
              //   fit: BoxFit.cover, // Adjust the image's box fit
              // ),


              const SizedBox(height: 16),

              // Closing Kilometer
            TextField(
                      controller: closeKmController,
                      // enabled: isCloseKmEnabled,
                        readOnly: true,
                        enabled: false,
                      decoration: const InputDecoration(
                        labelText: "Closing Kilometer",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    // Image.asset(
                    //   AppConstants.intro_one, // Replace with your image path
                    //   height: 100, // Set the desired height
                    //   width: 100, // Set the desired width
                    //   fit: BoxFit.cover, // Adjust the image's box fit
                    // ),

            ],
          ),
        ),
      )),
          Positioned(
            top: 15,
            left: 0,
            right: 0,
            child: NoInternetBanner(isConnected: isConnected),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0,),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              // Add your logic for toll and parking upload
              _handleSubmitModal();
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Signatureendride()));
            },
            child: const Text(
              "Upload Toll and Parking",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),


      // SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.all(16.0),
      //     child: Column(
      //       children: [
      //         // Trip ID (disabled)
      //         TextField(
      //           enabled: false,
      //           decoration: const InputDecoration(
      //             labelText: "Trip ID",
      //             border: OutlineInputBorder(),
      //           ),
      //         ),
      //         const SizedBox(height: 16),
      //
      //         // Starting Image
      //         startingImageUrl == null
      //             ? const CircularProgressIndicator()  // Show a loading spinner if the image is not loaded yet
      //             :
      //         Image.network(
      //           startingImageUrl ?? '', // Full URL from the API
      //           height: 100,
      //           width: 100,
      //           fit: BoxFit.cover,
      //           errorBuilder: (context, error, stackTrace) {
      //             return const Text("Failed to load image");
      //           },
      //         ),
      //         // Display the URL for debugging
      //         Text(startingImageUrl ?? 'URL not available'),
      //         const SizedBox(height: 16),
      //
      //         // Closing Image
      //         endingImageUrl == null
      //             ? const CircularProgressIndicator()  // Show a loading spinner if the image is not loaded yet
      //             :
      //         Image.network(
      //           '$endingImageUrl', // Image path fetched from API
      //           height: 100,
      //           width: 100,
      //           fit: BoxFit.cover,
      //           errorBuilder: (context, error, stackTrace) {
      //             return const Text("Failed to load image");
      //           },
      //         ),
      //         const SizedBox(height: 16),
      //
      //         // Other Fields (Guest Name, Vehicle Type, etc.)
      //         TextField(
      //           enabled: false,
      //           decoration: const InputDecoration(
      //             labelText: "Guest Name",
      //             border: OutlineInputBorder(),
      //           ),
      //         ),
      //         const SizedBox(height: 16),
      //
      //         // You can add other fields here...
      //       ],
      //     ),
      //   ),
      // ),

    ),
    );
  }
}
