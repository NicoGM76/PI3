// lib/model/profile_model.dart

class ProfileModel {
  const ProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.role,
    this.empresa,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? role;
  final String? empresa;

  String get fullName {
    final name = '$firstName $lastName'.trim();
    return name.isNotEmpty ? name : email;
  }

  String get initials {
    final first = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    final value = '$first$last';

    if (value.isNotEmpty) return value;
    if (email.isNotEmpty) return email[0].toUpperCase();

    return 'U';
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final rawName = (json['nombre'] ?? json['name'] ?? '').toString().trim();
    final parts = rawName.isEmpty ? <String>[] : rawName.split(RegExp(r'\s+'));

    final idRolRaw = json['id_rol'];
    final idRol = idRolRaw is int ? idRolRaw : int.tryParse('$idRolRaw');

    return ProfileModel(
      id: (json['id_usuario'] ?? json['id'] ?? '').toString(),
      firstName: parts.isNotEmpty
          ? parts.first
          : (json['firstName'] ?? '').toString(),
      lastName: parts.length > 1
          ? parts.sublist(1).join(' ')
          : (json['lastName'] ?? '').toString(),
      email: (json['correo'] ?? json['email'] ?? '').toString(),
      phone: (json['telefono'] ?? json['phone'] ?? '').toString(),
      role: (json['role'] ?? _roleFromId(idRol) ?? '').toString(),
      empresa: (json['empresa'] ?? json['finca'] ?? 'AgroTrace').toString(),
    );
  }

  static String? _roleFromId(int? idRol) {
    return switch (idRol) {
      1 => 'Administrador',
      2 => 'Operario',
      3 => 'Supervisor',
      _ => null,
    };
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'role': role,
        'empresa': empresa,
      };

  ProfileModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? role,
    String? empresa,
  }) {
    return ProfileModel(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      empresa: empresa ?? this.empresa,
    );
  }
}