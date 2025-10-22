class ApiConfig {
  static const String baseUrl = 'https://qa-back.apilynk.com';
  
  static const Duration timeout = Duration(seconds: 30);
  
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  static Map<String, String> headersWithToken(String token) => {
    ...headers,
    'Authorization': 'Bearer $token',
  };
}
