import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driverbooking/Bloc/AppBloc_Events.dart';
import 'package:driverbooking/Bloc/AppBloc_State.dart';
import '../Networks/Api_Service.dart';
import 'dart:math';
import 'dart:convert';
import 'dart:io';  // Add this import to access the 'File' class.


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
      final data = jsonDecode(response.body);
      final id = data['userId'];
      print("idddddddddddddddddddddddddddddddd: $id");
      emit(LoginCompleted('$id'));
    } else {
      emit(LoginFailure("Login failed, please check your credentials."));
    }
  } catch (e) {
    emit(LoginFailure("An error occurred: $e"));
  }
}


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








class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RequestOtpAndRegister>((event, emit) async {
      emit(RegisterLoading());

      // Step 1: Generate OTP
      final random = Random();
      final otp = (1000 + random.nextInt(9000)).toString();
      print("Generated OTP: $otp");

      // Step 2: Send OTP to User's Email
      try {
        final sendOtpEmailResult = await ApiService.sendOtpEmail(
          otp,
          event.email,
          event.username,
        );

        if (sendOtpEmailResult) {
          print("OTP successfully sent.");

          // Step 3: Proceed with Registration if OTP Sending Succeeds
          final success = await ApiService.registers(
            // context: context,
            username: event.username,
            password: event.password,
            phonenumber: event.phone,
            email: event.email,
            otp: otp,
          );

          if (success) {
            emit(RegisterSuccess());
          } else {
            emit(RegisterFailure("Registration failed."));
          }
        } else {
          emit(RequestOtpFailure(
              "Failed to send OTP. Username or email might already be taken."));
        }
      } catch (error) {
        emit(RegisterFailure("An error occurred during registration: $error"));
      }
    });
  }
}

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

