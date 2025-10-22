import '../entities/user.dart';

abstract class ILoginRepository {
  Future<void> sendVerificationCode(String email, String type);
  Future<User> verifyCode(String email, String code, String type);
  Future<void> logout();
  Future<User?> getCurrentUser();
}
