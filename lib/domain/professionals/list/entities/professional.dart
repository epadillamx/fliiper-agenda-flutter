class Professional {
  final String id;
  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String email;
  final String? especialidad;
  final String? descripcion;
  final String? foto;
  final String? telefono;
  final String? rut;

  Professional({
    required this.id,
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.email,
    this.especialidad,
    this.descripcion,
    this.foto,
    this.telefono,
    this.rut,
  });

  String get fullName => '$nombre $apellidoPaterno $apellidoMaterno'.trim();
  
  String get displayName => fullName.isNotEmpty ? fullName : 'Profesional';
  
  String get displaySpecialty => especialidad ?? 'Especialista';
  
  String get displayDescription => descripcion ?? 'Profesional de la salud';
  
  String get displayPhoto => foto ?? 'https://i.pravatar.cc/300?u=$id';
}
