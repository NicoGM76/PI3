// lib/controller/profile/profile_repository.dart

import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../model/profile_model.dart';

class ProfileRepository {
  ProfileRepository({ApiClient? client})
      : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  Future<ProfileModel> obtenerPerfil() async {
    try {
      final response = await _client.dio.get('/auth/me');
      return ProfileModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }

    throw const ApiException(message: 'Error desconocido al obtener perfil');
  }

  Future<ProfileModel> actualizarPerfil(ProfileModel profile) async {
    // El backend actual no tiene endpoint real para actualizar perfil.
    // Para la demo mantenemos el cambio local.
    return profile;
  }

  Future<void> cambiarPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    // El backend actual no tiene endpoint real para cambio de contrasena.
    // No-op seguro para demo.
    return;
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
        400 => 'Datos invalidos.',
        401 => 'Sesion no autorizada. Inicia sesion nuevamente.',
        403 => 'No tienes permisos para consultar el perfil.',
        404 => 'Perfil no encontrado.',
        500 => 'Error del servidor. Intenta mas tarde.',
        _ => 'Ocurrio un error. Intenta de nuevo.',
      };
}