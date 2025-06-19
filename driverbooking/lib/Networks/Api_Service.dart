import 'dart:convert';
import 'package:http/http.dart' as http; // Ensure this is imported correctly
import 'package:jessy_cabs/Screens/Home.dart';
import 'package:jessy_cabs/Screens/HomeScreen/MapScreen.dart';
import '../Screens/HomeScreen/MapScreen.dart';
import '../Utils/AppConstants.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:io'; // Add this for File class
import 'package:intl/intl.dart';  // Add this to format the date
import 'package:path/path.dart' as path;



class ApiService {
  final String apiUrl;

  ApiService({required this.apiUrl}); // Constructor should be defined properly

  Future<List<dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body); // Decode JSON response
    } else {
      throw Exception("Failed to load data"); // Use Exception correctly
    }
  }

  static Future<http.Response> login({required String username,required String password, }) async {

    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'userpassword': password}),
    );

    // if (response.statusCode == 200) {
    //   return true; // Login successful
    // } else {
    //   return false; // Login failed
    // }
    print(response);
    return response;

  }


  static Future<bool> registers({
    // required BuildContext context,
    required String username,
    required String password,
    required String phonenumber,
    required String email,
    required String otp,
  }) async {


    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/registerotp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
        'phonenumber': phonenumber,  // Ensure phonenumber is included
        'otp': otp
      }),
    );


    if (response.statusCode == 200) {
      return true;  // Registration successful
    } else {
      return false;  // Registration failed
    }
  }


  static Future<Map<String, String?>?> retrieveOtpFromDatabase(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/retrieveotp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final otp = data['otp'];
        final username = data['username'];
        final password = data['password'];
        final phonenumber = data['phonenumber'];

        return {
          'otp': otp,
          'username': username,
          'password': password,
          'phonenumber': phonenumber,
        };  // Returning the OTP
      } else {
        return null;  // Returning null if OTP retrieval fails
      }
    } catch (e) {
      return null;  // Returning null in case of any error
    }
  }

  static Future<Map<String, String?>?> getUserDetailsDatabase(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/getUserDetails'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final username = data['username'];
        final password = data['password'];
        final phonenumber = data['phonenumber'];
        final email = data['email'];


        return {
          'username': username,
          'password': password,
          'phonenumber': phonenumber,
          'email': email,
        };  // Returning the OTP
      } else {
        return null;  // Returning null if OTP retrieval fails
      }
    } catch (e) {
      return null;  // Returning null in case of any error
    }
  }



  static Future<bool> sendUsernamePasswordEmail(String registerUsername, String registerPassword, String recipientEmail) async {
    String username = '${AppConstants.mailerEmail}';
    String password = '${AppConstants.mailerPassword}';

    final smtpServer = gmail(username, password); // Using Gmail's SMTP server
    final message = Message()
      ..from = Address(username, 'Nastaf Application')
      ..recipients.add(recipientEmail)
      ..subject = 'Your OTP Code'
    // ..text = 'Your OTP code is: $otp';
      ..text = '''
            Hello,
            Thank you for using Nastaf Application! .
            
            Your username: $registerUsername
            Your password: $registerPassword
            
           Please don't share with Anyone.
            
            Thank you,
            The Nastaf Team
            ''';
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      return true;
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      return false;
    }
  }


  static Future<bool> sendRegisterDetailsDatabase(String username, String password, String email, String phonenumber) async {


    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/userregister'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
        'phonenumber': phonenumber,  // Ensure phonenumber is included
      }),
    );

    if (response.statusCode == 200) {
      return true;  // Registration successful
    } else {
      return false;  // Registration failed
    }
  }

  static Future<bool> sendOtpEmail(String otp, String recipientEmail, String recipientUsername) async {


    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/checkexistuser'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': recipientUsername,
        'email': recipientEmail,
      }),
    );
    print("Response API: ${response.statusCode}");


    if (response.statusCode == 200) {
      String username = '${AppConstants.mailerEmail}';
      String password = '${AppConstants.mailerPassword}';
      final smtpServer = gmail(username, password); // Using Gmail's SMTP server
      final message = Message()
        ..from = Address(username, 'Nastaf Application')
        ..recipients.add(recipientEmail)
        ..subject = 'Your OTP Code'
      // ..text = 'Your OTP code is: $otp';
        ..text = '''
            Hello,
            Thank you for using Nastaf Application! For added security, we require you to verify your identity with a one-time password (OTP).
            
            Your OTP is: $otp
            
            Please enter this OTP within the next 10 minutes to complete your verification. For your security, do not share this code with anyone.
            If you did not request this OTP, please contact our support team immediately.
            
            Thank you,
            The Nastaf Team
            ''';

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
        return true;
      } on MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
        return false;
      }
      // Registration successful
    } else {
      print("Error sending email: ${response.body}"); // Debugging the error

      return false;// Registration failed
    }


  }


  // updating user details
  static Future<http.Response> updateUserDetails({required String userId, required String username, required String password, required String phonenumber, required String email,}) async {

    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/updateUser'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'username': username,
        'password': password,
        'phonenumber': phonenumber,
        'email': email
      }),
    );
    // if (response.statusCode == 200) {
    //   return true; // Login successful
    // } else {
    //   return false; // Login failed
    // }
    return response;
  }

  //check current password
  static Future<http.Response> checkCurrentPassword({required String userId, required String password}) async {

    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/checkCurrentPassword'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userId, 'password': password}),
    );

    // if (response.statusCode == 200) {
    //   return true; // Login successful
    // } else {
    //   return false; // Login failed
    // }
    return response;
  }

  //change password
  static Future<http.Response> changePassword({required String userId, required String newPassword}) async {

    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/changePassword'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userId, 'newPassword': newPassword}),
    );

    // if (response.statusCode == 200) {
    //   return true; // Login successful
    // } else {
    //   return false; // Login failed
    // }
    return response;
  }

  //Forgot Password Email Verification
  static Future<http.Response> forgotPasswordEmailVerification({required String email}) async {

    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/forgotPasswordEmailVerification'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    // if (response.statusCode == 200) {
    //   return true; // Login successful
    // } else {
    //   return false; // Login failed
    // }
    return response;
  }

  static Future<bool> forgotPasswordOtpEmailSentResult(String userId, String email, String forgotPasswordOtp) async {


    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/addForgotPasswordOtp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        // 'userId': userId,
        'email': email,
        'otp': forgotPasswordOtp
      }),
    );
    print("Response API: ${response.statusCode}");

    if (response.statusCode == 200) {
      String username = '${AppConstants.mailerEmail}';
      String password = '${AppConstants.mailerPassword}';
      final smtpServer = gmail(username, password); // Using Gmail's SMTP server
      final message = Message()
        ..from = Address(username, 'Nastaf Application')
        ..recipients.add(email)
        ..subject = 'Your OTP Code for forgot password'
      // ..text = 'Your OTP code is: $otp';
        ..text = '''
            Hello,
            Thank you for using Nastaf Application! For added security, we require you to verify your identity with a one-time password (OTP).
            
            Your OTP is: $forgotPasswordOtp
            
            Please enter this OTP within the next 10 minutes to complete your verification. For your security, do not share this code with anyone.
            If you did not request this OTP, please contact our support team immediately.
            
            Thank you,
            The Nastaf Team
            ''';

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
        return true;
      } on MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
        return false;
      }
    }else {
      print("Error sending email: ${response.body}"); // Debugging the error

      return false;// Registration failed
    }
      // Registration successful
  }


  //check Forgot Password
  static Future<http.Response> checkForgotPasswordOtp({required String email}) async {

    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/checkForgotPasswordOtp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    // if (response.statusCode == 200) {
    //   return true; // Login successful
    // } else {
    //   return false; // Login failed
    // }
    return response;
  }


  //Change Password Forgot
  static Future<http.Response> changePasswordForgot({required String userId, required String newPassword}) async {

    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/changePasswordForgot'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userId, 'newPassword': newPassword}),
    );

    // if (response.statusCode == 200) {
    //   return true; // Login successful
    // } else {
    //   return false; // Login failed
    // }
    return response;
  }


  static Future<http.Response> customerotpverify({required String otp, }) async {

    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/customerotp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'otp': otp,}),
    );


    return response;
  }



  // static Future<Map<String, dynamic>> uploadImage(File image1, File image2) async {
  //   final url = Uri.parse('${AppConstants.baseUrl}/upload-images');
  //   final request = http.MultipartRequest('POST', url);
  //
  //   // Add images with correct field names
  //   request.files.add(await http.MultipartFile.fromPath('startingimage', image1.path));
  //   request.files.add(await http.MultipartFile.fromPath('endingimage', image2.path));
  //
  //   final response = await request.send();
  //   if (response.statusCode == 200) {
  //     final responseBody = await response.stream.bytesToString();
  //     // return json.decode(responseBody) as Map<String, dynamic>;
  //     return {
  //       'success': true,
  //       'message': 'Images uploaded successfully!',
  //     };
  //   } else {
  //     return {
  //       'success': false,
  //       'message': 'Failed to upload images. HTTP ${response.statusCode}',
  //     };
  //   }
  // }




  // static Future<List<Map<String, dynamic>>> fetchTripSheet({
  //   required String userId,
  //   required String drivername,
  // }) async {
  //   try {
  //     // Print the inputs to ensure they are passed correctly
  //     print('Fetching trip sheet for userId: $userId, username: $drivername');
  //
  //     final response = await http.get(
  //       Uri.parse('${AppConstants.baseUrl}/tripsheet/$drivername'), // Pass username in the URL
  //       headers: {
  //         'userId': userId,
  //       },
  //     );
  //
  //     print('Response statusssss: ${response.statusCode}');
  //     print('Response bodyyy: ${response.body}');
  //
  //     if (response.statusCode == 200) {
  //       // Parse the response and return a list of maps
  //       List<Map<String, dynamic>> trips = List<Map<String, dynamic>>.from(json.decode(response.body));
  //       print('Fetched tripsheet data: $trips');
  //       return trips;
  //     } else {
  //       throw Exception('Failed to fetch trip sheet: ${response.reasonPhrase}');
  //     }
  //   } catch (e) {
  //     print('Error in fetchTripSheet: $e');
  //     rethrow; // Re-throw the error to handle it in the calling function
  //   }
  // }

  static Future<List<Map<String, dynamic>>> fetchTripSheet({
    required String userId,
    required String drivername,
  }) async {
    try {
      // Generate today's date in yyyy-MM-dd format
      String startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      print('Fetching trip sheet for userId: $userId, drivername: $drivername, startDate: $startDate');

      // Construct URL with drivername and startDate
      final url = Uri.parse('${AppConstants.baseUrl}/tripsheet/$drivername/$startDate');

      final response = await http.get(
        url,
        headers: {
          'userId': userId,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> trips =
        List<Map<String, dynamic>>.from(json.decode(response.body));
        print('Fetched tripsheet data: $trips');
        return trips;
      } else {
        throw Exception('Failed to fetch trip sheet: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error in fetchTripSheet: $e');
      rethrow;
    }
  }


  static Future<List<Map<String, dynamic>>> fetchTripSheetbytripid({
    required String userId,
    required String username,
    required String tripId,
    required String duty,
  }) async {
    try {
      final url = '${AppConstants.baseUrl}/tripsheets/$duty/$tripId';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'userId': userId,
        },
      );

      // Log the full response body for debugging
      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Handle the case where the response is a list of maps or a single map
        if (responseData is List) {
          return responseData
              .map((item) => Map<String, dynamic>.from(item))
              .toList();  // Explicitly cast each item to Map<String, dynamic>
        } else if (responseData is Map) {
          return [Map<String, dynamic>.from(responseData)]; // Wrap the map in a list
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to fetch trip sheet: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching trip sheet by tripid: $e');
      rethrow;
    }
  }





  static Future<void> updateTripStatus({required String tripId, required String status}) async {
    final String url = '${AppConstants.baseUrl}/update_trip_apps';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'tripid': tripId,
          'apps': status,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('API Response: ${responseData['message']}');
      } else {
        print('Failed to update trip status. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating trip status: $error');
    }
  }


  static Future<http.Response> updateTripStatusStartRide(String tripId, String status) async {
    final url = Uri.parse('${AppConstants.baseUrl}/update_trip_apps'); // Replace with your actual endpoint

    final body = jsonEncode({
      'tripid': tripId,
      'apps': status,
    }); // Encode the body as a JSON string

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // Ensure the content type is JSON
        },
        body: body, // Pass the encoded body
      );

      return response;
    } catch (e) {
      throw Exception('Failed to send request: $e');
    }
  }


  static Future<http.Response> updateTripStatusCompleted( {required String tripId, required String apps}) async {
    final url = Uri.parse('${AppConstants.baseUrl}/update_trip_apps'); // Replace with your actual endpoint

    final body = jsonEncode({
      'tripid': tripId,
      'apps': 'Closed',
    }); // Encode the body as a JSON string

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // Ensure the content type is JSON
        },
        body: body, // Pass the encoded body
      );

      return response;
    } catch (e) {
      throw Exception('Failed to send request: $e');
    }
  }



  static Future<void> saveSignature({
    required String tripId,
    required String signatureData,
    required String imageName,
    required String endtrip,
    required String endtime,
  }) async {
    final Uri url = Uri.parse('${AppConstants.baseUrl}/api/saveSignature');  // Update the endpoint URL

    try {
      // Prepare the data to send in the request
      final Map<String, dynamic> requestBody = {
        'tripid': tripId,
        'signatureData': signatureData,
        'imageName': imageName,
        'endtrip': endtrip,
        'endtime': endtime,
      };

      // Convert the body to JSON
      final String body = json.encode(requestBody);

      // Send POST request to save signature
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Handle the response
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print("Successsss sign jessy: ${data['message']}");

        //
        //
        //
        // final Uri url = Uri.parse('${AppConstants.baseUrlJessyCabs}/signautureimagedriverapp');
        // print("Successsss sign jessyyyy:");
        //
        // try {
        //   // Prepare the data to send in the request
        //   final Map<String, dynamic> requestBody1 = {
        //     'signatureData': signatureData,
        //     'imageName': imageName,
        //   };
        //
        //   // Convert the body to JSON
        //   final String body = json.encode(requestBody1);
        //
        //   // Send POST request to save signature
        //   final response1 = await http.post(
        //     url,
        //     headers: {
        //       'Content-Type': 'application/json',
        //     },
        //     body: body,
        //   );
        //
        //   // Print full response details
        //   print('Response Status Code (jessy): ${response1.statusCode}');
        //   print('Full Response Body (jessy): ${response1.body}');
        //
        //   // Handle response based on status code
        //   if (response1.statusCode == 200) {
        //     print('jessy Response Body123 (jessy): ${response1.body}');
        //   } else {
        //     print('Error Response Body (jessy): ${response1}');
        //   }
        // }
        //   catch (e){
        //     print('Error Response Body (jessy): ${e}');
        //   }
        //
        //




      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        print("Error: ${errorData['error']}");
        print("Response body: ${response.body}");  // Add this line to log the full response body
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }



  static Future<void> sendSignatureDetails({
    required String tripId,
    required String dateSignature,
    required String signTime,
    String status = 'Accept',
  }) async {
    final String apiUrl = '${AppConstants.baseUrl}/signaturedatatimesdriverapp/$tripId';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'status': status,
          'datesignature': dateSignature,
          'signtime': signTime,
          'tripId':tripId,
        }),
      );

      if (response.statusCode == 200) {
        print("Data uploaded successfully");
      } else {
        throw Exception("Failed to upload data: ${response.body}");
      }
    } catch (error) {
      throw Exception("Error uploading data: $error");
    }
  }


  static Future<void> sendSignatureDetailsOnGoing({
    required String tripId,
    required String dateSignature,
    required String signTime,
    String status = 'onGoing',
  }) async {
    final String apiUrl = '${AppConstants.baseUrl}/signaturedatatimesdriverapp/$tripId';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'status': status,
          'datesignature': dateSignature,
          'signtime': signTime,
          'tripId':tripId,
        }),
      );

      if (response.statusCode == 200) {
        print("Data uploaded successfully");
      } else {
        throw Exception("Failed to upload data: ${response.body}");
      }
    } catch (error) {
      throw Exception("Error uploading data: $error");
    }
  }


  static Future<void> sendSignatureDetailsUpdated({
    required String tripId,
    required String dateSignature,
    required String signTime,
    required String status,
  }) async {
    final String apiUrl = '${AppConstants.baseUrl}/signaturedatatimesdriverapp/$tripId';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'status': status,
          'datesignature': dateSignature,
          'signtime': signTime,
          'tripId':tripId,
        }),
      );

      if (response.statusCode == 200) {
        print("Data uploaded successfullyyyyyyyyyy");
      } else {
        throw Exception("Failed to upload data: ${response.body}");
      }
    } catch (error) {
      throw Exception("Error uploading data: $error");
    }
  }






  //for parking file upload
  // static Future<bool> uploadTollFile({
  //   required String tripid,
  //   required String documenttype,
  //   required File tollFile,
  // }) async {
  //   try {
  //     // Generate the unique filename based on the current date
  //     String formattedDate = DateTime.now().millisecondsSinceEpoch.toString();;
  //     // String fileName = 'file_$formattedDate.jpg';
  //
  //     var uri = Uri.parse("${AppConstants.baseUrl}/uploadsdriverapp/$formattedDate");
  //     // var uri = Uri.parse("${AppConstants.baseUrlJessyCabs}/tripsheetdatadriverappimage/$formattedDate");
  //     var request = http.MultipartRequest('POST', uri);
  //
  //     request.fields['tripid'] = tripid;
  //     request.fields['documenttype'] = documenttype;
  //
  //     // Upload the file with the unique name
  //     request.files.add(await http.MultipartFile.fromPath('file', tollFile.path,
  //         // filename: fileName
  //     ));
  //
  //     var response = await request.send();
  //
  //     if (response.statusCode == 200) {
  //       try {
  //         // String formattedDate = DateTime.now().millisecondsSinceEpoch.toString();;
  //
  //         var uri = Uri.parse("${AppConstants.baseUrlJessyCabs}/tripsheetdatadriverappimage/$formattedDate");
  //         var request = http.MultipartRequest('POST', uri);
  //
  //
  //
  //         // Upload the file with the unique name
  //         request.files.add(await http.MultipartFile.fromPath('file', tollFile.path,
  //           // filename: fileName
  //         ));
  //
  //         // var response = await request.send();
  //         var response1 = await request.send();
  //         var responseBody = await response1.stream.bytesToString();
  //
  //     print("${responseBody},'asdf'");
  //     if (response1.statusCode == 200) {
  //       print('success request');
  //           return true;
  //         } else {
  //           print("Failed to upload file: ${response1.statusCode}");
  //           return false;
  //         }
  //       } catch (e) {
  //         print("Error during upload: $e");
  //         return false;
  //       }
  //
  //
  //       return true;
  //     } else {
  //       print("Failed to upload file: ${response.statusCode}");
  //       return false;
  //     }
  //   } catch (e) {
  //     print("Error during upload: $e");
  //     return false;
  //   }
  // }













  // Updated method for uploading toll and parking files
  static Future<bool> uploadTollFiles({
    required String tripid,
    required String documenttype,
    required List<File> tollFiles,
  }) async {
    try {
      // Create a list to hold all future upload tasks
      List<Future<void>> uploadTasks = [];

      for (var file in tollFiles) {
        // Create an upload task for each file
        var uploadTask = () async {
          try {
            // Generate a unique filename based on the current timestamp
            String formattedDate = DateTime.now().millisecondsSinceEpoch.toString();
            var uri = Uri.parse("${AppConstants.baseUrl}/uploadsdriverapp/$formattedDate");
            var request = http.MultipartRequest('POST', uri);

            // Add trip ID and document type to the request
            request.fields['tripid'] = tripid;
            request.fields['documenttype'] = documenttype;

            // Add the file to the request
            String fileName = 'toll_${formattedDate}_${file.path.split('/').last}';
            print("Uploading toll file: $fileName");
            request.files.add(await http.MultipartFile.fromPath('file', file.path, filename: fileName));

            var response = await request.send();

            if (response.statusCode == 200) {
              // try {
              //   var uri2 = Uri.parse("${AppConstants.baseUrlJessyCabs}/tripsheetdatadriverappimage/$formattedDate");
              //   var request2 = http.MultipartRequest('POST', uri2);
              //
              //   // Add the file to the second request as well
              //   request2.files.add(await http.MultipartFile.fromPath('file', file.path, filename: fileName));
              //
              //   var response2 = await request2.send();
              //   var responseBody = await response2.stream.bytesToString();
              //
              //   print("Response from second upload: $responseBody");
              //   if (response2.statusCode == 200) {
              //     print('Toll file uploaded successfully: $fileName');
              //   } else {
              //     print("Failed to upload toll file (second request): ${response2.statusCode}");
              //   }
              // } catch (e) {
              //   print("Error in second upload: $e");
              // }
            } else {
              print("Failed to upload toll file (first request): ${response.statusCode}");
            }
          } catch (e) {
            print("Error during toll file upload: $e");
          }
        };

        // Add the upload task to the list
        uploadTasks.add(uploadTask());
      }

      // Wait for all uploads to complete
      await Future.wait(uploadTasks);

      print("All toll files uploaded.");
      return true;
    } catch (e) {
      print("Error during toll file upload: $e");
      return false;
    }
  }














  // static Future<bool> uploadParkingFiles({
  //   required String tripid,
  //   required String documenttype,
  //   required List<File> parkingFiles,  // Accepting list of files
  // }) async {
  //   try {
  //     // Generate a unique filename based on the current date
  //     String formattedDate = DateTime.now().millisecondsSinceEpoch.toString();
  //     var uri = Uri.parse("${AppConstants.baseUrl}/uploadsdriverapp/$formattedDate");
  //     var request = http.MultipartRequest('POST', uri);
  //
  //     // Add trip ID and document type to the request
  //     request.fields['tripid'] = tripid;
  //     request.fields['documenttype'] = documenttype;
  //
  //     // Add all files to the request
  //     for (var file in parkingFiles) {
  //       request.files.add(await http.MultipartFile.fromPath('file', file.path));
  //     }
  //
  //     var response = await request.send();
  //
  //     if (response.statusCode == 200) {
  //       try {
  //         var uri2 = Uri.parse("${AppConstants.baseUrlJessyCabs}/tripsheetdatadriverappimage/$formattedDate");
  //         var request2 = http.MultipartRequest('POST', uri2);
  //
  //         // Add all files to the second request as well
  //         for (var file in parkingFiles) {
  //           request2.files.add(await http.MultipartFile.fromPath('file', file.path));
  //         }
  //
  //         var response2 = await request2.send();
  //         var responseBody = await response2.stream.bytesToString();
  //
  //         print("Response from second upload: $responseBody");
  //         if (response2.statusCode == 200) {
  //           print('Multiple parking file upload successful');
  //           return true;
  //         } else {
  //           print("Failed to upload parking files (second request): ${response2.statusCode}");
  //           return false;
  //         }
  //       } catch (e) {
  //         print("Error in second upload: $e");
  //         return false;
  //       }
  //     } else {
  //       print("Failed to upload parking files (first request): ${response.statusCode}");
  //       return false;
  //     }
  //   } catch (e) {
  //     print("Error during parking file upload: $e");
  //     return false;
  //   }
  // }


  static Future<bool> uploadParkingFiles({
    required String tripid,
    required String documenttype,
    required List<File> parkingFiles,
  }) async {
    try {
      // Create a list to hold all future upload tasks
      List<Future<void>> uploadTasks = [];

      for (var file in parkingFiles) {
        // Generate a unique filename based on the current date for each file
        String formattedDate = DateTime.now().millisecondsSinceEpoch.toString();
        var uri = Uri.parse("${AppConstants.baseUrl}/uploadsdriverapp/$formattedDate");

        // Create a task for each file upload
        var uploadTask = () async {
          try {
            var request = http.MultipartRequest('POST', uri);

            // Add trip ID and document type to the request
            request.fields['tripid'] = tripid;
            request.fields['documenttype'] = documenttype;

            // Add the file to the request
            String fileName = 'parking_${formattedDate}_${file.path.split('/').last}';
            print("Uploading file: $fileName");
            request.files.add(await http.MultipartFile.fromPath('file', file.path, filename: fileName));

            var response = await request.send();

            if (response.statusCode == 200) {
              // try {
              //   var uri2 = Uri.parse("${AppConstants.baseUrlJessyCabs}/tripsheetdatadriverappimage/$formattedDate");
              //   var request2 = http.MultipartRequest('POST', uri2);
              //
              //   // Add the file to the second request as well
              //   request2.files.add(await http.MultipartFile.fromPath('file', file.path, filename: fileName));
              //
              //   var response2 = await request2.send();
              //   var responseBody = await response2.stream.bytesToString();
              //
              //   print("Response from second upload: $responseBody");
              //   if (response2.statusCode == 200) {
              //     print('File uploaded successfully: $fileName');
              //   } else {
              //     print("Failed to upload file (second request): ${response2.statusCode}");
              //   }
              // } catch (e) {
              //   print("Error in second upload: $e");
              // }
            } else {
              print("Failed to upload file (first request): ${response.statusCode}");
            }
          } catch (e) {
            print("Error during file upload: $e");
          }
        };

        // Add the task to the list
        uploadTasks.add(uploadTask());
      }

      // Wait for all uploads to complete
      await Future.wait(uploadTasks);

      print("All files uploaded.");
      return true;
    } catch (e) {
      print("Error during parking file upload: $e");
      return false;
    }
  }








  // static Future<bool> uploadParkingFile({
  //   required String tripid,
  //   required String documenttype,
  //   required File parkingFile,
  // }) async {
  //   try {
  //     // Generate the unique filename based on the current date
  //     String formattedDate = DateTime.now().millisecondsSinceEpoch.toString();
  //     // String fileName = 'file_$formattedDate.jpg';
  //
  //     var uri = Uri.parse("${AppConstants.baseUrl}/uploadsdriverapp/$formattedDate");
  //     var request = http.MultipartRequest('POST', uri);
  //
  //     request.fields['tripid'] = tripid;
  //     request.fields['documenttype'] = documenttype;
  //
  //     // Upload the file with the unique name
  //     request.files.add(await http.MultipartFile.fromPath('file', parkingFile.path,
  //       // filename: fileName
  //     ));
  //
  //     var response = await request.send();
  //
  //     if (response.statusCode == 200) {
  //
  //
  //       try {
  //         // Generate the unique filename based on the current date
  //         // String formattedDate = DateTime.now().millisecondsSinceEpoch.toString();
  //         // String fileName = 'file_$formattedDate.jpg';
  //
  //         var uri = Uri.parse("${AppConstants.baseUrlJessyCabs}/tripsheetdatadriverappimage/$formattedDate");
  //         var request = http.MultipartRequest('POST', uri);
  //
  //
  //
  //         // Upload the file with the unique name
  //         request.files.add(await http.MultipartFile.fromPath('file', parkingFile.path,
  //           // filename: fileName
  //         ));
  //
  //         var response1 = await request.send();
  //         var responseBody = await response1.stream.bytesToString();
  //         print("repo to upload file: ${responseBody}");
  //         if (response1.statusCode == 200) {
  //           return true;
  //         } else {
  //           print("Failed to upload file: ${response.statusCode}");
  //           return false;
  //         }
  //       } catch (e) {
  //         print("Error during upload: $e");
  //         return false;
  //       }
  //
  //
  //       return true;
  //     } else {
  //       print("Failed to upload file: ${response.statusCode}");
  //       return false;
  //     }
  //   } catch (e) {
  //     print("Error during upload: $e");
  //     return false;
  //   }
  // }
  //









  static Future<bool> updateTripDetailsTollParking({
    required String tripid,
    required String toll,
    required String parking,
  }) async {
    final url = Uri.parse('${AppConstants.baseUrl}/update_updatetrip');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tripid': tripid,
          'toll': toll,
          'parking': parking,
        }),
      );

      if (response.statusCode == 200) {
        print('Trip details updated successfully!');
        return true;
      } else {
        print('Failed to update trip details: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating trip details: $e');
      return false;
    }
  }



  //for starting kilometer file upload
  static Future<bool> uploadstartingkm({
    required String tripid,
    required String documenttype,
    required File startingkilometer,
  }) async {
    try {
      print('insie api url');
      // Generate the unique filename based on the current date
      String formattedDate = DateTime.now().millisecondsSinceEpoch.toString();

      var uri = Uri.parse("${AppConstants.baseUrl}/uploadsdriverapp/$formattedDate");
      var request = http.MultipartRequest('POST', uri);

      request.fields['tripid'] = tripid;
      request.fields['documenttype'] = documenttype;

      // Upload the file with the unique name
      request.files.add(await http.MultipartFile.fromPath('file', startingkilometer.path,
        // filename: fileName
      ));

      var response= await request.send();

      if (response.statusCode == 200) {
        // print("success to upload fileeeeee: ${response.statusCode}");
        //
        // try {
        //   print('insie api url');
        //   // Generate the unique filename based on the current date
        //   // String formattedDate = DateTime.now().millisecondsSinceEpoch.toString();;
        //
        //   var uri = Uri.parse("${AppConstants.baseUrlJessyCabs}/tripsheetdatadriverappimage/$formattedDate");
        //   var request = http.MultipartRequest('POST', uri);
        //
        //   // request.fields['tripid'] = tripid;
        //   // request.fields['documenttype'] = documenttype;
        //
        //   // Upload the file with the unique name
        //   request.files.add(await http.MultipartFile.fromPath('file', startingkilometer.path,
        //     // filename: fileName
        //   ));
        //
        //   var response1 = await request.send();
        //   var responseBody = await response1.stream.bytesToString();
        //
        //   print("Full API Response: ${response1.statusCode} - $responseBody");
        //   print('${response1},insiee api urlll');
        //   print('${responseBody},insie api urlll');
        //   if (response1.statusCode == 200) {
        //     print("success for starting to upload filee: ${response1.statusCode}");
        //
        //     return true;
        //   } else {
        //     print("Failed to upload filee: ${response1.statusCode}");
        //     return false;
        //   }
        // } catch (e) {
        //   print("Error during upload: $e");
        //   return false;
        // }

        return true;
      } else {
        print("Failed to upload filee: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error during upload: $e");
      return false;
    }
  }



  //for closing kilometer file upload
  static Future<bool> uploadClosingkm({
    required String tripid,
    required String documenttype,
    required File closingkilometer,
  }) async {
    try {
      // Generate the unique filename based on the current date
      String formattedDate = DateTime.now().millisecondsSinceEpoch.toString();;

      var uri = Uri.parse("${AppConstants.baseUrl}/uploadsdriverapp/$formattedDate");
      var request = http.MultipartRequest('POST', uri);

      request.fields['tripid'] = tripid;
      request.fields['documenttype'] = documenttype;

      // Upload the file with the unique name
      request.files.add(await http.MultipartFile.fromPath('file', closingkilometer.path,
        // filename: fileName
      ));

      var response = await request.send();

      if (response.statusCode == 200) {
        //
        // try {
        //   // Generate the unique filename based on the current date
        //   // String formattedDate = DateTime.now().millisecondsSinceEpoch.toString();;
        //
        //   var uri = Uri.parse("${AppConstants.baseUrlJessyCabs}/tripsheetdatadriverappimage/$formattedDate");
        //   var request = http.MultipartRequest('POST', uri);
        //
        //   // request.fields['tripid'] = tripid;
        //   // request.fields['documenttype'] = documenttype;
        //
        //   // Upload the file with the unique name
        //   request.files.add(await http.MultipartFile.fromPath('file', closingkilometer.path,
        //     // filename: fileName
        //   ));
        //
        //   var response1 = await request.send();
        //
        //   var responseBody = await response1.stream.bytesToString();
        //
        //   print("Full API Response: ${response1.statusCode} - $responseBody");
        //   print('${response1},insie api url');
        //   print('${responseBody},insie api url');
        //   if (response1.statusCode == 200) {
        //     print("success for starting to upload filee: ${response1.statusCode}");
        //     return true;
        //   } else {
        //     print("Failed to upload file: ${response1.statusCode}");
        //     return false;
        //   }
        // } catch (e) {
        //   print("Error during upload: $e");
        //   return false;
        // }

        return true;
      } else {
        print("Failed to upload file: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error during upload: $e");
      return false;
    }
  }


//starting and closing km update text
  static Future<bool> updateTripDetailsStartandClosekm({
    required String tripid,
    required String startingkm,
    required String closigkm,
  }) async {
    final url = Uri.parse('${AppConstants.baseUrl}/update_updatetrip');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tripid': tripid,
          'StartingKm': startingkm,
          'ClosingKm': closigkm,
        }),
      );

      if (response.statusCode == 200) {
        print('Trip details updated successfully!');
        return true;
      } else {
        print('Failed to update trip details: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating trip details: $e');
      return false;
    }
  }




  static Future<void> updateKmTripDetailsUpload({
    required String tripId,
    required String startKm,
    required String closeKm,
    required int hcl,
    required String duty,
  }) async {
    final url = Uri.parse('${AppConstants.baseUrl}/kmupdatetripsheet');
    try {
      print('Sending data to API: $url');
      print('Payload: {tripId: $tripId, startkm: $startKm, closekm: $closeKm, Hcl: $hcl, duty: $duty}');

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'}, // Set JSON header
        body: jsonEncode({
          'tripId': tripId,
          'startkm': startKm,
          'closekm': closeKm,
          'Hcl': hcl.toString(),
          'duty': duty,
        }),
      );

      print('Response status code: ${startKm}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Successfully updated KM details');
      } else {
        throw Exception('Failed to update KM details: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Error occurred: $e');
    }
  }


// uploading starting kilometr to the starting kilometer screen starts
  static Future<void> updateStartinKMToSratingkmScreen({
    required String tripId,
    required String startKm,
    required int hcl,
    required String duty,
  }) async {
    final url = Uri.parse('${AppConstants.baseUrl}/startkmupdatetripsheet');
    try {
      print('Sending data to API: $url');
      print('Payload: {tripId: $tripId, startkm: $startKm,  Hcl: $hcl, duty: $duty}');

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'}, // Set JSON header
        body: jsonEncode({
          'tripId': tripId,
          'startkm': startKm,
          'Hcl': hcl,
          'duty': duty,
          // tripId,startkm ,Hcl,duty
        }),
      );

      print('Response status code: ${tripId}');
      print('Response status code: ${startKm}');
      print('Response status code: ${hcl}');
      print('Response status code: ${duty}');
      print('Response body: ${response.statusCode}');

      // if (response.statusCode == 200) {
      //
      //   final data = jsonDecode(response.body);
      //
      //   if (data['success']) {
      //
      //     return;
      //
      //   } else {
      //
      //     throw Exception(data['message'] ?? "Failed to update starting kilometer");
      //   }
      //   print('Successfully updated KM details');
      //   return;
      //
      // } else {
      //   throw Exception("Server error: ${response.statusCode}");
      //
      // }

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          if (data['success'] == true) {
            print('Successfully updated KM details');
            return;
          } else {
            throw Exception(data['message'] ?? "Failed to update starting kilometer");
          }
        } else {
          print("Empty response body");
          return;
        }
      }

    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Error occurredzzzzz: $e');
    }
  }

// uploading starting kilometr to the starting kilometer screen completed



// uploading starting kilometr to the Trip details upload starts
  static Future<void> updateCloseKMToTripDetailsUploadScreen({
    required String tripId,
    required String closeKm,
    required int hcl,
    required String duty,
  }) async {
    final url = Uri.parse('${AppConstants.baseUrl}/closekmupdatetripsheet');
    try {
      print('Sending data to API: $url');
      print('Payload: {tripId: $tripId,  closekm: $closeKm, Hcl: $hcl, duty: $duty}');

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'}, // Set JSON header
        body: jsonEncode({
          'tripId': tripId,
          'closekm': closeKm,
          'Hcl': hcl.toString(),
          'duty': duty,
        }),
      );

      print('Response status code: ${closeKm}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Successfully updated Closing KM details');
      } else {
        throw Exception('Failed to update KM details: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Error occurred: $e');
    }
  }

// uploading closing kilometr to the Trip details upload screen completed



  // Fetch trip details by tripId
  static Future<Map<String, dynamic>?> fetchTripDetails(String tripId) async {
    final String url = '${AppConstants.baseUrl}/tripsheets_fulldetails/$tripId';

    // Log the URL being called for debugging
    print('URL being called: $url');

    try {
      final response = await http.get(Uri.parse(url));

      // Log the status code and response body for debugging
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print("Success: Objects fetched");
        final data = json.decode(response.body);
        return data; // Return the trip details if successful
      } else if (response.statusCode == 404) {
        print('Trip not found');
        return null; // Handle not found
      } else {
        print('Error: Failed to fetch trip details. Status Code: ${response.statusCode}');
        return null; // Handle other status codes
      }
    } catch (e) {
      print('Error occurred while fetching trip details: $e');
      return null; // Handle network or parsing errors
    }
  }




//for fetching driver details used  in home page
  static Future<Map<String, dynamic>?> getDriverProfile(String username) async {
    final url = Uri.parse('${AppConstants.baseUrl}/getDriverProfile');

    print('Making API call to getDriverProfile with username: $username');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username}),
      );

      // Print the status code to check if it's 200 or another error code
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Print the response body to check if it contains the expected data
        print('Response body: ${response.body}');

        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        print('Driver not found (404)');
        throw Exception('Driver not found');
      } else {
        print('Failed to fetch driver profile (status code: ${response.statusCode})');
        throw Exception('Failed to fetch driver profile');
      }
    } catch (e) {
      // Catch and print any errors
      print('Error fetching driver profile: $e');
      rethrow;
    }
  }
//for fetching driver details used  in home page end



  //close values showing for rides screen
  static Future<List<Map<String, dynamic>>> fetchTripSheetClosedRides({
    required String userId,
    // required String username,
    required String drivername,
  }) async {
    try {
      // Print the inputs to ensure they are passed correctly
      print('Fetching trip sheet for userId: $userId, username: $drivername');

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/tripsheetRides/$drivername'), // Pass username in the URL
        headers: {
          'userId': userId,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response and return a list of maps
        List<Map<String, dynamic>> trips = List<Map<String, dynamic>>.from(json.decode(response.body));
        print('Fetched tripsheet data: $trips');
        return trips;
      } else {
        throw Exception('Failed to fetch trip sheet: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error in fetchTripSheet: $e');
      rethrow; // Re-throw the error to handle it in the calling function
    }
  }


  // static Future<List<dynamic>> getTripSheetRides(String username) async {
  //   try {
  //     final response = await http.get(Uri.parse('${AppConstants.baseUrl}/tripsheetRides/$username'));
  //
  //     if (response.statusCode == 200) {
  //       return jsonDecode(response.body);
  //     } else {
  //       throw Exception('Failed to load trip sheet rides');
  //     }
  //   } catch (e) {
  //     print("Error fetching trip sheet rides: $e");
  //     return [];
  //   }
  // }










//close values showing for rides screen end




//values getting according to the filter
  static Future<List<Map<String, dynamic>>> fetchTripSheetFilteredRides({
    // required String username,
    required String drivername,
    required DateTime? startDate,
    required DateTime? endDate,
  }) async {
    final url = Uri.parse('${AppConstants.baseUrl}/tripsheetfilterdate');

    final body = jsonEncode({
      // "username": username,
      "username": drivername,
      "startDate": startDate?.toIso8601String(),
      "endDate": endDate?.toIso8601String(),
    });

    print('Request URL: $url');
    print('Request Body: $body');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Parsed Response: $responseData');
        return List<Map<String, dynamic>>.from(responseData);
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error: $e');
    }
  }



//values getting according to the filter end



// adding lat long to database start

  static Future<bool> sendVehicleLocation({
    required String vehicleNo,
    required double latitude,
    required double longitude,
  }) async {
    final String url = "${AppConstants.baseUrl}/addvehiclelocation";

    final Map<String, dynamic> requestData = {
      "vehicleno": vehicleNo,
      "latitudeloc": latitude,
      "longitutdeloc": longitude,
      "Trip_id": "12345", // Dummy Trip ID
      "Runing_Date": DateTime.now().toIso8601String().split("T")[0], // Current Date
      "Runing_Time": DateTime.now().toLocal().toString().split(" ")[1], // Current Time
      "Trip_Status": "Active",
      "Tripstarttime": "08:00 AM",
      "TripEndTime": "10:00 AM",
      "created_at": DateTime.now().toIso8601String(),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error sending location data: $e");
      return false;
    }
  }
  // adding lat long to database end




//registering driver starts
  static Future<Map<String, dynamic>> registerDriver({
    required String username,
    required String email,
    required String password,
    required String mobileNumber,
  }) async {
    final url = Uri.parse('${AppConstants.baseUrl}/driverCredentialRegister');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
          "mobileNumber": mobileNumber,
        }),
      );

      if (response.statusCode == 201) {
        return {"success": true, "message": jsonDecode(response.body)["message"]};
      } else {
        return {"success": false, "message": jsonDecode(response.body)["message"]};
      }
    } catch (e) {
      return {"success": false, "message": "Something went wrong: $e"};
    }
  }

  //registering driver completed





//profile driver data get api starts
  static Future<bool> updateProfile({
    required String username,
    required String mobileNo,
    required String password,
    required String email,
  }) async {
    final url = Uri.parse('${AppConstants.baseUrl}/update_updateprofile');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'mobileno': mobileNo,
          'userpassword': password,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        print('Profile updated successfully');
        return true; // Return true if update is successful
      } else {
        print('Failed to update profile: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }
//profile driver data get api completed


//profile driver data image api starts

  static Future<bool> uploadProfilePhoto({
    required String username,
    required File imageFile,
  }) async {
    final url = Uri.parse('${AppConstants.baseUrl}/uploadProfilePhoto?username=$username');

    try {
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath(
        'Profile_image',
        imageFile.path,
        // filename: basename(imageFile.path),
        filename: path.basename(imageFile.path),

      ));

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('Profile photo uploaded successfully');
        return true;
      } else {
        print('Failed to upload profile photo: $responseBody');
        return false;
      }
    } catch (e) {
      print('Error uploading profile photo: $e');
      return false;
    }
  }
//profile driver data image api completed


// button click on tracking page for status start

  static Future<bool> insertStartData({
    required String vehicleNo,
    required String tripId,
    required double latitude,
    required double longitude,
    required String runningDate,
    required String runningTime,
    required String tripStatus,
    required String tripStartTime,
    required String tripEndTime,
  }) async {
    final Uri url = Uri.parse('${AppConstants.baseUrl}/insertStartData');

    // ✅ Print the API URL
    print("Sending request to: $url");

    // ✅ Print request body
    final Map<String, dynamic> requestBody = {
      "Vehicle_No": vehicleNo,
      "Trip_id": tripId,
      "Latitude_loc": latitude,
      "Longtitude_loc": longitude,
      "Runing_Date": runningDate,
      "Runing_Time": runningTime,
      "Trip_Status": tripStatus,
      "Tripstarttime": tripStartTime,
      "TripEndTime": tripEndTime,
      "created_at": DateTime.now().toIso8601String(),
    };
    print("Request Body: ${jsonEncode(requestBody)}");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      // ✅ Print HTTP response status and body
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("API Error: $e");
      return false;
    }
  }

// button click on tracking page for status completed

// button click on customer location page  for status Reached

  static Future<bool> insertReachedStatus({
    required String vehicleNo,
    required String tripId,
    required double latitude,
    required double longitude,
    required String runningDate,
    required String runningTime,
    required String tripStatus,
    required String tripStartTime,
    required String tripEndTime,
  }) async {
    final Uri url = Uri.parse('${AppConstants.baseUrl}/insertReachedData');

    // ✅ Print the API URL
    print("Sendingff request to: $url");

    // ✅ Print request body
    final Map<String, dynamic> requestBody = {
      "Vehicle_No": vehicleNo,
      "Trip_id": tripId,
      "Latitude_loc": latitude,
      "Longtitude_loc": longitude,
      "Runing_Date": runningDate,
      "Runing_Time": runningTime,
      "Trip_Status": tripStatus,
      "Tripstarttime": tripStartTime,
      "TripEndTime": tripEndTime,
      "created_at": DateTime.now().toIso8601String(),
    };
    print("Request Body: ${jsonEncode(requestBody)}");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      // ✅ Print HTTP response status and body
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("API Error: $e");
      return false;
    }
  }

// button click on customer location page  for status Reached




// button click on customer location page  for status Reached

  static Future<bool> insertWayPointStatus({
    required String vehicleNo,
    required String tripId,
    required double latitude,
    required double longitude,
    required String runningDate,
    required String runningTime,
    required String tripStatus,
    required String tripStartTime,
    required String tripEndTime,
  }) async {
    final Uri url = Uri.parse('${AppConstants.baseUrl}/insertWayPointData');

    // ✅ Print the API URL
    print("Sending request to: $url");

    // ✅ Print request body
    final Map<String, dynamic> requestBody = {
      "Vehicle_No": vehicleNo,
      "Trip_id": tripId,
      "Latitude_loc": latitude,
      "Longtitude_loc": longitude,
      "Runing_Date": runningDate,
      "Runing_Time": runningTime,
      "Trip_Status": tripStatus,
      "Tripstarttime": tripStartTime,
      "TripEndTime": tripEndTime,
      "created_at": DateTime.now().toIso8601String(),
    };
    print("Request Body: ${jsonEncode(requestBody)}");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      // ✅ Print HTTP response status and body
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("API Error: $e");
      return false;
    }
  }

// button click on customer location page  for status Reached







  Future<List<dynamic>> fetchClosedTrips(String username) async {
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String url = '${AppConstants.baseUrl}/closedtripsheetbasedDate/$username/$todayDate';

    try {
      print("object");
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }




















  Future<String?> fetchSingleDocumentImage(String tripId, String documentType) async {
    final url = Uri.parse("${AppConstants.baseUrl}/uploadsfordocumenttype?tripid=$tripId&documenttype=$documentType");

    try {
      final response = await http.get(url);
      print("📡 API Response for $documentType: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['attachedImagePaths'].isNotEmpty) {
          print("✅ Image Path Found for $documentType: ${data['attachedImagePaths'][0]}");
          return data['attachedImagePaths'][0];
        } else {
          print("⚠️ No Image Found for $documentType");
          return null;
        }
      } else {
        print("❌ API Error for $documentType: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("🚨 Exception in API Call: $e");
      return null;
    }
  }


  Future<List<String>> fetchDocumentImages(String tripId, String documentType) async {
    final url = Uri.parse("${AppConstants.baseUrl}/uploadsfordocumenttype?tripid=$tripId&documenttype=$documentType");

    try {
      final response = await http.get(url);
      print("📡 API Response for $documentType: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['attachedImagePaths'].isNotEmpty) {
          List<String> imagePaths = List<String>.from(data['attachedImagePaths']);
          print("✅ Image Paths Found for $documentType: $imagePaths");
          return imagePaths;
        } else {
          print("⚠️ No Images Found for $documentType");
          return [];
        }
      } else {
        print("❌ API Error for $documentType: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("🚨 Exception in API Call: $e");
      return [];
    }
  }










  // Future<String?> fetchSignaturePhoto(String tripId) async {
  //   final response = await http.get(Uri.parse('${AppConstants.baseUrl}/signature_photos?tripid=$tripId'));
  //
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     return '${AppConstants.baseUrl}/${data['uploadedImagePath']}'; // Construct full image URL
  //   } else {
  //     return null;
  //   }
  // }

  Future<String?> fetchSignaturePhoto(String tripId) async {
    final url = Uri.parse('${AppConstants.baseUrl}/signature_photos?tripid=$tripId');
    print('Fetching signature photo from: $url'); // Debugging statement

    try {
      final response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response bodyy: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String imageUrl = '${AppConstants.baseUrl}/${data['uploadedImagePath']}';
        print('Image URL: $imageUrl');
        return imageUrl;
      } else {
        print('Error: Signature not found or server error.');
        return null;
      }
    } catch (e) {
      print('Exception in API call: $e');
      return null;
    }
  }





//getting close kilometer dynamically starts
  Future<Map<String, dynamic>> getKMForParticularTrip(String tripId) async {
    final String url = '${AppConstants.baseUrl}/KMForParticularTrip?Trip_id=$tripId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'Failed to fetch data. Status Code: ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }
//getting close kilometer dynamically completed



















//for testing latlong for g map data
  static Future<http.Response> addVehicleLocation({
    required String vehicleno,
    required double latitudeloc,
    required double longitutdeloc,
    required String gpsPointAddrress,
    required String tripId,
    required String runingDate,
    required String runingTime,
    required String tripStatus,
    required String tripStartTime,
    required String tripEndTime,
    required String createdAt,
  }) async {
    final url = Uri.parse('${AppConstants.baseUrl}/addvehiclelocationUniqueLatlongTest');

    final body = {
      "vehicleno": vehicleno,
      "latitudeloc": latitudeloc,
      "longitutdeloc": longitutdeloc,
      "gpsPointAddrress": gpsPointAddrress,

      "Trip_id": tripId,
      "Runing_Date": runingDate,
      "Runing_Time": runingTime,
      "Trip_Status": tripStatus,
      "Tripstarttime": tripStartTime,
      "TripEndTime": tripEndTime,
      "created_at": createdAt,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      return response;
    } catch (e) {
      throw Exception("Failed to connect to the server: $e");
    }
  }













//for sending otp started
  static Future<Map<String, dynamic>> sendOtp({
    required String number,
    required String email,
    required String name,
    required String senderEmail,
    required String senderPass,
  }) async {
    final url = Uri.parse('${AppConstants.baseUrl}/send-otp');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "mobile": number,
          "email": email,
          'name':name,
          'senderEmail': senderEmail,
          'senderPass': senderPass,

        }),
      );

      if (response.statusCode == 200) {
        print('resposne ${response.body}');
        return {"success": true, "message": jsonDecode(response.body)["message"]};
      } else {
        print('resposne2 ${response.body}');
        return {"success": false, "message": jsonDecode(response.body)["message"]};
      }
    } catch (e) {
      return {"success": false, "message": "Something went wrong: $e"};
    }
  }
//for sending otp completed

//for verify otp started

  static Future<Map<String, dynamic>> verifyOtp({
    required String number,
    required String email,
    required String name,
    required String senderEmail,
    required String senderPass,

  }) async {
    print('verifyOtp received to APi service${name}');

    final url = Uri.parse('${AppConstants.baseUrl}/verifyotp');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "mobile": number,
          "email": email,
          'name':name,
          'senderEmail': senderEmail,
          'senderPass': senderPass,

        }),
      );

      if (response.statusCode == 200) {
        print('resposne ${response.body}');
        return {"success": true, "message": jsonDecode(response.body)["message"]};
      } else {
        print('resposne2 ${response.body}');
        return {"success": false, "message": jsonDecode(response.body)["message"]};
      }
    } catch (e) {
      return {"success": false, "message": "Something went wrong: $e"};
    }
  }

//for verify otp completed


  //organization data  get api started

  static Future<Map<String, dynamic>> fetchSenderInfo() async {
    print("ready to fetch in API_SERVICE");
    final url = Uri.parse('${AppConstants.baseUrl}/organizationdata');

    try {
      print('urllll${url}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return {
          'success': true,
          'senderEmail': data[0]['Sender_Mail'],
          'senderPass': data[0]['EmailApp_Password'],
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to load sender info',
        };
      }
    } catch (e) {
      return {"success": false, "message": "Something went wrong: $e"};
    }
  }
  //organization data  get api completed




//for mail sent to the hybrid customer details started

  static Future<bool> sendBookingEmail({
    required String guestName,
    required String guestMobileNo,
    required String email,
    required String startKm,
    required String closeKm,
    required String duration,
    required String senderEmail,
    required String senderPassword,
    required String TripId,
    required String Vehiclenumber,
    required String VehicleName,
    required String DutyType,
    required String ReportTime,
    required String ReleaseTime,
    required String ReportDate,
    required String ReleaseDate,

    required String Startpoint,
    required String Endpoint,


  }) async {
    final url = Uri.parse('${AppConstants.baseUrl}/send-email1');

    print('📤 Sending email request to $url');
    print('📦 Payload: $guestName, $guestMobileNo, $email, $startKm, $closeKm, $duration, $senderEmail, $senderPassword, $TripId, $Vehiclenumber, $VehicleName,$DutyType, $ReportTime, $ReleaseTime  ,$ReportDate, $Startpoint, $Endpoint');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "guestname": guestName,
          "guestmobileno": guestMobileNo,
          "email": email,
          "Startkm": startKm,
          "closekm": closeKm,
          "duration": duration,
          "Sender_Mail": senderEmail,
          "EmailApp_Password": senderPassword,
          "TripId": TripId,
          "Vechicle_Number": Vehiclenumber,
          "Vechicl_Name": VehicleName,
          "Duty_type": DutyType,
          "Report_time": ReportTime,
          "Release_time": ReleaseTime,
          "Report_date": ReportDate,
          "Release_date": ReleaseDate,
          "StartPoint": Startpoint,
          "EndPoint": Endpoint,
        }),
      );
      print('📦 Payload: $guestName, $guestMobileNo, $email, $startKm, $closeKm, $duration, $senderEmail, $senderPassword, $TripId, $Vehiclenumber, $VehicleName,$DutyType, $ReportTime, $ReleaseTime  ,$ReportDate, $Startpoint, $Endpoint');

      print('📬 Response Status boo email: ${response.statusCode}');
      print('📬 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Email sent successfully');
        return true;
      } else {
        print('❌ Error sending email: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Exception occurred while sending email: $e');
      return false;
    }
  }

//for mail sent to the hybrid customer details started






  static Future<Map<String, dynamic>>signUpStepOne ({
    required String name,
    required String email,
    required String phone,

  }) async{

    print('first step values received in Api_Service ${email}');
    print('first step values received in Api_Service ${name}');
    print('first step values received in Api_Service ${phone}');

    String uri = "${AppConstants.baseUrl}/signup";

    try{
      final response = await http.post(Uri.parse(uri),
          headers: {
            'Content-Type':'application/json'
          },
          body: jsonEncode({
            'name':name,
            'email':email,
            'phone':phone,
          })
      );
      print('first step response from backend in Api_Service ${response}');


      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> resBody = jsonDecode(response.body);
        print('response else statements in Api_Service $resBody');
        return resBody;
      }
    } catch (e) {
      throw Exception('Sign up error: $e');
    }
  }



  static Future<Map<String, dynamic>>signUpStepTwo ({
    required String phone,
  }) async{

    print('second step values received in Api_Service ${phone}');

    String uri = "${AppConstants.baseUrl}/signup_again_otp";

    try{
      final response = await http.post(Uri.parse(uri),
          headers: {
            'Content-Type':'application/json'
          },
          body: jsonEncode({
            'phone':phone,
          })
      );
      print('second step response from backend in Api_Service ${response}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to sign up: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Sign up error: $e');
    }
  }

//new for Login VIA mobile number


  static Future<Map<String, dynamic>>loginViaStepOne ({
    required String phone,
  }) async{

    print('third step values received in Api_Service ${phone}');

    String uri = "${AppConstants.baseUrl}/loginVia";

    try{
      final response = await http.post(Uri.parse(uri),
          headers: {
            'Content-Type':'application/json'
          },
          body: jsonEncode({
            'phone':phone,
          })
      );
      print('third step response from backend in Api_Service ${response}');


      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> resBody = jsonDecode(response.body);
        print('third response else statements in Api_Service $resBody');
        return resBody;
      }
    } catch (e) {
      throw Exception('Sign up error: $e');
    }
  }



  static Future<Map<String, dynamic>>LoginViaStepTwo ({
    required String phone,
  }) async{

    print('fourth step values received in Api_Service ${phone}');

    String uri = "${AppConstants.baseUrl}/loginVia_again_otp";

    try{
      final response = await http.post(Uri.parse(uri),
          headers: {
            'Content-Type':'application/json'
          },
          body: jsonEncode({
            'phone':phone,
          })
      );
      print('fourth step response from backend in Api_Service ${response}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> resBody = jsonDecode(response.body);
        print('fourth response else statements in Api_Service $resBody');
        return resBody;
      }
    } catch (e) {
      throw Exception('Sign up error: $e');
    }
  }



  static Future<Map<String, dynamic>>fetchDistance({
    required String tripId
  }) async{

    final url = Uri.parse("${AppConstants.baseUrl}/calculate_time/${tripId}");
    print('api service screen got tripId for duration time ${tripId}');
    try{
      final response = await http.get(url);

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);

        print("Decoded backend response: $data");
        return {
          'success': true,
          'duration':data['durationHMS'],
        };
      } else {
        print("Else condition: backend for distance");

        return {

          'success': false,
          'message': 'Backend returned failure',
        };
      }

    } catch(e){
      print("Catch block: backend for distance $e");
      return {"success": false, "message": "Something went wrong: $e"};
    }

  }



  static Future<Map<String, dynamic>>fetchOkayMessage({ required  String trip_id}) async{

    final url = Uri.parse("${AppConstants.baseUrl}/getokaymessage/${trip_id}");

    print('api service page received trip_id for okay message ${trip_id}');
    try{
      final response =await http.get(url);

      if(response.statusCode == 200){

        final data = jsonDecode(response.body);
        print(" reponse from backend for okay message ${jsonDecode(response.body)}");
        print("Decoded backend response for get okay message: $data");

        final startTime = data['TripStartTime'];

        print("eeeeeeee ${startTime}");

        return {
          'success': true,
          'information':startTime
        };
      } else {
        print("Else condition: backend for okay message");
        return {
          'success': false,
          'message': 'Backend returned failure',
        };
      }
    } catch(e){
      print("Catch block: backend for okay message $e");
      return {"success": false, "message": "Something went wrong: $e"};
    }
  }



}




