abstract class LoginEvent{}


class LoginAtempt extends LoginEvent{
  final String username;
  final String password;
  LoginAtempt({required this.username, required this.password});
}

abstract class RegisterEvent{}

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