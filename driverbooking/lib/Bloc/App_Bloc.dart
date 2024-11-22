import 'package:bloc/bloc.dart';

import 'package:driverbooking/Bloc/AppBloc_Events.dart';
import 'package:driverbooking/Bloc/AppBloc_State.dart';
import '../Networks/Api_Service.dart';
import 'dart:math';
import 'dart:convert';


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

//
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
          print("OTP successfully sentttttttttttttttttttttttttttttttttttttttt.");

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
          print("fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff.");
          emit(RequestOtpFailure("Failed to send OTP. Username or email might already be taken."));
        }
      } catch (error) {
        emit(RegisterFailure("An error occurred during registration: $error"));
      }
    });
  }
}
