import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();
  
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }
  
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }
  
  Future<void> saveUserData({
    required String userId,
    required String email,
    required String name,
  }) async {
    await _storage.write(key: _userIdKey, value: userId);
    await _storage.write(key: _userEmailKey, value: email);
    await _storage.write(key: _userNameKey, value: name);
  }
  
  Future<Map<String, String?>> getUserData() async {
    return {
      'userId': await _storage.read(key: _userIdKey),
      'email': await _storage.read(key: _userEmailKey),
      'name': await _storage.read(key: _userNameKey),
    };
  }
  
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
  
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
  
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }
  
  Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }
}
