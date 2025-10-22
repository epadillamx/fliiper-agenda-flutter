import '../repositories/i_login_repository.dart';

class SendCodeUseCase {
  final ILoginRepository repository;

  SendCodeUseCase(this.repository);

  Future<void> execute(String email, String type) async {
    if (email.isEmpty) {
      throw Exception('El correo electrónico es requerido');
    }

    if (!email.contains('@')) {
      throw Exception('El correo electrónico no es válido');
    }

    if (type.isEmpty) {
      throw Exception('El tipo de usuario es requerido');
    }

    await repository.sendVerificationCode(email, type);
  }
}
