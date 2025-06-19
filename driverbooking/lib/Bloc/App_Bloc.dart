import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jessy_cabs/Bloc/AppBloc_Events.dart';
import 'package:jessy_cabs/Bloc/AppBloc_State.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Networks/Api_Service.dart';
import 'dart:math';
import 'dart:convert';
import 'dart:io';  // Add this import to access the 'File' class.
import 'package:http/http.dart' as http;
import 'package:jessy_cabs/Utils/AppConstants.dart';
import 'package:jessy_cabs/Utils/AllImports.dart';
import '../Screens/CustomerLocationReached/CustomerLocationReached.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginAtempt>(_onLoginAtempt);
  }
}

void _onLoginAtempt(LoginAtempt event, Emitter<LoginState> emit) async {
  emit(LoginLoading());
  try {
    final response = await ApiService.login(
      username: event.username,
      password: event.password,
    );

    if (response.statusCode == 200) {
      // final data = jsonDecode(response.body);
      // print('${data},akll');
      // final id = data['userId'];
      // print("idddddddddddddddddddddddddddddddd: $id");

      final data = jsonDecode(response.body);
      String driverName = data['user'][0]['drivername']; // Extracting drivername

      final id = data['userId'];
      final driverdata = driverName;
      print("API Response Data: $data"); // Debug API response
      print("API Response Dataes: $driverdata, $data"); // Debug API response
      Map<String, dynamic> userData = {
        "drivername": driverdata,

      };
      // Save user data in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setString('userData', jsonEncode(data));
      // await prefs.setString('userData', jsonEncode(driverdata));
      await prefs.setString('userData', jsonEncode(userData)); // Encode as JSON before saving

      // Debugging: Print saved data
      print("Saved Data local: ${prefs.getString('userData')}");

      print("User data saved successfully!");
      emit(LoginCompleted('$id'));
    } else {
      emit(LoginFailure("Login failed, please check your credentials."));
    }
  } catch (e) {
    emit(LoginFailure("An error occurred: $e"));
  }
}





// At the bottom of App_Bloc.dart for user login in no logout





class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthenticationBloc() : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  void _onAppStarted(AppStarted event, Emitter<AuthenticationState> emit) async {
    final userId = await _storage.read(key: 'userId');
    final username = await _storage.read(key: 'username');

    if (userId != null && username != null) {
      emit(Authenticated(userId: userId, username: username));
    } else {
      emit(Unauthenticated());
    }
  }



  Future<void> _onLoggedIn(LoggedIn event, Emitter<AuthenticationState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    // Save userId and username securely
    await _storage.write(key: 'userId', value: event.userId);
    await _storage.write(key: 'username', value: event.username);

    emit(Authenticated(userId: event.userId, username: event.username));
  }


  // Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthenticationState> emit) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();
  //   emit(Unauthenticated());
  // }

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthenticationState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Clear secure storage too
    await _storage.delete(key: 'userId');
    await _storage.delete(key: 'username');

    emit(Unauthenticated());
  }
}




// At the bottom of App_Bloc.dart for user login in no logout












class CustomerOtpVerifyBloc extends Bloc<CustomerOtpVerifyEvent , CustomerOtpVerifyState>{
  CustomerOtpVerifyBloc():super(OtpVerifyStarts()){
    on<OtpVerifyAttempt>(_onOtpVerifyAttempt);
  }
}

void _onOtpVerifyAttempt(OtpVerifyAttempt event, Emitter<CustomerOtpVerifyState> emit)async{
emit(OtpVerifyLoading());

  try{
    final response = await ApiService.customerotpverify(
      otp: event.otp
    );

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      final otp = data['otp'];
      emit(OtpVerifyCompleted('$otp'));
    }
    else{
      emit(OtpVerifyFailed("otp Verify Failed"));

    }
  }
  catch(e){
    emit(OtpVerifyFailed("An error occurred: $e"));

  }
}








// class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
//   RegisterBloc() : super(RegisterInitial()) {
//     on<RequestOtpAndRegister>((event, emit) async {
//       emit(RegisterLoading());
//
//       // Step 1: Generate OTP
//       final random = Random();
//       final otp = (1000 + random.nextInt(9000)).toString();
//       print("Generated OTP: $otp");
//
//       // Step 2: Send OTP to User's Email
//       try {
//         final sendOtpEmailResult = await ApiService.sendOtpEmail(
//           otp,
//           event.email,
//           event.username,
//         );
//
//         if (sendOtpEmailResult) {
//           print("OTP successfully sent.");
//
//           // Step 3: Proceed with Registration if OTP Sending Succeeds
//           final success = await ApiService.registers(
//             // context: context,
//             username: event.username,
//             password: event.password,
//             phonenumber: event.phone,
//             email: event.email,
//             otp: otp,
//           );
//
//           if (success) {
//             emit(RegisterSuccess());
//           } else {
//             emit(RegisterFailure("Registration failed."));
//           }
//         } else {
//           emit(RequestOtpFailure(
//               "Failed to send OTP. Username or email might already be taken."));
//         }
//       } catch (error) {
//         emit(RegisterFailure("An error occurred during registration: $error"));
//       }
//     });
//   }
// }

class UpdateUserBloc extends Bloc<UpdateUserEvent, UpdateUserState> {
  UpdateUserBloc() : super(UpdateUserInitial()) {
    on<UpdateUserAttempt>(_onUpdateUserAtempt);
  }
}

void _onUpdateUserAtempt(
    UpdateUserAttempt event, Emitter<UpdateUserState> emit) async {
  emit(UpdateUserLoading());

  print('iiiiiiidddddddddddddddddddddddddd: ${event.userId}');
  try {
    final response = await ApiService.updateUserDetails(
      userId: event.userId,
      username: event.username,
      password: event.password,
      phonenumber: event.phone,
      email: event.email,
    );
    if (response.statusCode == 200) {
      emit(UpdateUserCompleted());
    } else {
      emit(UpdateUserFailure("Login failed, please check your credentials."));
    }
  } catch (e) {
    emit(UpdateUserFailure("An error occurred: $e"));
  }
}

class CheckCurrentPasswordBloc
    extends Bloc<CheckCurrentPasswordEvent, CheckCurrentPasswordState> {
  CheckCurrentPasswordBloc() : super(CheckCurrentPasswordInitial()) {
    on<CheckCurrentPasswordAttempt>(_onCheckCurrentPasswordAtempt);
  }
}

void _onCheckCurrentPasswordAtempt(CheckCurrentPasswordAttempt event,
    Emitter<CheckCurrentPasswordState> emit) async {
  emit(CheckCurrentPasswordLoading());

  try {
    final response = await ApiService.checkCurrentPassword(
        userId: event.userId, password: event.password);
    if (response.statusCode == 200) {
      emit(CheckCurrentPasswordCompleted());
    } else {
      emit(CheckCurrentPasswordFailure(
          "Password verfication failed."));
    }
  } catch (e) {
    emit(CheckCurrentPasswordFailure("An error occurred: $e"));
  }
}

class UpdatePasswordBloc
    extends Bloc<UpdatePasswordEvent, UpdatePasswordState> {
  UpdatePasswordBloc() : super(UpdatePasswordInitial()) {
    on<UpdatePasswordAttempt>(_onUpdatePasswordAtempt);
  }
}

void _onUpdatePasswordAtempt(
    UpdatePasswordAttempt event, Emitter<UpdatePasswordState> emit) async {
  emit(UpdatePasswordLoading());

  try {
    final response = await ApiService.changePassword(
        userId: event.userId, newPassword: event.newPassword);
    if (response.statusCode == 200) {
      emit(UpdatePasswordCompleted());
    } else {
      emit(UpdatePasswordFailure(
          "Login failed, please check your credentials."));
    }
  } catch (e) {
    emit(UpdatePasswordFailure("An error occurred: $e"));
  }
}

class ForgotPasswordEmailVerificationBloc extends Bloc<
    ForgotPasswordEmailVerificationEvent,
    ForgotPasswordEmailVerificationState> {
  ForgotPasswordEmailVerificationBloc()
      : super(ForgotPasswordEmailVerificationInitial()) {
    on<ForgotPasswordEmailVerificationAttempt>(
        _onForgotPasswordEmailVerificationAtempt);
  }
}

void _onForgotPasswordEmailVerificationAtempt(
    ForgotPasswordEmailVerificationAttempt event,
    Emitter<ForgotPasswordEmailVerificationState> emit) async {
  emit(ForgotPasswordEmailVerificationLoading());

  try {
    final response = await ApiService.forgotPasswordEmailVerification(
      email: event.email,
    );
    print(response);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final userId = data['userId'];
      emit(ForgotPasswordEmailVerificationCompleted('$userId'));
    } else {
      emit(ForgotPasswordEmailVerificationFailure(
          "Login failed, please check your credentials."));
    }
  } catch (e) {
    emit(ForgotPasswordEmailVerificationFailure("An error occurred: $e"));
  }
}

class CheckForgotPasswordOtpBloc
    extends Bloc<CheckForgotPasswordOtpEvent, CheckForgotPasswordOtpState> {
  CheckForgotPasswordOtpBloc() : super(CheckForgotPasswordOtpInitial()) {
    on<CheckForgotPasswordOtpAttempt>(_onCheckForgotPasswordOtpAtempt);
  }
}

void _onCheckForgotPasswordOtpAtempt(CheckForgotPasswordOtpAttempt event,
    Emitter<CheckForgotPasswordOtpState> emit) async {
  emit(CheckForgotPasswordOtpLoading());
  try {
    final response = await ApiService.checkForgotPasswordOtp(
      email: event.email,
    );
    print(response);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final otp = data['otp'];
      if (event.otp == otp) {
        emit(CheckForgotPasswordOtpCompleted());
      } else {
        emit(CheckForgotPasswordOtpFailure("Incorrect OTP"));
      }
    } else {
      emit(CheckForgotPasswordOtpFailure(
          "OTP verification failed"));
    }
  } catch (e) {
    emit(CheckForgotPasswordOtpFailure("An error occurred: $e"));
  }
}


class ChangePasswordForgotBloc
    extends Bloc<ChangePasswordForgotEvent, ChangePasswordForgotState> {
  ChangePasswordForgotBloc() : super(ChangePasswordForgotInitial()) {
    on<ChangePasswordForgotAttempt>(_onChangePasswordForgotAtempt);
  }
}

void _onChangePasswordForgotAtempt(ChangePasswordForgotAttempt event,
    Emitter<ChangePasswordForgotState> emit) async {
  emit(ChangePasswordForgotLoading());
  try {
    final response = await ApiService.changePasswordForgot(
        userId: event.userId,
        newPassword: event.newPassword
    );
    print(response);
    if (response.statusCode == 200) {
      emit(ChangePasswordForgotCompleted());
    } else {
      emit(ChangePasswordForgotFailure(
          "Password update failed."));
    }
  } catch (e) {
    emit(ChangePasswordForgotFailure("An error occurred: $e"));
  }
}









//
// class TripDetailsUploadBloc
//     extends Bloc<TripDetailsUploadEvent, TripDetailsUploadState> {
//   TripDetailsUploadBloc() : super(StartKmUploadInitial()) {
//     on<SelectStartKmImageAttempt>(_onSelectStartKmImageAttempt);
//     on<UploadStartKmImageEvent>(_onUploadStartKmImageEvent);
//
//     on<SelectCloseKmImageAttempt>(_onSelectCloseKmImageAttempt);
//     on<UploadCloseKmImageEvent>(_onUploadCloseKmImageEvent);
//   }
//
//   Future<void> _onSelectStartKmImageAttempt(
//       SelectStartKmImageAttempt event,
//       Emitter<TripDetailsUploadState> emit,
//       ) async {
//     if (event.image.existsSync()) {
//       emit(StartKmImageSelected());
//     } else {
//       emit(StartKmUploadFailure(message: "Image file not found!"));
//     }
//   }
//
//   Future<void> _onUploadStartKmImageEvent(
//       UploadStartKmImageEvent event,
//       Emitter<TripDetailsUploadState> emit,
//       ) async {
//     emit(StartKmUploadInProgress());
//     try {
//       final response = await ApiService.uploadImage(event.image);
//       if (response['success']) {
//         emit(StartKmUploadComplete(message: "Image uploaded successfully!"));
//       } else {
//         emit(StartKmUploadFailure(message: response['message']));
//       }
//     } catch (e) {
//       emit(StartKmUploadFailure(message: "Failed to upload: ${e.toString()}"));
//     }
//   }
//
//   Future<void> _onSelectCloseKmImageAttempt(
//       SelectCloseKmImageAttempt event,
//       Emitter<TripDetailsUploadState> emit,
//       ) async {
//     if (event.image.existsSync()) {
//       emit(CloseKmImageSelected());
//     } else {
//       emit(CloseKmUploadFailure(message: "Image file not found!"));
//     }
//   }
//
//   Future<void> _onUploadCloseKmImageEvent(
//       UploadCloseKmImageEvent event,
//       Emitter<TripDetailsUploadState> emit,
//       ) async {
//     emit(CloseKmUploadInProgress());
//     try {
//       final response = await ApiService.uploadImage(event.image);
//       if (response['success']) {
//         emit(CloseKmUploadComplete(message: "Image uploaded successfully!"));
//       } else {
//         emit(CloseKmUploadFailure(message: response['message']));
//       }
//     } catch (e) {
//       emit(CloseKmUploadFailure(message: "Failed to upload: ${e.toString()}"));
//     }
//   }
// }







































//// Above bloc codes are old below are new for apis

//Registering Bloc codes start

class RegisterBloc extends Bloc<RegisterEvent, RegisterState>{
  RegisterBloc(): super(RegisteringInitial()){
    on<RegisterUserEvent>(_onRegisterUser);
  }


  Future<void> _onRegisterUser(
      RegisterUserEvent event,
      Emitter<RegisterState> emit,
      )async{
    emit(RegisteringLoading());

    try{
      final response = await ApiService.registerDriver(
        username: event.username,
        password: event.password,
        email: event.email,
        mobileNumber: event.mobileNumber,
      );
      if(response['success']){
        emit(RegisteringSucces(response['message']));

      }else{
        emit(RegisteringFailure(response['message']));
      }
    }catch(e){
      emit(RegisteringFailure("Something went wrong. Please try again."));

    };

}

}

//Registering Bloc codes ends


//for TripSheet values getingapi bloc code started

class TripSheetValuesBloc extends Bloc<TripSheetValuesEvent , TripSheetValuesState>{
  TripSheetValuesBloc():super(FetchingTripSheetValuesInitial()){
    on<FetchTripSheetValues>(_onGettingTripSheetValues);
  }

  Future<void> _onGettingTripSheetValues(FetchTripSheetValues event , Emitter<TripSheetValuesState> emit)async{
  try{
    final data = await ApiService.fetchTripSheet(
      userId: event.userid,
      // username: event.username,
      drivername: event.drivername,
    );
    emit(FetchingTripSheetValuesLoaded(data));
  }catch(e){
    emit(FetchingTripSheetValuesFailure('Error fetching trip sheet: $e'));
  }
  }
}

//for TripSheet values getingapi bloc code ended


//for Rides screen tripSheet closed values geting api bloc start
class TripSheetClosedValuesBloc extends Bloc<TripSheetClosedValuesEvent , TripSheetClosedValuesState>{
  TripSheetClosedValuesBloc() :super(TripSheetStatusClosedLoading()) {
    on<TripsheetStatusClosed>(_onGettingTripSheetClosedValues);
  }

  Future<void> _onGettingTripSheetClosedValues(TripsheetStatusClosed event,
      Emitter<TripSheetClosedValuesState> emit) async {
    try {
      emit(TripSheetStatusClosedLoading());
      final Data = await ApiService.fetchTripSheetClosedRides(
        userId: event.userid,
        // username: event.username
        drivername: event.drivername
      );
      emit(TripsheetStatusClosedLoaded(Data));

    } catch (e) {
      emit(TripSheetClosedFailure('Failed to Load Closed Values $e'));
    }
  }
}

//for Rides screen tripSheet closed values geting api bloc completed







//for Drawer profile driver details bloc start
class DrawerDriverDataBloc extends Bloc<DrawerDriverDetaisEvent, DrawerDriverDetailsState> {
  DrawerDriverDataBloc() : super(DrawerDriverDataLoading()) {
    on<DrawerDriverData>(_onGettingDriverValuesForDrawer);
  }

  Future<void> _onGettingDriverValuesForDrawer(
      DrawerDriverData event, Emitter<DrawerDriverDetailsState> emit) async {
    try {
      print("Fetching driver details for username: ${event.username}");
      emit(DrawerDriverDataLoading()); // Show loading state

      final getDriverDetails = await ApiService.getDriverProfile(event.username);

      if (getDriverDetails != null) {
        print("User details fetched successfully: $getDriverDetails");

        emit(DrawerDriverDataLoaded(
          username: getDriverDetails['username'] ?? '',
          email: getDriverDetails['Email'] ?? '',
          phoneNumber: getDriverDetails['Mobileno'] ?? '',
          password: getDriverDetails['userpassword'] ?? '',
          profileImage: getDriverDetails['Profile_image']??'',
          // profileImage:getDriverDetails['Profile_image']??','
        ));
      } else {
        print("Failed to retrieve user details.");
        emit(DrawerDriverDataFailure("Failed to retrieve user details."));
      }
    } catch (e) {
      print("Error fetching user details: $e");
      emit(DrawerDriverDataFailure("Error fetching user details: $e"));
    }
  }
}

//for Drawer profile driver details bloc completed





//for fetching values from tripsheet by userid bloc start

class GettingTripSheetDetailsByUseridBloc extends Bloc< GettingTripSheetDetailsByUserIdEvent , GettingTripSheetDetilsByUseridState>{
  GettingTripSheetDetailsByUseridBloc():super(Getting_TripSheetDetails_ByUserid_Loading()){
    on<Getting_TripSheet_Details_By_Userid>(_onGettingTripdetailsValuesBasedUseriD);
  }

  Future<void> _onGettingTripdetailsValuesBasedUseriD(
      Getting_TripSheet_Details_By_Userid event , Emitter <GettingTripSheetDetilsByUseridState> emit)async{

    try{
      emit(Getting_TripSheetDetails_ByUserid_Loading());
      final tripSheets  = await ApiService.fetchTripSheetbytripid(
        username: event.username,
        userId: event.userId,
        duty: event.duty,
        tripId: event.tripId
      );
      emit(Getting_TripSheetDetails_ByUserid_Loaded(tripSheets));
    }catch(e){
      emit(Getting_TripSheetDetails_ByUserid_Failure("Failed to fetch trip sheet: $e"));
    }

  }
}

//for fetching values from tripsheet by userid bloc completed




//update TripSheet status Accepts,onGoing,Closed,Waiting bloc Starts
class UpdateTripStatusInTripsheetBloc extends Bloc<UpdateTripStatusInTripSheetEvent, UpdateTripStatusInTripsheetState> {
  UpdateTripStatusInTripsheetBloc() : super(UpdateTripStatusInTripsheetInitial()) {
    on<UpdateTripStatusEventClass>(_onUpdateStatusOnTheTrip);
  }

  Future<void> _onUpdateStatusOnTheTrip(
      UpdateTripStatusEventClass event,
      Emitter<UpdateTripStatusInTripsheetState> emit) async {
    try {
      emit(UpdateTripStatusInTripsheetLoading());

      await ApiService.updateTripStatus(
        tripId: event.tripId,
        status: event.status,
      );

      emit(UpdateTripStatusInTripsheetSuccess());
    } catch (e) {
      emit(UpdateTripStatusInTripsheetFailure(e.toString())); // Fix: Return actual error message
    }
  }
}
//update TripSheet status Accepts,onGoing,Closed,Waiting bloc completed




//for enteringStarting Kilometer text to the tripsheet bloc start
class StartKmBloc extends Bloc<StartKmEvent, StartKmState> {
  StartKmBloc() : super(StartKmInitial()) {

    // Handling text submission event
    on<SubmitStartingKilometerText>((event, emit) async {
      try {

        emit(StartKmTextLoading()); // Show loading state

        // Ensure hclValue is parsed correctly
        int hclInt = int.tryParse(event.hclValue) ?? 0;

        // API Call
        await ApiService.updateStartinKMToSratingkmScreen(
          tripId: event.tripId,
          startKm: event.startKm,
          hcl: hclInt,
          duty: event.dutyValue,
        );

        emit(StartKmTextSubmitted()); // Emit success state
      } catch (e, stackTrace) {
        emit(StartKmError("Failed to submit starting km text: $e"));
      }
    });


    // Handling image upload event
    on<UploadStartingKilometerImage>((event, emit) async {
      try {
        emit(StartKmImageUploading()); // Show loading state

        bool result = await ApiService.uploadstartingkm(
          tripid: event.tripId,
          documenttype: 'StartingKm',
          startingkilometer: event.startingKilometerImage,
        );

        if (result) {
          emit(StartKmImageUploaded()); // Success state
        } else {
          emit(StartKmError("Image upload failed"));
        }
      } catch (e) {
        emit(StartKmError("Failed to upload starting km image: ${e.toString()}"));
      }
    });
  }
}
//for enteringStarting Kilometer text to the tripsheet bloc completed





//this the total bloc implementing 3 apis in the Trip details Upload page starts
class TripUploadBloc extends Bloc<TripUploadEvent, TripUploadState> {
  TripUploadBloc() : super(TripUploadInitial()) {
    on<UploadClosingKmText>(_uploadClosingKmText);
    on<UploadClosingKmImage>(_uploadClosingKmImage);
    on<UpdateSignatureStatus>(_updateSignatureStatus);
  }


  //updating closing kilometer
  Future<void> _uploadClosingKmText(UploadClosingKmText event, Emitter<TripUploadState> emit) async {
    emit(TripUploadLoading());
    try {
      final String dateSignature = DateTime.now().toIso8601String().split('T')[0] +
          ' ' +
          DateTime.now().toIso8601String().split('T')[1].split('.')[0];

      // final String signTime = TimeOfDay.now().format(DateTime.now().hour);
      // final TimeOfDay now = TimeOfDay.now();
      // final String signTime = "${now.hour}:${now.minute}"; // Simple fallback formatting
      final DateTime now = DateTime.now();
      final String signTime = '${now.hour.toString().padLeft(2, '0')}:'
          '${now.minute.toString().padLeft(2, '0')}:'
          '${now.second.toString().padLeft(2, '0')}';

      await ApiService.sendSignatureDetails(
        tripId: event.tripId,
        dateSignature: dateSignature,
        signTime: signTime,
        status: "Accept",
      );
// showSuccessSnackBar(context, "Closing Kilometer text uploaded successfully");
      emit(TripUploadSuccess(

          "Closing Kilometer text uploaded successfully"
      ));
    } catch (error) {
      emit(TripUploadFailure("Error uploading data: $error"));
    }
  }

  //update closing kilometer image
  Future<void> _uploadClosingKmImage(UploadClosingKmImage event, Emitter<TripUploadState> emit) async {
    emit(TripUploadLoading());
    try {
      bool result = await ApiService.uploadClosingkm(
        tripid: event.tripId,
        documenttype: 'ClosingKm',
        closingkilometer: event.image,
      );

      if (result) {
        emit(TripUploadSuccess("Closing Kilometer image uploaded successfully"));
      } else {
        emit(TripUploadFailure("Failed to upload Closing Kilometer image"));
      }
    } catch (error) {
      emit(TripUploadFailure("Error uploading image: $error"));
    }
  }

  //update signature status bloc
  Future<void> _updateSignatureStatus(UpdateSignatureStatus event, Emitter<TripUploadState> emit) async {
    emit(TripUploadLoading());
    try {
      await ApiService.updateCloseKMToTripDetailsUploadScreen(
        tripId: event.tripId,
        closeKm: event.closeKm,
        hcl: event.hcl,
        duty: event.duty,
      );

      emit(TripUploadSuccess("Closing Kilometer details updated successfully"));
    } catch (error) {
      emit(TripUploadFailure("Error updating data: $error"));
    }
  }
}
//this the total bloc implementing 3 apis in the Trip details Upload page completed



//this is total bloc based on events for end ride screen where sign image save, sign status , trip status event starts



class TripSignatureBloc extends Bloc<TripSignatureEvent, TripSignatureState> {
  TripSignatureBloc() : super(TripSignatureInitial()) {
    on<SaveSignatureEvent>(_saveSignature);
    on<SendSignatureDetailsEvent>(_sendSignatureDetails);
    on<UpdateTripStatusEvent>(_updateTripStatus);
  }

  //save signature to the signature db bloc


  Future<void> _saveSignature(
      SaveSignatureEvent event, Emitter<TripSignatureState> emit) async {
    emit(TripSignatureLoading());
    try {
      await ApiService.saveSignature(
        tripId: event.tripId,
        signatureData: event.base64Signature,
        imageName: event.imageName,
        endtrip: event.endtrip,
        endtime: event.endtime,
      );
      emit(SaveSignatureSuccess());
    } catch (e) {
      emit(TripSignatureFailure("Failed to save signature: $e"));
    }
  }


//save signature status to the Signaturetimedetails db bloc

  Future<void> _sendSignatureDetails(
      SendSignatureDetailsEvent event, Emitter<TripSignatureState> emit) async {
    try {
      await ApiService.sendSignatureDetailsUpdated(
        tripId: event.tripId,
        dateSignature: event.dateSignature,
        signTime: event.signTime,
        status: event.status,
      );
      emit(SendSignatureDetailsSuccess());
    } catch (e) {
      emit(TripSignatureFailure("Failed to send signature details: $e"));
    }
  }


//update trip status in tripsheet db bloc

  Future<void> _updateTripStatus(
      UpdateTripStatusEvent event, Emitter<TripSignatureState> emit) async {
    try {
      await ApiService.updateTripStatusCompleted(
        tripId: event.tripId,
        apps: event.apps,
      );
      emit(UpdateTripStatusSuccess());
    } catch (e) {
      emit(TripSignatureFailure("Failed to update trip status: $e"));
    }
  }
}

//this is total bloc based on events for end ride screen where sign image save, sign status , trip status event completed



//For fetching tripsheet details based on tripId bloc starts TripSheetDetailsTripIdEvent

// class TripSignatureBloc extends Bloc<TripSignatureEvent, TripSignatureState> {
class TripSheetDetailsTripIdBloc extends Bloc<TripSheetDetailsTripIdEvent, TripSheetDetailsTripIdState> {
  TripSheetDetailsTripIdBloc() : super(TripDetailsByTripIdInitial()) {
    on<FetchTripDetailsByTripIdEventClass>(_onFetchTripDetailsByTripId);
  }

  Future<void> _onFetchTripDetailsByTripId(
      FetchTripDetailsByTripIdEventClass event, Emitter<TripSheetDetailsTripIdState> emit) async {
    emit(TripDetailsByTripIdLoading());

    try {
      final tripDetails = await ApiService.fetchTripDetails(event.tripId);

      if (tripDetails != null) {
        emit(TripDetailsByTripIdLoaded(tripDetails: tripDetails));
      } else {
        emit(TripDetailsByTripIdError(message: "No trip details found."));
      }
    } catch (e) {
      emit(TripDetailsByTripIdError(message: "Error loading trip details: $e"));
    }
  }
}
//For fetching tripsheet details based on tripId bloc completed



//toll and parking text upload and tool and parking image upload bloc starts TollParkingDetailsState



// class TripSignatureBloc extends Bloc<TripSignatureEvent, TripSignatureState> {
class TollParkingDetailsBloc extends Bloc<TollParkingDetailsEvent, TollParkingDetailsState> {
  TollParkingDetailsBloc() : super(TollParkingDetailsInitial()) {
    on<UpdateTollParking>(_onUpdateTollParking);
    on<UploadParkingFile>(_onUploadParkingFile);
    on<UploadTollFile>(_onUploadTollFile);
  }

  // API Call: Update Toll & Parking Details
  Future<void> _onUpdateTollParking(
      UpdateTollParking event, Emitter<TollParkingDetailsState> emit) async {
    emit(TollParkingDetailsLoading());

    try {
      bool result = await ApiService.updateTripDetailsTollParking(
        tripid: event.tripId,
        toll: event.toll,
        parking: event.parking,
      );

      if (result) {
        emit(TollParkingUpdated());
      } else {
        emit(TollParkingDetailsError(message: "Failed to update toll and parking details."));
      }
    } catch (e) {
      emit(TollParkingDetailsError(message: "Error updating toll and parking: $e"));
    }
  }

  // API Call: Upload Parking File
  Future<void> _onUploadParkingFile(
      UploadParkingFile event, Emitter<TollParkingDetailsState> emit) async {
    emit(TollParkingDetailsLoading());

    try {
      bool result = await ApiService.uploadParkingFiles(
        tripid: event.tripId,
        documenttype: 'Parking',
        parkingFiles: event.parkingFiles,
      );

      if (result) {
        emit(ParkingFileUploaded());
      } else {
        emit(TollParkingDetailsError(message: "Failed to upload parking file."));
      }
    } catch (e) {
      emit(TollParkingDetailsError(message: "Error uploading parking file: $e"));
    }
  }

  // API Call: Upload Toll File
  // Future<void> _onUploadTollFile(
  //     UploadTollFile event, Emitter<TollParkingDetailsState> emit) async {
  //   emit(TollParkingDetailsLoading());
  //
  //   try {
  //     bool result = await ApiService.uploadTollFile(
  //       tripid: event.tripId,
  //       documenttype: 'Toll',
  //       tollFile: event.tollFile,
  //     );
  //
  //     if (result) {
  //       emit(TollFileUploaded());
  //     } else {
  //       emit(TollParkingDetailsError(message: "Failed to upload toll file."));
  //     }
  //   } catch (e) {
  //     emit(TollParkingDetailsError(message: "Error uploading toll file: $e"));
  //   }
  // }



  Future<void> _onUploadTollFile(
      UploadTollFile event, Emitter<TollParkingDetailsState> emit) async {
    emit(TollParkingDetailsLoading());

    try {
      bool result = await ApiService.uploadTollFiles(
        tripid: event.tripId,
        documenttype: 'Toll',
        tollFiles: event.tollFiles,  // Pass the list of files
      );

      if (result) {
        emit(TollFileUploaded());
      } else {
        emit(TollParkingDetailsError(message: "Failed to upload toll files."));
      }
    } catch (e) {
      emit(TollParkingDetailsError(message: "Error uploading toll files: $e"));
    }
  }


}


//toll and parking text upload and tool and parking image upload bloc completed




// saving status as On_Going bloc start
class TripBloc extends Bloc<TripEvent, TripState> {
  TripBloc() : super(TripInitial()) {
    // ✅ Register the event handler for StartRideEvent
    on<StartRideEvent>((event, emit) async {
      emit(TripLoading());
      try {
        final response = await ApiService.updateTripStatusStartRide(event.tripId, 'On_Going');

        if (response.statusCode == 200) {
          emit(TripSuccess());
        } else {
          emit(TripFailure(error: 'Failed to update status'));
        }
      } catch (e) {
        emit(TripFailure(error: e.toString()));
      }
    });
  }
}
// saving status as On_Going bloc competed


//history page Tripsheet values closed bloc starts
class TripSheetBloc extends Bloc<TripSheetEvent, TripSheetState> {
  TripSheetBloc() : super(TripSheetInitial()) {
    on<FetchTripSheetClosedRides>(_onFetchTripSheetClosedRides);
  }

  Future<void> _onFetchTripSheetClosedRides(
      FetchTripSheetClosedRides event, Emitter<TripSheetState> emit) async {
    print("🟢 Event received: FetchTripSheetClosedRides");
    emit(TripSheetLoading());
    print("⏳ Loading state emitted");

    try {
      final data = await ApiService.fetchTripSheetClosedRides(
        userId: event.userId,
        // drivername: event.username,
        drivername: event.drivername,
      );

      print("📦 API Responses: $data");

      if (data.isNotEmpty) {
        print("✅ Data received, emitting TripSheetLoaded");
        emit(TripSheetLoaded(tripSheetData: data));
      } else {
        print("⚠️ Empty data, emitting TripSheetError");
        emit(TripSheetError(message: "No trips available"));
      }
    } catch (e) {
      print("❌ Error fetching data: $e");
      emit(TripSheetError(message: "Failed to load trips"));
    }
  }
}

//history page Tripsheet values closed bloc completed





//history page Tripsheet values closed filtered dates bloc starts


class FetchFilteredRidesBloc extends Bloc<FetchFilteredRidesEvents, FetchFilteredRidesState> {
  FetchFilteredRidesBloc() : super(FetchFilteredRidesInitial()) {
    on<FetchFilteredRides>(_onFetchFilteredRides);
  }

  Future<void> _onFetchFilteredRides(
      FetchFilteredRides event, Emitter<FetchFilteredRidesState> emit) async {
    emit(FetchFilteredRidesLoading());

    try {
      final data = await ApiService.fetchTripSheetFilteredRides(
        // username: event.username,
        drivername: event.drivername,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(FetchFilteredRidesLoaded(data));
    } catch (e) {
      emit(FetchFilteredRidesError( "No trips available, Please Select Valid Date Range"));
    }
  }
}

//history page Tripsheet values closed filtered dates bloc completed





//profile photo and profile details upload bloc completed

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {

 //profile details
    on<UpdateProfileEvent>((event, emit) async {
      emit(ProfileLoading());

      bool success = await ApiService.updateProfile(
        username: event.username,
        mobileNo: event.mobileNo,
        password: event.password,
        email: event.email,
      );

      if (success) {
        emit(ProfileUpdated());
      } else {
        emit(ProfileError("Failed to update profile"));
      }
    });
//profile photo
    on<UploadProfilePhotoEvent>((event, emit) async {
      emit(ProfileLoading());

      bool success = await ApiService.uploadProfilePhoto(
        username: event.username,
        imageFile: event.imageFile,
      );

      if (success) {
        emit(ProfilePhotoUploaded());
      } else {
        emit(ProfilePhotoUploadError("Failed to upload profile photo"));
      }
    });
  }
}

//profile photo and profile details upload bloc completed




//trip tracking bloc starts (tracking, customer location reached page)


class TripTrackingDetailsBloc extends Bloc<TripTrackingDetailsEvent, TripTrackingDetailsState> {
  TripTrackingDetailsBloc() : super(TripTrackingDetailsInitial()) {
    on<FetchTripTrackingDetails>(_onFetchTripTrackingDetails);
    on<SaveLocationToDatabase>(_onSaveLocationToDatabase);
    on<EndRideEvent>(_onEndRide);
    // on<StartWayPointEvent>(_onStartingWayPoint);
    // on<EndWayPointEvent>(_onEndingWayPoint);

  }

  Future<void> _onFetchTripTrackingDetails(
      FetchTripTrackingDetails event, Emitter<TripTrackingDetailsState> emit) async {
    emit(TripTrackingDetailsLoading());

    try {
      print('Fetching trip details for tripId: ${event.tripId}');

      final tripDetails = await ApiService.fetchTripDetails(event.tripId);

      if (tripDetails != null) {
        print('API Response Keys: ${tripDetails.keys}'); // Debugging keys

        var vehicleNo = tripDetails['vehRegNo']?.toString() ?? "";
        var tripStatus = tripDetails['apps']?.toString() ?? "";

        if (vehicleNo.isNotEmpty && tripStatus.isNotEmpty) {
          emit(TripTrackingDetailsLoaded(vehicleNumber: vehicleNo, status: tripStatus));
          print("object");
        } else {
          print("Trip details missing: vehicleNo=$vehicleNo, tripStatus=$tripStatus");
          emit(TripTrackingDetailsError("Trip details are incomplete"));
        }
      } else {
        emit(TripTrackingDetailsError("No trip details found."));
      }
    } catch (e) {
      emit(TripTrackingDetailsError("Error fetching trip details: $e"));
    }
  }



  Future<void> _onSaveLocationToDatabase(
      SaveLocationToDatabase event, Emitter<TripTrackingDetailsState> emit) async {
    emit(SaveLocationLoading());
print('yess');
    final Map<String, dynamic> requestData = {
      "vehicleno": event.vehicleNo,
      "latitudeloc": event.latitude,
      "longitutdeloc": event.longitude,
      "Trip_id": event.tripId,
      "Runing_Date": DateTime.now().toIso8601String().split("T")[0],
      "Runing_Time": DateTime.now().toLocal().toString().split(" ")[1],
      "Trip_Status": event.tripStatus,
      "Tripstarttime": DateTime.now().toLocal().toString().split(" ")[1],
      "TripEndTime": DateTime.now().toLocal().toString().split(" ")[1],
      "created_at": DateTime.now().toIso8601String(),
      "reach_30minutes":event.reached_30minutes,
    };

    try {
      final response = await http.post(
        Uri.parse("${AppConstants.baseUrl}/addvehiclelocationUniqueLatlong"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        emit(SaveLocationSuccess());
        print("Lat Long Sav Successfully");
      } else {
        emit(SaveLocationFailure("Failed to save location"));
      }
    } catch (e) {
      emit(SaveLocationFailure("Error sending location data: $e"));
    }
  }
}

//// trip tracking bloc reached completed (tracking, customer location reached page)
Future<void> _onEndRide(
    EndRideEvent event, Emitter<TripTrackingDetailsState> emit) async {

  print("➡ Event received: EndRideEvent");
  emit(SaveLocationLoading()); // Show loading state

  print("🔹 Latitude: ${event.latitude}, Longitude: ${event.longitude}");
  print("🔹 Vehicle No: ${event.vehicleNo}, Trip ID: ${event.tripId}");

  if (event.latitude == 0.0 && event.longitude == 0.0) {
    print("⚠ Invalid location (0.0, 0.0) - Not saving to database.");
    emit(SaveLocationFailure("⚠ Invalid location (0.0, 0.0) - Not saving to database."));
    return;
  }

  final Map<String, dynamic> requestData = {

    "Vehicle_No": event.vehicleNo, // Ensure it matches the DB column name
    "Latitude_loc": event.latitude,
    "Longtitude_loc": event.longitude,
    "Trip_id": event.tripId,
    "Runing_Date": DateTime.now().toIso8601String().split("T")[0],
    "Runing_Time": DateTime.now().toLocal().toString().split(" ")[1],
    "Trip_Status": "Reached",
    "Tripstarttime": DateTime.now().toLocal().toString().split(" ")[1],
    "TripEndTime": DateTime.now().toLocal().toString().split(" ")[1],
    "created_at": DateTime.now().toIso8601String(),


  };

  print("📤 Sending request to API: ${AppConstants.baseUrl}/insertReachedData");
  print("📌 Requested Data reached: $requestData");

  try {
    final response = await http.post(
      Uri.parse("${AppConstants.baseUrl}/insertReachedData"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestData),
    );

    print("✅ Response Status Code: ${response.statusCode}");
    print("✅ Response Body: ${response.body}");

    if (response.statusCode == 200) {
      emit(SaveLocationSuccess());
      print("🎉 Trip Ended Successfully!");
    } else {
      print("❌ Failed to end trip. Status Code: ${response.statusCode}");
      emit(SaveLocationFailure("Failed to end trip."));
    }
  } catch (e) {
    print("🚨 Error ending trip: $e");
    emit(SaveLocationFailure("Error ending trip: $e"));
  }
}


//trip tracking bloc reached completed (tracking, customer location reached page)



//trip tracking way point bloc starts (tracking, customer location reached page)
//
// Future<void> _onStartingWayPoint(
//     StartWayPointEvent event, Emitter<TripTrackingDetailsState> emit) async {
//   print("➡ Event received: EndRideEvent");
//   emit(SaveLocationLoading()); // Show loading state
//
//   print("🔹 Latitude: ${event.latitude}, Longitude: ${event.longitude}");
//   print("🔹 Vehicle No: ${event.vehicleNo}, Trip ID: ${event.tripId}");
//
//   if (event.latitude == 0.0 && event.longitude == 0.0) {
//     print("⚠ Invalid location (0.0, 0.0) - Not saving to database.");
//     emit(SaveLocationFailure("⚠ Invalid location (0.0, 0.0) - Not saving to database."));
//     return;
//   }
//
//   final Map<String, dynamic> requestData = {
//
//     "Vehicle_No": event.vehicleNo, // Ensure it matches the DB column name
//     "Latitude_loc": event.latitude,
//     "Longtitude_loc": event.longitude,
//     "Trip_id": event.tripId,
//     "Runing_Date": DateTime.now().toIso8601String().split("T")[0],
//     "Runing_Time": DateTime.now().toLocal().toString().split(" ")[1],
//     "Trip_Status": "waypoint_Started ",
//     "Tripstarttime": DateTime.now().toLocal().toString().split(" ")[1],
//     "TripEndTime": DateTime.now().toIso8601String(),
//     "created_at": DateTime.now().toIso8601String(),
//
//
//   };
//
//   print("📤 Sending request to API: ${AppConstants.baseUrl}/insertWayPointData");
//   print("📌 Requested Data: $requestData");
//
//   try {
//     final response = await http.post(
//       Uri.parse("${AppConstants.baseUrl}/insertReachedData"),
//       headers: {"Content-Type": "application/json"},
//       body: json.encode(requestData),
//     );
//
//     print("✅ Response Status Code: ${response.statusCode}");
//     print("✅ Response Body: ${response.body}");
//
//     if (response.statusCode == 200) {
//       emit(SaveLocationSuccess());
//       print("🎉wap Point starts successfully!");
//     } else {
//       print("❌ Failed to end trip. Status Code: ${response.statusCode}");
//       emit(SaveLocationFailure("Failed to end trip."));
//     }
//   } catch (e) {
//     print("🚨 Error ending trip: $e");
//     emit(SaveLocationFailure("Error ending trip: $e"));
//   }
// }
//trip tracking way point starts bloc completed (tracking, customer location reached page)



//trip tracking way point reached bloc starts (tracking, customer location reached page)
//
// Future<void> _onEndingWayPoint(
//     EndWayPointEvent event, Emitter<TripTrackingDetailsState> emit) async {
//   print("➡ Event received: EndRideEvent");
//   emit(SaveLocationLoading()); // Show loading state
//
//   print("🔹 Latitude: ${event.latitude}, Longitude: ${event.longitude}");
//   print("🔹 Vehicle No: ${event.vehicleNo}, Trip ID: ${event.tripId}");
//
//   if (event.latitude == 0.0 && event.longitude == 0.0) {
//     print("⚠ Invalid location (0.0, 0.0) - Not saving to database.");
//     emit(SaveLocationFailure("⚠ Invalid location (0.0, 0.0) - Not saving to database."));
//     return;
//   }
//
//   final Map<String, dynamic> requestData = {
//
//     "Vehicle_No": event.vehicleNo, // Ensure it matches the DB column name
//     "Latitude_loc": event.latitude,
//     "Longtitude_loc": event.longitude,
//     "Trip_id": event.tripId,
//     "Runing_Date": DateTime.now().toIso8601String().split("T")[0],
//     "Runing_Time": DateTime.now().toLocal().toString().split(" ")[1],
//     "Trip_Status": "waypoint_Reached ",
//     "Tripstarttime": DateTime.now().toLocal().toString().split(" ")[1],
//     "TripEndTime": DateTime.now().toIso8601String(),
//     "created_at": DateTime.now().toIso8601String(),
//
//
//   };
//
//   print("📤 Sending request to API: ${AppConstants.baseUrl}/insertWayPointData");
//   print("📌 Requested Data: $requestData");
//
//   try {
//     final response = await http.post(
//       Uri.parse("${AppConstants.baseUrl}/insertReachedData"),
//       headers: {"Content-Type": "application/json"},
//       body: json.encode(requestData),
//     );
//
//     print("✅ Response Status Code: ${response.statusCode}");
//     print("✅ Response Body: ${response.body}");
//
//     if (response.statusCode == 200) {
//       emit(SaveLocationSuccess());
//       print("🎉 wap Point Reached successfully!");
//     } else {
//       print("❌ Failed to end trip. Status Code: ${response.statusCode}");
//       emit(SaveLocationFailure("Failed to end trip."));
//     }
//   } catch (e) {
//     print("🚨 Error ending trip: $e");
//     emit(SaveLocationFailure("Error ending trip: $e"));
//   }
// }

//trip tracking way point reached bloc completed (tracking, customer location reached page)





//closed trip details Reached status for current date bloc starts

class TripClosedTodayBloc extends Bloc<TripClosedTodayEvent, TripClosedTodayState> {
  final ApiService apiService;

  TripClosedTodayBloc(this.apiService) : super(TripClosedTodayInitial()) {
    on<FetchTripClosedToday>(_onFetchTripClosedToday);
  }

  Future<void> _onFetchTripClosedToday(
      FetchTripClosedToday event, Emitter<TripClosedTodayState> emit) async {
    emit(TripClosedTodayLoading());
    print('inside in the bloc');

    try {
      final trips = await apiService.fetchClosedTrips(event.username);
      emit(TripClosedTodayLoaded(trips));
      print('success in the bloc');
    } catch (e) {
      emit(TripClosedTodayError(e.toString()));
    }
  }
}

//closed trip details Reached status for current date bloc completed







//getting uploaded images bloc starts
class DocumentImagesBloc extends Bloc<DocumentImagesEvent, DocumentImagesState> {
  final ApiService apiService;

  DocumentImagesBloc({required this.apiService}) : super(DocumentImagesInitial()) {
    on<FetchBothDocumentImages>(_fetchBothImages);
  }

  Future<void> _fetchBothImages(FetchBothDocumentImages event, Emitter<DocumentImagesState> emit) async {
    emit(DocumentImagesLoading());
    try {
      final startKmImage = await apiService.fetchSingleDocumentImage(event.tripId, "StartingKm");
      final closingKmImage = await apiService.fetchSingleDocumentImage(event.tripId, "ClosingKm");
      // final TollImage = await apiService.fetchSingleDocumentImage(event.tripId, "Toll");
      // final ParkingImage = await apiService.fetchSingleDocumentImage(event.tripId, "Parking");
      final TollImage = await apiService.fetchDocumentImages(event.tripId, "Toll");
      final ParkingImage = await apiService.fetchDocumentImages(event.tripId, "Parking");

      print("🖼 Start KM Image URL: $startKmImage");
      print("🖼 Closing KM Image URL: $closingKmImage");
      print("🖼 toll KM Image URL: $TollImage");
      print("🖼 parking KM Image URL: $ParkingImage");

      emit(DocumentImagesLoaded(
        startKmImage: startKmImage != null ? "${AppConstants.baseUrl}/uploads/$startKmImage" : null,
        closingKmImage: closingKmImage != null ? "${AppConstants.baseUrl}/uploads/$closingKmImage" : null,
        // TollImage: TollImage != null ? "${AppConstants.baseUrl}/uploads/$TollImage" : null,
        // ParkingImage: ParkingImage != null ? "${AppConstants.baseUrl}/uploads/$ParkingImage" : null,
        TollImage: TollImage.map((image) => "${AppConstants.baseUrl}/uploads/$image").toList(),
        ParkingImage: ParkingImage.map((image) => "${AppConstants.baseUrl}/uploads/$image").toList(),
      ));


      // emit(DocumentImagesLoaded(startKmImage: '${AppConstants.baseUrl}/uploads/startKmImage', closingKmImage: '${AppConstants.baseUrl}/uploads/closingKmImage'));
    } catch (e) {
      print("🚨 Error in BLoC: $e");
      emit(DocumentImagesError(error: e.toString()));
    }
  }
}

//getting uploaded images bloc completed



//getting dynamic closing kilometer bloc start


class GettingClosingKilometerBloc extends Bloc<GettingClosingKilometerEvent, GettingClosingKilometerState> {
  final ApiService apiService;

  GettingClosingKilometerBloc(this.apiService) : super(ClosingKilometerLoading()) {
    on<FetchClosingKilometer>((event, emit) async {
      emit(ClosingKilometerLoading());
      try {
        final response = await apiService.getKMForParticularTrip(event.tripId);
        if (response.containsKey('error')) {
          emit(ClosingKilometerError(response['error']));
        } else {
          emit(ClosingKilometerLoaded(response));
        }
      } catch (e) {
        emit(ClosingKilometerError("Failed to fetch closing KM data"));
      }
    });
  }
}

//getting dynamic closing kilometer bloc start




class OtpBloc extends Bloc<OtpEvent, OTPState> {
  OtpBloc() : super(OTPInitial()) {
    on<OtpEvent>(_onOtpRequested);
  }

  Future<void> _onOtpRequested(OtpEvent event, Emitter<OTPState> emit) async {
    print("2 - Bloc processing event"); // Debug
    print('Bloc Received data ${event.guestEmail}');
    print('Bloc Received data ${event.guestNumber}');
    print('Bloc Received data ${event.guestName}');
    emit(OTPLoading());
    try {
      // final response = await ApiService.sendOtp(event.guestNumber, event.guestEmail);
      final response = await ApiService.sendOtp(number: event.guestNumber, email: event.guestEmail, name: event.guestName,  senderEmail: event.senderEmail,senderPass: event.senderPass,);
      ;
      if (response['otp'] != null) {
        emit(OTPSuccess(response['otp'].toString()));
      } else {
        emit(OTPFailed('OTP not found in response'));
      }
    } catch (e) {
      emit(OTPFailed(e.toString()));
    }
  }
}



class LastOtBloc extends Bloc<OtpVerifyEvent, OtpVerifyState>{
  LastOtBloc():super(LastOtpInitial()){
    on<OtpVerifyEvent>(_onFetch);
  }

  Future<void>_onFetch(OtpVerifyEvent event, Emitter<OtpVerifyState> emit) async{

    print('Bloc Received Last Otp info ${event.guestName}');
    print('Bloc Received Last Otp info ${event.guestEmail}');
    print('Bloc Received Last Otp info ${event.guestNumber}');
    emit(LastOtpLoading());

    try{
      final response = await ApiService.verifyOtp(number: event.guestNumber, email: event.guestEmail, name: event.guestName, senderEmail: event.senderEmail, senderPass: event.senderPass);
      if(response['otp'] != null){
        emit(LastOtpSuccess(response['otp'].toString()));
      } else{
        emit(LastOtpFailed('OTP not found in response'));
      }
    } catch(e){
      emit(LastOtpFailed(e.toString()));
    }
  }
}


class EmailBloc extends Bloc<EmailEvent, EmailState> {
  EmailBloc() : super(EmailInitial()) {
    on<SendEmailEvent>((event, emit) async {
      print('📨 SendEmailEvent triggered');
      emit(EmailSending());

      final success = await ApiService.sendBookingEmail(
        guestName: event.guestName,
        guestMobileNo: event.guestMobileNo,
        email: event.email,
        startKm: event.startKm,
        closeKm: event.closeKm,
        duration: event.duration,
        senderEmail: event.senderEmail,
        senderPassword: event.senderPassword,
        TripId: event.TripId,
        Vehiclenumber: event.Vechnum,
        VehicleName: event.Vechname,
        DutyType: event.dutytype,
        ReportTime: event.ReportTime,
        ReleaseTime: event.ReleaseTime,
        ReportDate: event.ReportDate,
        ReleaseDate: event.ReleaseDate,
        Startpoint: event.Startpoint,
        Endpoint: event.Endpoint,
      );

      if (success) {
        print('✅ EmailSent state emitted');
        emit(EmailSent());
      } else {
        print('❌ EmailFailed state emitted');
        emit(EmailFailed());
      }
    });
  }
}





class SenderInfoBloc extends Bloc<SenderInfoEvent, SenderInfoState> {
  SenderInfoBloc() : super(SenderInfoIntial()) {
    on<FetchSenderInfo>(_onFetchSenderInformation);
  }

  Future<void> _onFetchSenderInformation(
      FetchSenderInfo event, Emitter<SenderInfoState> emit) async {

    print('SenderInfo Bloc Screen');
    emit(SenderInfoLoading());

    try {
      final response = await ApiService.fetchSenderInfo();

      print('response from origi${response}');

      if (response['success']) {
        emit(SenderInfoSuccess(
          senderMail: response['senderEmail'],
          senderPass: response['senderPass'],
        ));
      } else {
        emit(SenderInfoFailed(response['message']));
      }
    } catch (e) {
      emit(SenderInfoFailed("Exception: $e"));
    }
  }

}




// For new sign up page created at 09-06-20225



class GetDurationBloc extends Bloc<GetDurationEvent, GetDurationState> {
  GetDurationBloc() : super(GetDurationInitial()) {
    on<FetchDuration>(_onFetchDuration);
  }

  Future<void> _onFetchDuration(
      FetchDuration event, Emitter<GetDurationState> emit) async {
    emit(GetDurationLoading());

    print('bloc screen got tripId for duration time ${event.tripId}');
    try {
      final response = await ApiService.fetchDistance(tripId: event.tripId);

      if (response['success'] == true) {
        print('response from api service ${response}');
        emit(GetDurationSuccess(data: response['duration']));
      } else {
        print('error response from api service ${response}');
        emit(GetDurationFailed(response['message']));
      }
    } catch (e) {
      print('error response from api service');
      emit(GetDurationFailed("Error is ${e}"));
    }
  }
}




class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignUpInitial()) {
    on<SignupRequested>(_onSignupAttepmt);
    on<OtpverificationRequested>(_onSignupAttepmtTwo);
  }
}

void _onSignupAttepmt(SignupRequested event, Emitter<SignupState> emit) async {
  print('first step values received in bloc ${event.email}');
  print('first step values received in bloc ${event.name}');
  print('first step values received in bloc ${event.phone}');

  emit(SignUpLoading());
  try {
    final response = await ApiService.signUpStepOne(
        name: event.name, email: event.email, phone: event.phone);

    print('first step response from Api_Service ${response}');

    if (response['success'] == true) {
      final otp = response['otp']?.toString() ?? '';
      final userId = response['userId']?.toString() ?? '';
      emit(OtpSentForSignup(userId: userId, otp: otp));
    } else if (response['success'] == false) {
      emit(SignUpFailed("User Already Exists"));
    } else {
      emit(SignUpFailed("Unexpected response: ${response['status']}"));
    }
  } catch (e) {
    emit(SignUpFailed('SignUp Failed ${e}'));
  }
}

void _onSignupAttepmtTwo(
    OtpverificationRequested event, Emitter<SignupState> emit) async {
  print('second step values received in bloc ${event.phone}');

  emit(SignUpLoading());
  try {
    final response = await ApiService.signUpStepTwo(phone: event.phone);

    print('second step response from Api_Service ${response}');

    if (response['success'] == true) {
      final otp = response['otp']?.toString() ?? '';
      emit(SignUpSuccess(otp: otp));
    } else if (response['success'] == false) {
      emit(SignUpFailed("OTP failed"));
    } else {
      emit(SignUpFailed("Unexpected response: ${response['status']}"));
    }
  } catch (e) {
    emit(SignUpFailed('OTP Failed ${e}'));
  }
}

// For new Login VIA number page created at 11-06-20225

class LoginViaBloc extends Bloc<LoginViaEvent, LoginViaState> {
  LoginViaBloc() : super(LoginViaInitial()) {
    on<LoginRequested>(_onLoginViaAttepmt);
    on<LoginViaOtpverificationRequested>(_onLoginViaAttepmtTwo);
  }
}

void _onLoginViaAttepmt(
    LoginRequested event, Emitter<LoginViaState> emit) async {
  print('third step values received in bloc ${event.phone}');

  emit(LoginViaLoading());
  try {
    final response = await ApiService.loginViaStepOne(phone: event.phone);

    print('third step response from Api_Service ${response}');

    if (response['success'] == true) {
      final otp = response['otp']?.toString() ?? '';
      final name= response['username']?.toString() ?? '';
      emit(LoginViaOtpSentForSignup(otp: otp, name: name));
    } else if (response['success'] == false) {
      print('failed work just now check');
      emit(LoginViaFailed("Invalid User"));
    } else {
      emit(LoginViaFailed("Unexpected response: ${response['status']}"));
    }
  } catch (e) {
    emit(LoginViaFailed('SignUp Failed ${e}'));
  }
}

void _onLoginViaAttepmtTwo(
    LoginViaOtpverificationRequested event, Emitter<LoginViaState> emit) async {
  print('fourth step values received in bloc ${event.phone}');

  emit(LoginViaInitial());
  try {
    final response = await ApiService.LoginViaStepTwo(phone: event.phone);

    print('fourth step response from Api_Service ${response}');

    if (response['success'] == true) {
      final otp = response['otp']?.toString() ?? '';
      emit(LoginViaSuccess(otp: otp));
    } else if (response['success'] == false) {
      emit(LoginViaFailed("OTP failed"));
    } else {
      emit(LoginViaFailed("Unexpected response: ${response['status']}"));
    }
  } catch (e) {
    emit(LoginViaFailed('OTP Failed ${e}'));
  }
}

// At the bottom of App_Bloc.dart for user login in no logout

//\
class GetOkayBloc extends Bloc<GetOkayEvent, GetOkayState>{
  GetOkayBloc():super(GetOkayInitial()){
    on<FetchOkaymessage>(_onFetchOkayMessage);
  }

  Future<void>_onFetchOkayMessage(FetchOkaymessage event, Emitter <GetOkayState> emit) async{
    print('trip id received in bloc screen for okay message ${event.trip_id}');

    emit(GetOkayLoading());
    try{
      final response = await ApiService.fetchOkayMessage(trip_id: event.trip_id);

      print('response in bloc screen from api service for okay message ${response}');

      if(response['success'] == true){
        print('response from api service for okay message ${response}');
        emit(GetOkaySuccess(data: response['information']));
      } else {
        print('error response from api service for okay message${response}');
        emit(GetOkayFailed("Fetching Data Failed"));
      }
    } catch(e){
      print('error response from api service for okay message');
      emit(GetOkayFailed("Error is ${e}"));
    }
  }
}
//
