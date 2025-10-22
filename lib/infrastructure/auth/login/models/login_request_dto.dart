class LoginRequestDto {
  final String email;
  final String code;

  LoginRequestDto({
    required this.email,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'code': code,
    };
  }
}
