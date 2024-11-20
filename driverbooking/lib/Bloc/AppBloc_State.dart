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


