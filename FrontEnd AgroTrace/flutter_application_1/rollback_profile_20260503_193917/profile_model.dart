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
    final value = '$firstName $lastName'.trim();
    return value.isNotEmpty ? value : email;
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
      firstName: parts.isNotEmpty ? parts.first : '',
      lastName: parts.length > 1 ? parts.sublist(1).join(' ') : '',
      email: (json['correo'] ?? json['email'] ?? '').toString(),
      phone: (json['telefono'] ?? json['phone'] ?? '').toString(),
      role: _roleFromId(idRol),
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