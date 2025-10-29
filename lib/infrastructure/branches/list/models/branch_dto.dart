import '../../../../domain/branches/list/entities/branch.dart';

class BranchDto {
  final String id;
  final String nombre;
  final String direccion;
  final String horario;
  final String idcuenta;

  BranchDto({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.horario,
    required this.idcuenta,
  });

  factory BranchDto.fromJson(Map<String, dynamic> json) {
    return BranchDto(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre'] as String? ?? '',
      direccion: json['direccion'] as String? ?? '',
      horario: json['horario'] as String? ?? 'Lunes a Viernes',
      idcuenta: json['idCuenta'] as String? ?? json['idcuenta'] as String? ?? '',
    );
  }

  Branch toDomain() {
    return Branch(
      id: id,
      name: nombre,
      address: direccion,
      schedule: horario,
      idcuenta: idcuenta,
    );
  }
}
