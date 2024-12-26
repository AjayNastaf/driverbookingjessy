import 'dart:io';



abstract class LoginEvent {}

class LoginAtempt extends LoginEvent {
  final String username;
  final String password;
  LoginAtempt({required this.username, required this.password});
}

abstract class RegisterEvent {}

class RequestOtpAndRegister extends RegisterEvent {
  final String username;
  final String password;
  final String email;
  final String phone;

  RequestOtpAndRegister({
    required this.username,
    required this.password,
    required this.email,
    required this.phone,
  });
}

abstract class UpdateUserEvent {}

class UpdateUserAttempt extends UpdateUserEvent {
  final String userId;
  final String username;
  final String password;
  final String email;
  final String phone;

  UpdateUserAttempt({
    required this.userId,
    required this.username,
    required this.password,
    required this.email,
    required this.phone,
  });
}

abstract class CheckCurrentPasswordEvent {}

class CheckCurrentPasswordAttempt extends CheckCurrentPasswordEvent {
  final String userId;
  final String password;

  CheckCurrentPasswordAttempt({
    required this.userId,
    required this.password
  });
}


abstract class UpdatePasswordEvent {}

class UpdatePasswordAttempt extends UpdatePasswordEvent {
  final String userId;
  final String newPassword;

  UpdatePasswordAttempt({
    required this.userId,
    required this.newPassword
  });
}

abstract class ForgotPasswordEmailVerificationEvent {}

class ForgotPasswordEmailVerificationAttempt extends ForgotPasswordEmailVerificationEvent {
  final String email;

  ForgotPasswordEmailVerificationAttempt({
    required this.email,
  });
}


abstract class CheckForgotPasswordOtpEvent {}

class CheckForgotPasswordOtpAttempt extends CheckForgotPasswordOtpEvent {
  final String email;
  final String otp;

  CheckForgotPasswordOtpAttempt({
    required this.email,
    required this.otp
  });
}


abstract class ChangePasswordForgotEvent {}

class ChangePasswordForgotAttempt extends ChangePasswordForgotEvent {
  final String userId;
  final String newPassword;

  ChangePasswordForgotAttempt({
    required this.userId,
    required this.newPassword
  });
}


abstract class CustomerOtpVerifyEvent {}

class OtpVerifyAttempt extends CustomerOtpVerifyEvent{
  final String otp;
  OtpVerifyAttempt({
    required this.otp
});
}



abstract class TripDetailsUploadEvent {}

class SelectStartKmImageAttempt extends TripDetailsUploadEvent {
  final int buttonId;
  final File image;

  SelectStartKmImageAttempt({required this.buttonId, required this.image});
}

class UploadStartKmImageEvent extends TripDetailsUploadEvent {
  final File image;

  UploadStartKmImageEvent({required this.image});
}

class SelectCloseKmImageAttempt extends TripDetailsUploadEvent {
  final int buttonId;
  final File image;

  SelectCloseKmImageAttempt({required this.buttonId, required this.image});
}

class UploadCloseKmImageEvent extends TripDetailsUploadEvent {
  final File image;

  UploadCloseKmImageEvent({required this.image});
}


