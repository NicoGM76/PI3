// lib/controller/empaque/empaque_repository.dart

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../model/empaque_model.dart';

class EmpaqueRepository {
  EmpaqueRepository({ApiClient? client})
      : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  Future<EmpaqueModel> registrarEmpaque(EmpaqueModel empaque) async {
    try {
      final response = await _client.dio.post(
        'empaques',
        data: empaque.toJson(),
      );
      return EmpaqueModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
    throw const ApiException(message: 'Error desconocido');
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
        400 => 'Datos inválidos. Revisa el formulario.',
        404 => 'Lote no encontrado.',
        500 => 'Error del servidor. Intenta más tarde.',
        _   => 'Ocurrió un error. Intenta de nuevo.',
      };
}