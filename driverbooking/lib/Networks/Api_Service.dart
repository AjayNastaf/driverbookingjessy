import 'dart:convert';
import 'package:http/http.dart' as http; // Ensure this is imported correctly
import 'package:driverbooking/Screens/Home.dart';
import 'package:driverbooking/Screens/HomeScreen/MapScreen.dart';
import '../Screens/HomeScreen/MapScreen.dart';
import '../Utils/AppConstants.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:io'; // Add this for File class



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



  static Future<Map<String, dynamic>> uploadImage(File image1, File image2) async {
    final url = Uri.parse('${AppConstants.baseUrl}/upload-images');
    final request = http.MultipartRequest('POST', url);

    // Add images with correct field names
    request.files.add(await http.MultipartFile.fromPath('startingimage', image1.path));
    request.files.add(await http.MultipartFile.fromPath('endingimage', image2.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      // return json.decode(responseBody) as Map<String, dynamic>;
      return {
        'success': true,
        'message': 'Images uploaded successfully!',
      };
    } else {
      return {
        'success': false,
        'message': 'Failed to upload images. HTTP ${response.statusCode}',
      };
    }
  }




  static Future<List<Map<String, dynamic>>> fetchTripSheet({
    required String userId,
    required String username,
  }) async {
    try {
      // Print the inputs to ensure they are passed correctly
      print('Fetching trip sheet for userId: $userId, username: $username');

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/tripsheet/$username'), // Pass username in the URL
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

  // for booking details screen
  static Future<List<Map<String, dynamic>>> fetchTripSheetBooking({
    required String userId,
    required String username,
  }) async {
    try {
      // Print the inputs to ensure they are passed correctly
      print('Fetching trip sheet for userId: $userId, username: $username');

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/tripsheet/$username'), // Pass username in the URL
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


}




