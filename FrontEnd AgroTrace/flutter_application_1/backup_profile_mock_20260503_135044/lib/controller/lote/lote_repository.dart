// lib/controller/lote/lote_repository.dart

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../model/lote_model.dart';

class LoteRepository {
  LoteRepository({ApiClient? client})
      : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  Future<LoteModel> registrarLote(LoteModel lote) async {
    try {
      final response = await _client.dio.post(
        'lotes',
        data: lote.toJson(),
      );
      return LoteModel.fromJson(response.data as Map<String, dynamic>);
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
        409 => 'Este lote ya existe.',
        500 => 'Error del servidor. Intenta más tarde.',
        _   => 'Ocurrió un error. Intenta de nuevo.',
      };
}