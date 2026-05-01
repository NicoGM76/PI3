// lib/models/user_model.dart
//
// Modelo que refleja la respuesta del backend para un usuario.
// Ajusta los campos según el contrato de tu API.

class UserModel {
  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.token,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? token; // JWT devuelto al registrarse / iniciar sesión

  // ─── Deserialización desde la respuesta JSON del backend ──────────
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:        json['id']         as String,
      firstName: json['firstName']  as String,
      lastName:  json['lastName']   as String,
      email:     json['email']      as String,
      token:     json['token']      as String?,
    );
  }

  // ─── Serialización para enviar al backend ─────────────────────────
  Map<String, dynamic> toJson() => {
        'id':        id,
        'firstName': firstName,
        'lastName':  lastName,
        'email':     email,
      };

  @override
  String toString() =>
      'UserModel(id: $id, name: $firstName $lastName, email: $email)';
}