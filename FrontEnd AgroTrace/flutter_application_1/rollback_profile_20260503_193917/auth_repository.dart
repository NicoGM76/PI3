// lib/controller/auth/auth_repository.dart

import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../core/session/auth_session.dart';
import '../../model/register_request.dart';
import '../../model/user_model.dart';

class AuthRepository {
  AuthRepository({ApiClient? client}) : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  Future<UserModel> register(RegisterRequest request) async {
    try {
      final nombreCompleto =
          '${request.firstName} ${request.lastName}'.trim();

      await _client.dio.post(
        '/auth/register',
        data: {
          'nombre': nombreCompleto.isEmpty ? request.email : nombreCompleto,
          'correo': request.email,
          'password': request.password,
          'id_rol': 1,
        },
      );

      // Registro exitoso: iniciamos sesion automaticamente
      // para que Home y Perfil muestren el usuario nuevo.
      return login(
        email: request.email,
        password: request.password,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }

    throw const ApiException(message: 'Error desconocido');
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final loginResponse = await _client.dio.post(
        '/auth/login',
        data: {
          'correo': email,
          'password': password,
        },
      );

      final loginData = loginResponse.data as Map<String, dynamic>;
      final token = loginData['access_token'] as String?;

      if (token == null || token.isEmpty) {
        throw const ApiException(
          message: 'El backend no devolvio token de acceso.',
        );
      }

      _client.setAuthToken(token);

      final meResponse = await _client.dio.get('/auth/me');
      final userData = meResponse.data as Map<String, dynamic>;

      final user = UserModel.fromJson({
        ...userData,
        'access_token': token,
      });

      AuthSession.instance.setUser(user);

      return user;
    } on DioException catch (e) {
      _handleDioError(e);
    }

    throw const ApiException(message: 'Error desconocido');
  }

  Never _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    String? serverMsg;

    if (data is Map<String, dynamic>) {
      final detail = data['detail'];
      final message = data['message'];

      if (detail is String) {
        serverMsg = detail;
      } else if (message is String) {
        serverMsg = message;
      }
    }

    throw ApiException(
      message: serverMsg ?? _defaultMessage(statusCode),
      statusCode: statusCode,
    );
  }

  String _defaultMessage(int? code) => switch (code) {
        400 => 'Datos invalidos. Revisa el formulario.',
        401 => 'Correo o contrasena incorrectos.',
        403 => 'No tienes permisos para esta accion.',
        404 => 'Recurso no encontrado.',
        409 => 'Este correo ya esta registrado.',
        422 => 'Datos invalidos para el backend.',
        500 => 'Error del servidor. Intenta mas tarde.',
        _ => 'Ocurrio un error. Intenta de nuevo.',
      };
}