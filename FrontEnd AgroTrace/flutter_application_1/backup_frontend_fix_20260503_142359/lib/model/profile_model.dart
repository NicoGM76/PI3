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
    this.avatarUrl,
  });

  final String  id;
  final String  firstName;
  final String  lastName;
  final String  email;
  final String? phone;
  final String? role;
  final String? empresa;
  final String? avatarUrl;

  String get fullName => '$firstName $lastName';

  String get initials {
    final f = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final l = lastName.isNotEmpty  ? lastName[0].toUpperCase()  : '';
    return '$f$l';
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id:         json['id']        as String,
      firstName:  json['firstName'] as String,
      lastName:   json['lastName']  as String,
      email:      json['email']     as String,
      phone:      json['phone']     as String?,
      role:       json['role']      as String?,
      empresa:    json['empresa']   as String?,
      avatarUrl:  json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName':  lastName,
        'email':     email,
        'phone':     phone,
        'role':      role,
        'empresa':   empresa,
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
      id:        id,
      firstName: firstName ?? this.firstName,
      lastName:  lastName  ?? this.lastName,
      email:     email     ?? this.email,
      phone:     phone     ?? this.phone,
      role:      role      ?? this.role,
      empresa:   empresa   ?? this.empresa,
      avatarUrl: avatarUrl,
    );
  }
}