abstract class LoginState{}

class LoginInitial extends LoginState{}

class LoginLoading extends LoginState{}

class LoginCompleted extends LoginState{
  final String userId;
  LoginCompleted(this.userId);
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}



abstract class RegisterState{}


class RegisterInitial extends RegisterState{}
class RegisterLoading extends RegisterState{}

class RegisterSuccess extends RegisterState{
  // final String message;
  // RegisterSuccess(this.message);
}


class RegisterFailure extends RegisterState{
  final String error;
  RegisterFailure(this.error);
}


class RequestOtpSuccess extends RegisterState{
  final String otp;
  RequestOtpSuccess(this.otp);
}


class RequestOtpFailure extends RegisterState{
  final String error;
  RequestOtpFailure(this.error);
}



abstract class UpdateUserState{}

class UpdateUserInitial extends UpdateUserState{}

class UpdateUserLoading extends UpdateUserState{}

class UpdateUserCompleted extends UpdateUserState{

}

class UpdateUserFailure extends UpdateUserState {
  final String error;
  UpdateUserFailure(this.error);
}




abstract class CheckCurrentPasswordState{}

class CheckCurrentPasswordInitial extends CheckCurrentPasswordState{}

class CheckCurrentPasswordLoading extends CheckCurrentPasswordState{}

class CheckCurrentPasswordCompleted extends CheckCurrentPasswordState{

}

class CheckCurrentPasswordFailure extends CheckCurrentPasswordState {
  final String error;
  CheckCurrentPasswordFailure(this.error);
}


abstract class UpdatePasswordState{}

class UpdatePasswordInitial extends UpdatePasswordState{}

class UpdatePasswordLoading extends UpdatePasswordState{}

class UpdatePasswordCompleted extends UpdatePasswordState{

}

class UpdatePasswordFailure extends UpdatePasswordState {
  final String error;
  UpdatePasswordFailure(this.error);
}


abstract class ForgotPasswordEmailVerificationState{}

class ForgotPasswordEmailVerificationInitial extends ForgotPasswordEmailVerificationState{}

class ForgotPasswordEmailVerificationLoading extends ForgotPasswordEmailVerificationState{}

class ForgotPasswordEmailVerificationCompleted extends ForgotPasswordEmailVerificationState{
  final String userId;
  ForgotPasswordEmailVerificationCompleted(this.userId);
}

class ForgotPasswordEmailVerificationFailure extends ForgotPasswordEmailVerificationState {
  final String error;
  ForgotPasswordEmailVerificationFailure(this.error);
}


abstract class CheckForgotPasswordOtpState{}

class CheckForgotPasswordOtpInitial extends CheckForgotPasswordOtpState{}

class CheckForgotPasswordOtpLoading extends CheckForgotPasswordOtpState{}

class CheckForgotPasswordOtpCompleted extends CheckForgotPasswordOtpState{

}

class CheckForgotPasswordOtpFailure extends CheckForgotPasswordOtpState {
  final String error;
  CheckForgotPasswordOtpFailure(this.error);
}

abstract class ChangePasswordForgotState{}

class ChangePasswordForgotInitial extends ChangePasswordForgotState{}

class ChangePasswordForgotLoading extends ChangePasswordForgotState{}

class ChangePasswordForgotCompleted extends ChangePasswordForgotState{

}

class ChangePasswordForgotFailure extends ChangePasswordForgotState {
  final String error;
  ChangePasswordForgotFailure(this.error);
}




abstract class CustomerOtpVerifyState{}

class OtpVerifyStarts extends CustomerOtpVerifyState{}
class OtpVerifyLoading extends CustomerOtpVerifyState{}
class OtpVerifyCompleted extends CustomerOtpVerifyState{

  final String otp;
  OtpVerifyCompleted(this .otp);
}
class OtpVerifyFailed extends CustomerOtpVerifyState{
  final String error;
  OtpVerifyFailed(this.error);

}

abstract class TripDetailsUploadState {}

class StartKmUploadInitial extends TripDetailsUploadState {}

class StartKmImageSelected extends TripDetailsUploadState {}

class StartKmUploadInProgress extends TripDetailsUploadState {}

class StartKmUploadComplete extends TripDetailsUploadState {
  final String message;

  StartKmUploadComplete({required this.message});
}

class StartKmUploadFailure extends TripDetailsUploadState {
  final String message;

  StartKmUploadFailure({required this.message});
}

class CloseKmUploadInitial extends TripDetailsUploadState {}

class CloseKmImageSelected extends TripDetailsUploadState {}

class CloseKmUploadInProgress extends TripDetailsUploadState {}

class CloseKmUploadComplete extends TripDetailsUploadState {
  final String message;

  CloseKmUploadComplete({required this.message});
}

class CloseKmUploadFailure extends TripDetailsUploadState {
  final String message;

  CloseKmUploadFailure({required this.message});
}
