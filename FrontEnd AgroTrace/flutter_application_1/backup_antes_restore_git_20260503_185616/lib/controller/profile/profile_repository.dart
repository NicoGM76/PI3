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
      final response = await _client.dio.get('auth/me');
      return ProfileModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
    throw const ApiException(message: 'Error desconocido');
  }

  Future<ProfileModel> actualizarPerfil(ProfileModel profile) async {
    try {
      final response = await _client.dio.put(
        'auth/me',
        data: profile.toJson(),
      );
      return ProfileModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
    throw const ApiException(message: 'Error desconocido');
  }

  Future<void> cambiarPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _client.dio.put(
        'auth/change-password',
        data: {
          'currentPassword': currentPassword,
          'newPassword':     newPassword,
        },
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  Never _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final serverMsg  = e.response?.data?['message'] as String?;
    throw ApiException(
      message:    serverMsg ?? _defaultMessage(statusCode),
      statusCode: statusCode,
    );
  }

  String _defaultMessage(int? code) => switch (code) {
        400 => 'Datos invalidos.',
        401 => 'Contrasena actual incorrecta.',
        500 => 'Error del servidor. Intenta mas tarde.',
        _   => 'Ocurrio un error. Intenta de nuevo.',
      };
}