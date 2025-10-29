import '../entities/professional.dart';
import '../repositories/i_professional_repository.dart';

class GetProfessionalsUseCase {
  final IProfessionalRepository repository;

  GetProfessionalsUseCase(this.repository);

  Future<List<Professional>> execute(
    String branchId,
    String branchIdcuenta,
    String username,
  ) async {
    if (branchId.isEmpty) {
      throw Exception('El ID de sucursal es requerido');
    }

    return await repository.getProfessionals(
      branchId,
      branchIdcuenta,
      username,
    );
  }
}
