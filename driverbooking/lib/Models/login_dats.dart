class UserInfo {
  final String email;
  final String phone;
  final String password;

  UserInfo({
    required this.email,
    required this.phone,
    required this.password,
  });

  factory UserInfo.fromJson(Map<String, dynamic> Json) {
    return UserInfo(
        email: Json["email"], phone: Json["phone"], password: Json["password"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "phone": phone,
      "password": password,
    };
  }
}
