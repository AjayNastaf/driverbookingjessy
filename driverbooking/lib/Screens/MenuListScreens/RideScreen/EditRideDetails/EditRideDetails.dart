import 'dart:io';
import 'package:jessy_cabs/Screens/HomeScreen/HomeScreen.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:jessy_cabs/Networks/Api_Service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart'; // Import this for DateFormat
import 'package:jessy_cabs/Utils/AppFunctions.dart';
import '../../../../Bloc/AppBloc_Events.dart';
import '../../../../Bloc/AppBloc_State.dart';
import '../../../../Bloc/App_Bloc.dart';
import 'package:http/http.dart' as http;
import 'package:jessy_cabs/Screens/NoInternetBanner/NoInternetBanner.dart';
import 'package:provider/provider.dart';
import 'package:jessy_cabs/Screens/network_manager.dart';



class EditRideDetails extends StatefulWidget {
  final String tripId;

  const EditRideDetails({super.key , required this.tripId});

  @override
  State<EditRideDetails> createState() => _EditRideDetailsState();
}

class _EditRideDetailsState extends State<EditRideDetails> {
  bool isEditable = false;
  // File? tollFile;
  // File? parkingFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = false;
  bool isDisabled = false;
  String closedDateFromDB = ''; // Class-level variable
  DateTime? closedDate; // This will store the closed date from the database

  List<String> imageUrls = [];
  bool isLoading = true;
  bool hasError = false;
  String? imageUrl;
  bool isLoading1 = true;
  List<File> tollFiles = [];
  List<File> parkingFiles = [];

  // Controllers for input fields
  final TextEditingController tripSheetNumberController = TextEditingController();
  final TextEditingController tripDateController = TextEditingController();
  final TextEditingController reportTimeController = TextEditingController();
  final TextEditingController dutyTypeController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController guestNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dropLocationController = TextEditingController();
  final TextEditingController tollAmountController = TextEditingController();
  final TextEditingController parkingAmountController = TextEditingController();

  final SignatureController _signatureController = SignatureController(
    penColor: Colors.black,
    penStrokeWidth: 2.0,
    exportBackgroundColor: Colors.white,
  );
  @override
  void initState() {
    super.initState();
    _loadTripDetails();
    print('Received tripId: ${widget.tripId}'); // Print the tripId for debugging

    fetchTripImages();
    context.read<DocumentImagesBloc>().add(FetchBothDocumentImages(tripId: widget.tripId));
    fetchSignature();
  }

  Future<void> _refreshEditRideScreen() async{
    _loadTripDetails();
    print('Received tripId in refresh: ${widget.tripId}'); // Print the tripId for debugging

    fetchTripImages();
    context.read<DocumentImagesBloc>().add(FetchBothDocumentImages(tripId: widget.tripId));
    fetchSignature();
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



  Future<void> _loadTripDetails() async {
    try {
      // Fetch trip details from the API
      final tripDetails = await ApiService.fetchTripDetails(widget.tripId);
      print('Trip details fetchedd: $tripDetails');
      if (tripDetails != null) {

        var tripIdvalue = tripDetails['tripid'].toString();
        var tripdatevalue = setFormattedDate(tripDetails['tripsheetdate']).toString();
        var reporttimevalue = tripDetails['reporttime'].toString();;
        var dutyvalue = tripDetails['duty'].toString();
        var vectypeValue = tripDetails['vehicleName2'].toString();
        var guestnamevalue = tripDetails['guestname'].toString();
        // var guestnamevalue = tripDetails['closekm'].toString();
        var guestmobilenovalue = tripDetails['guestmobileno'].toString();
        var pickupvalue = tripDetails['address1'].toString();
        var droplocationvalue = tripDetails['useage'].toString();
        var parkingvalue = tripDetails['parking'].toString();
        var tollvalue = tripDetails['toll'].toString();

        String closedDateString= tripDetails['closedate'] ?? '';

        print("dutyyyy: ${tripIdvalue}");
        setState(() {
          // Update the controllers with the values
          tripSheetNumberController.text = tripIdvalue ?? '';
          tripDateController.text = tripdatevalue ?? '';
          reportTimeController.text = reporttimevalue?? '';
          vehicleTypeController.text = vectypeValue ?? '';
          dutyTypeController.text = dutyvalue ?? '';
          guestNameController.text = guestnamevalue ?? '';
          contactNumberController.text = guestmobilenovalue ?? '';
          addressController.text = pickupvalue ?? '';
          dropLocationController.text = droplocationvalue ?? '';
          tollAmountController.text = tollvalue ?? '';
          parkingAmountController.text = parkingvalue ?? '';
          // closedDateFromDB = closedDateString ??'';
          closedDate = DateTime.parse(closedDateString);

        });

      } else {
        print('No trip details found.');
      }
    } catch (e) {
      print('Error loading trip details: $e');
    }
  }

  bool isFieldEnabled() {
    if (closedDate == null) return false; // Disable if closedDate is null
    DateTime today = DateTime.now();
    return closedDate!.year == today.year &&
        closedDate!.month == today.month &&
        closedDate!.day == today.day;
  }







  Widget _buildInputField(String label, TextEditingController controller, {bool alwaysDisabled = false}) {
    bool isEnabled = alwaysDisabled ? false : isFieldEnabled(); // Ensure certain fields are always disabled

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        enabled: isEnabled,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: isEnabled ? Colors.white : Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

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



  void _handleSubmit(BuildContext context) async {
    final tripId = widget.tripId;
    bool dataSubmitted = false;

    // Handle Signature Submission
    if (_signatureController.isNotEmpty) {
      final signature = await _signatureController.toPngBytes();
      if (signature != null) {
        String base64Signature = 'data:image/png;base64,' + base64Encode(signature);
        final DateTime now = DateTime.now();
        final String endtrip = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
        final String endtime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

        context.read<TripSignatureBloc>().add(
          SaveSignatureEvent(
            tripId: tripId,
            base64Signature: base64Signature,
            imageName: 'signature-${now.millisecondsSinceEpoch}.png',
            endtrip: endtrip,
            endtime: endtime,
          ),
        );

        dataSubmitted = true;
      }
    }

    // Handle Toll & Parking Details Submission
    if (tollAmountController.text.isNotEmpty || parkingAmountController.text.isNotEmpty) {
      context.read<TollParkingDetailsBloc>().add(
        UpdateTollParking(
          tripId: tripId,
          toll: tollAmountController.text,
          parking: parkingAmountController.text,
        ),
      );

      if (parkingFiles != null) {
        context.read<TollParkingDetailsBloc>().add(UploadParkingFile(
          tripId: tripId,
          parkingFiles: parkingFiles!,
        ));
      }

      // if (tollFile != null) {
      //   context.read<TollParkingDetailsBloc>().add(UploadTollFile(
      //     tripId: tripId,
      //     tollFile: tollFile!,
      //   ));
      // }

      if (tollFiles != null) {
        context.read<TollParkingDetailsBloc>().add(UploadTollFile(
          tripId: tripId,
          tollFiles: tollFiles!,
        ));
      }

      dataSubmitted = true;
    }

    // Show appropriate message
    if (dataSubmitted) {

      showSuccessSnackBar(context, "Details submitted successfully!");
      _loadLoginDetails(); // Navigate after submission
    } else {

      showInfoSnackBar(context, "Please provide either a signature or toll/parking details.");
    }
  }


  void checkDate() {

    DateTime currentDate = DateTime.now();
    DateTime closedDate = DateTime.parse(closedDateFromDB);

    // Format dates to compare only year, month, and day
    String formattedCurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);
    String formattedClosedDate = DateFormat('yyyy-MM-dd').format(closedDate);

    if (formattedCurrentDate != formattedClosedDate) {
      setState(() {
        isDisabled = true;
      });
    }
  }

  Future<void> fetchTripImages1() async {
    final String apiUrl = '${AppConstants.baseUrl}/uploads?tripid=${widget.tripId}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          imageUrls = (data['attachedImagePaths'] as List)
              .map((path) => '${AppConstants.baseUrl}/$path') // Construct full URL
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> fetchTripImages() async {
    final String apiUrl = '${AppConstants.baseUrl}/uploads?tripid=${widget.tripId}';

    print("Fetching images from API: $apiUrl"); // Debug print for API URL

    try {
      final response = await http.get(Uri.parse(apiUrl));

      print("APIs Response Code: ${response.statusCode}"); // Debug print for response status
      print("APIs Response Body: ${response.body}"); // Debug print for response body

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          imageUrls = (data['attachedImagePaths'] as List)
              .map((path) => '${AppConstants.baseUrl}/uploads/$path') // Construct full URL
          // .map((path) => '${apiUrl}/uploads/${path}') // Construct full URL
              .toList();
          isLoading = false;
        });

        print("Fetched Image URLs: $imageUrls"); // Debug print for image list
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });

        print("Error: API returned non-200 status code"); // Debug error
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });

      print("Exception occurred: $e"); // Debug exception
    }
  }


  Future<void> fetchSignature1() async {
    final apiService = ApiService(apiUrl: "${AppConstants.baseUrl}");
    final url = await apiService.fetchSignaturePhoto(widget.tripId);
    setState(() {
      imageUrl = url;
      isLoading1 = false;
    });
  }

  Future<void> fetchSignature() async {
    print('Fetching signature for tripId: ${widget.tripId}');
    final apiService = ApiService(apiUrl: "${AppConstants.baseUrl}");
    final url = await apiService.fetchSignaturePhoto(widget.tripId);

    setState(() {
      imageUrl = url;
      isLoading = false;
    });

    if (imageUrl != null) {
      print('Signature image URL received: $imageUrl');
    } else {
      print('Signature image not found.');
    }
  }



  @override
  Widget build(BuildContext context) {
    bool isConnected = Provider.of<NetworkManager>(context).isConnected;

    return BlocListener<TollParkingDetailsBloc, TollParkingDetailsState>(
      listener: (context, state) {
        if (state is TollParkingUpdated) {

          showSuccessSnackBar(context, "Toll & Parking updated successfully!");
        } else if (state is ParkingFileUploaded) {

          showSuccessSnackBar(context, "Parking file uploaded successfully!");

        } else if (state is TollFileUploaded) {

          showSuccessSnackBar(context, "Toll file uploaded successfully!");


        } else if (state is TollParkingDetailsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Trip Details"),
        ),
        body:
        Stack(children: [
          Positioned(
            top: 15,
            left: 0,
            right: 0,
            child: NoInternetBanner(isConnected: isConnected),
          ),

        RefreshIndicator( onRefresh: _refreshEditRideScreen,
       child: SingleChildScrollView(
         physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              const SizedBox(height: 16),
              buildSectionTitle("Trip Information"),
              _buildInputField("Trip Sheet Number", tripSheetNumberController, alwaysDisabled: true ),
              _buildInputField("Trip Date", tripDateController,  alwaysDisabled: true),
              _buildInputField("Report Time", reportTimeController,alwaysDisabled: true ),
              const SizedBox(height: 16),
              buildSectionTitle("Duty Information"),
              _buildInputField("Duty Type", dutyTypeController,alwaysDisabled: true),
              _buildInputField("Vehicle Name", vehicleTypeController,alwaysDisabled: true),
              const SizedBox(height: 16),
              buildSectionTitle("Guest Information"),
              _buildInputField("Guest Name", guestNameController,alwaysDisabled: true),
              _buildInputField("Contact Number", contactNumberController,alwaysDisabled: true),
              const SizedBox(height: 16),
              buildSectionTitle("Locations"),
              _buildInputField("Pickup Location ", addressController,alwaysDisabled: true),
              _buildInputField("Drop Location", dropLocationController,alwaysDisabled: true),
              const SizedBox(height: 16),
              buildSectionTitle("Toll and Parking"),
              _buildInputField("Enter Toll Amount", tollAmountController,alwaysDisabled: true),


              const SizedBox(height: 16),
              _buildInputField("Enter Parking Amount", parkingAmountController,alwaysDisabled: true),

              const SizedBox(height: 10), // Adds spacing between the input and image





              BlocBuilder<DocumentImagesBloc, DocumentImagesState>(
                builder: (context, state) {
                  if (state is DocumentImagesLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is DocumentImagesLoaded) {
                    print("📸 Start KM Image in UI: ${state.startKmImage}");
                    print("📸 Closing KM Image in UI: ${state.closingKmImage}");
                    print("📸 toll KM Image in UI: ${state.TollImage}");
                    print("📸 parking KM Image in UI: ${state.ParkingImage}");
                    return Column(
                      children: [
                        // Start KM Image
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              buildSectionTitle("Starting KM image"),
                              state.startKmImage != null
                                  ? Image.network(state.startKmImage!, width: double.infinity, height: 200, fit: BoxFit.cover)
                                  : Text("No Starting KM image found", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),

                        Divider(),

                        // Closing KM Image
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              buildSectionTitle("Closing KM image"),
                              state.closingKmImage != null
                                  ? Image.network(state.closingKmImage!, width: double.infinity, height: 200, fit: BoxFit.cover)
                                  : Text("No Closing KM image found", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              buildSectionTitle("Toll image"),
                              // state.TollImage != null
                              //     ? Image.network(state.TollImage!, width: double.infinity, height: 200, fit: BoxFit.cover)
                              state.TollImage != null && state.TollImage!.isNotEmpty
                                  ? Column(
                                children: state.TollImage!.toSet().map((url) {  // Convert to Set to remove duplicates
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                      url,
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }).toList(),
                              )
                                  : Text("No toll image found", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                        // Parking Image
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              buildSectionTitle("Parking image"),
                              // state.ParkingImage != null
                              //     ? Image.network(state.ParkingImage!, width: double.infinity, height: 200, fit: BoxFit.cover)
                              state.ParkingImage != null && state.ParkingImage!.isNotEmpty
                                  ? Column(
                                children: state.ParkingImage!.toSet().map((url) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                      url,
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }).toList(),
                              )
                                  : Text("No Parking Image found", style: TextStyle(color: Colors.grey)),


                            ],
                          ),
                        ),

                      ],
                    );
                  } else if (state is DocumentImagesError) {
                    return Center(child: Text("❌ Error: ${state.error}", style: TextStyle(color: Colors.red)));
                  }
                  return Center(child: Text("Fetching images..."));
                },
              ),
              const SizedBox(height: 16),
              buildSectionTitle("Signature"),
              SizedBox(height: 16),

              Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : imageUrl != null
                    ? Container(
                  padding: const EdgeInsets.all(10), // Padding inside the container
                  decoration: BoxDecoration(
                    // color: Colors.grey[300], // Light grey background
                    border: Border.all(color: Colors.black, width: 2), // Black border
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    width: 200, // Set a width (adjust as needed)
                    height: 200, // Set a height (adjust as needed)
                  ),
                )
                    : const Text("Signature not found"),
              ),



              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // onPressed:  _submitDetails,      _loadLoginDetails(); // Navigate after submission
                  // onPressed: () { _handleSubmit(context); },
                  onPressed: () {_loadLoginDetails(); },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.darkgreen, // Set the background color here
                    foregroundColor: Colors.white, // Set the text color here
                  ),
                  // child: Text("Submit Details", style: TextStyle(color: Colors.white),),
                  child: Text("Go To Home", style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),),
        ],)
      ),


    );
  }
}
