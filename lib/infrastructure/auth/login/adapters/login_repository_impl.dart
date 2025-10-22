import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../domain/auth/login/entities/user.dart';
import '../../../../domain/auth/login/repositories/i_login_repository.dart';
import '../models/login_response_dto.dart';

class LoginRepositoryImpl implements ILoginRepository {
  final _storage = SecureStorageService();

  @override
  Future<void> sendVerificationCode(String email, String type) async {
    try {
      developer.log('Enviando código de verificación', name: 'LoginRepository');
      developer.log('Email: $email', name: 'LoginRepository');
      developer.log('Type: $type', name: 'LoginRepository');

      final url = Uri.parse('${ApiConfig.baseUrl}/api/auth/signin-email-code/$type');
      
      final response = await http.post(
        url,
        headers: ApiConfig.headers,
        body: json.encode({'email': email}),
      ).timeout(ApiConfig.timeout);

      developer.log('Status code: ${response.statusCode}', name: 'LoginRepository');

      if (response.statusCode == 200 || response.statusCode == 201) {
        developer.log('Código enviado exitosamente', name: 'LoginRepository');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Error al enviar el código');
      }
    } catch (e) {
      developer.log('Error al enviar código: $e', name: 'LoginRepository', error: e);
      throw Exception('Error al enviar el código: $e');
    }
  }

  @override
  Future<User> verifyCode(String email, String code, String type) async {
    try {
      developer.log('Verificando código', name: 'LoginRepository');
      developer.log('Email: $email', name: 'LoginRepository');
      developer.log('Código: $code', name: 'LoginRepository');
      developer.log('Type: $type', name: 'LoginRepository');

      final url = Uri.parse('${ApiConfig.baseUrl}/api/auth/signin-verification-code/$type');
      
      final response = await http.post(
        url,
        headers: ApiConfig.headers,
        body: json.encode({
          'email': email,
          'code': code,
        }),
      ).timeout(ApiConfig.timeout);

      developer.log('Status code: ${response.statusCode}', name: 'LoginRepository');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final responseDto = LoginResponseDto.fromJson(responseData);

        final tokenPayload = Jwt.parseJwt(responseDto.token);
        developer.log('Token decodificado: $tokenPayload', name: 'LoginRepository');

        final user = User.fromTokenPayload(tokenPayload, responseDto.token);

        await _storage.saveToken(responseDto.token);
        
        final userDataJson = json.encode(tokenPayload);
        await _storage.write(key: 'fliiper', value: userDataJson);

        developer.log('Login exitoso', name: 'LoginRepository');
        developer.log('Usuario: ${user.username}', name: 'LoginRepository');
        developer.log('Token y datos guardados bajo llave "fliiper"', name: 'LoginRepository');

        return user;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Código inválido');
      }
    } catch (e) {
      developer.log('Error en verificación: $e', name: 'LoginRepository', error: e);
      throw Exception('Error al verificar el código: $e');
    }
  }

  @override
  Future<void> logout() async {
    developer.log('Cerrando sesión', name: 'LoginRepository');
    await Future.delayed(const Duration(milliseconds: 500));
    developer.log('Sesión cerrada exitosamente', name: 'LoginRepository');
  }

  @override
  Future<User?> getCurrentUser() async {
    developer.log('Obteniendo usuario actual', name: 'LoginRepository');
    return null;
  }
}
