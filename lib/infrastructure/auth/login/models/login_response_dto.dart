class LoginResponseDto {
  final String token;
  final String idsession;

  LoginResponseDto({
    required this.token,
    required this.idsession,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      token: json['token'] as String,
      idsession: json['idsession'] as String,
    );
  }
}
