import '../entities/user.dart';
import '../repositories/i_login_repository.dart';

class VerifyCodeUseCase {
  final ILoginRepository repository;

  VerifyCodeUseCase(this.repository);

  Future<User> execute(String email, String code, String type) async {
    if (email.isEmpty) {
      throw Exception('El correo electrónico es requerido');
    }

    if (!email.contains('@')) {
      throw Exception('El correo electrónico no es válido');
    }

    if (code.isEmpty) {
      throw Exception('El código es requerido');
    }

    if (code.length != 6) {
      throw Exception('El código debe tener 6 caracteres');
    }

    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(code)) {
      throw Exception('El código solo debe contener letras y números');
    }

    if (type.isEmpty) {
      throw Exception('El tipo de usuario es requerido');
    }

    return await repository.verifyCode(email, code, type);
  }
}
