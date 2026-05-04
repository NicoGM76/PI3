// lib/model/user_model.dart

class UserModel {
  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.token,
    this.estado,
    this.idRol,
    this.fechaCreacion,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? token;
  final String? estado;
  final int? idRol;
  final String? fechaCreacion;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rawNombre = (json['nombre'] ?? json['firstName'] ?? '').toString();
    final partesNombre = rawNombre.trim().split(RegExp(r'\s+'));

    final firstName = partesNombre.isNotEmpty && partesNombre.first.isNotEmpty
        ? partesNombre.first
        : rawNombre;

    final lastName = partesNombre.length > 1
        ? partesNombre.sublist(1).join(' ')
        : (json['lastName'] ?? '').toString();

    return UserModel(
      id: (json['id_usuario'] ?? json['id'] ?? '').toString(),
      firstName: firstName,
      lastName: lastName,
      email: (json['correo'] ?? json['email'] ?? '').toString(),
      token: (json['access_token'] ?? json['token']) as String?,
      estado: json['estado']?.toString(),
      idRol: json['id_rol'] is int
          ? json['id_rol'] as int
          : int.tryParse((json['id_rol'] ?? '').toString()),
      fechaCreacion: json['fecha_creacion']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'token': token,
        'estado': estado,
        'id_rol': idRol,
        'fecha_creacion': fechaCreacion,
      };
}