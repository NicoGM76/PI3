// lib/models/register_request.dart
//
// DTO (Data Transfer Object) que se serializa y se envía
// al endpoint POST /auth/register del backend.

class RegisterRequest {
  const RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName':  lastName,
        'email':     email,
        'password':  password,
      };
}