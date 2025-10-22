class User {
  final String id;
  final String email;
  final String username;
  final String roles;
  final int idroles;
  final String idcuenta;
  final String subdomain;
  final String idSession;
  final String? token;
  final bool accountType;
  final bool isNotary;
  final String moneda;
  final String zonahoraria;
  final String? idsucursal;
  final String idasociado;
  final String semilla;
  final bool hasDiscountsEnabled;
  final bool hasCalendarEnabled;
  final bool hasReceptionPurchaseEnabled;
  final bool hasPv;
  final bool hasDevoluciones;
  final bool hasCancelarComandas;
  final bool hasPvAdmin;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.roles,
    required this.idroles,
    required this.idcuenta,
    required this.subdomain,
    required this.idSession,
    this.token,
    required this.accountType,
    required this.isNotary,
    required this.moneda,
    required this.zonahoraria,
    this.idsucursal,
    required this.idasociado,
    required this.semilla,
    required this.hasDiscountsEnabled,
    required this.hasCalendarEnabled,
    required this.hasReceptionPurchaseEnabled,
    required this.hasPv,
    required this.hasDevoluciones,
    required this.hasCancelarComandas,
    required this.hasPvAdmin,
  });

  factory User.fromTokenPayload(Map<String, dynamic> payload, String token) {
    return User(
      id: payload['id'] as String,
      email: payload['email'] as String,
      username: payload['username'] as String,
      roles: payload['roles'] as String,
      idroles: payload['idroles'] as int,
      idcuenta: payload['idcuenta'] as String,
      subdomain: payload['subdomain'] as String,
      idSession: payload['idSession'] as String,
      token: token,
      accountType: payload['accountType'] as bool,
      isNotary: payload['isNotary'] as bool,
      moneda: payload['moneda'] as String,
      zonahoraria: payload['zonahoraria'] as String,
      idsucursal: payload['idsucursal'] as String?,
      idasociado: payload['idasociado'] as String? ?? '',
      semilla: payload['semilla'] as String,
      hasDiscountsEnabled: payload['hasDiscountsEnabled'] as bool,
      hasCalendarEnabled: payload['hasCalendarEnabled'] as bool,
      hasReceptionPurchaseEnabled: payload['hasReceptionPurchaseEnabled'] as bool,
      hasPv: payload['hasPv'] as bool,
      hasDevoluciones: payload['hasDevoluciones'] as bool,
      hasCancelarComandas: payload['hasCancelarComandas'] as bool,
      hasPvAdmin: payload['hasPvAdmin'] as bool,
    );
  }
}
