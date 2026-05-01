// lib/controllers/auth/auth_repository.dart
//
// Capa de repositorio: abstrae la fuente de datos (API REST)
// del controlador. Si en el futuro cambias de API a Firebase,
// solo tocas este archivo.

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../model/register_request.dart';
import '../../model/user_model.dart';

class AuthRepository {
  AuthRepository({ApiClient? client})
      : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  // ─── Registro ─────────────────────────────────────────────────────
  /// Envía los datos de registro al backend.
  /// Retorna el [UserModel] con el token JWT si el servidor lo incluye.
  Future<UserModel> register(RegisterRequest request) async {
    try {
      final response = await _client.dio.post(
        'auth/register',
        data: request.toJson(),
      );

      final user = UserModel.fromJson(
          response.data as Map<String, dynamic>);

      if (user.token != null) {
        _client.setAuthToken(user.token!);
      }

      return user;
    } on DioException catch (e) {
      _handleDioError(e);
    }
    // Nunca se alcanza — _handleDioError siempre lanza
    throw const ApiException(message: 'Error desconocido');
  }

  // ─── Login (placeholder para la siguiente pantalla) ───────────────
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.dio.post(
        'auth/login',
        data: {'email': email, 'password': password},
      );

      final user = UserModel.fromJson(
          response.data as Map<String, dynamic>);

      if (user.token != null) {
        _client.setAuthToken(user.token!);
      }

      return user;
    } on DioException catch (e) {
      _handleDioError(e);
    }
    throw const ApiException(message: 'Error desconocido');
  }

  // ─── Manejo de errores Dio → ApiException ─────────────────────────
  Never _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final serverMsg  = e.response?.data?['message'] as String?;

    throw ApiException(
      message:    serverMsg ?? _defaultMessage(statusCode),
      statusCode: statusCode,
    );
  }

  String _defaultMessage(int? code) => switch (code) {
        400 => 'Datos inválidos. Revisa el formulario.',
        409 => 'Este correo ya está registrado.',
        500 => 'Error del servidor. Intenta más tarde.',
        _   => 'Ocurrió un error. Intenta de nuevo.',
      };
}