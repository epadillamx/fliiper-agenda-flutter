import '../entities/branch.dart';
import '../repositories/i_branch_repository.dart';

class GetBranchesUseCase {
  final IBranchRepository repository;

  GetBranchesUseCase(this.repository);

  Future<List<Branch>> execute(String? idcuenta, String email) async {
    if (email.isEmpty) {
      throw Exception('El email es requerido');
    }

    return await repository.getBranches(idcuenta, email);
  }
}
