import '../entities/professional.dart';

abstract class IProfessionalRepository {
  Future<List<Professional>> getProfessionals(
    String branchId,
    String branchIdcuenta,
    String username,
  );
}
