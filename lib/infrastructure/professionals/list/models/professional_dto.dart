import '../../../../domain/professionals/list/entities/professional.dart';

class ProfessionalDto {
  final String id;
  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String email;
  final String? especialidad;
  final String? descripcion;
  final String? foto;

  ProfessionalDto({
    required this.id,
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.email,
    this.especialidad,
    this.descripcion,
    this.foto,
  });

  factory ProfessionalDto.fromJson(Map<String, dynamic> json) {
    return ProfessionalDto(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre'] as String? ?? '',
      apellidoPaterno: json['apellido_paterno'] as String? ?? json['apellidoPat'] as String? ?? '',
      apellidoMaterno: json['apellido_materno'] as String? ?? json['apellidoMat'] as String? ?? '',
      email: json['email'] as String? ?? '',
      especialidad: json['especialidad'] as String?,
      descripcion: json['descripcion'] as String?,
      foto: json['foto'] as String?,
    );
  }

  Professional toDomain() {
    return Professional(
      id: id,
      nombre: nombre,
      apellidoPaterno: apellidoPaterno,
      apellidoMaterno: apellidoMaterno,
      email: email,
      especialidad: especialidad,
      descripcion: descripcion,
      foto: foto,
    );
  }
}
