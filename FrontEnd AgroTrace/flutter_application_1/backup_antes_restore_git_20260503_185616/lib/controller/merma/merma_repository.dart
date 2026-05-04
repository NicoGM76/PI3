// lib/controller/merma/merma_repository.dart

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../model/merma_model.dart';

class MermaRepository {
  MermaRepository({ApiClient? client})
      : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  Future<MermaModel> registrarMerma(MermaModel merma) async {
    try {
      final response = await _client.dio.post(
        'mermas',
        data: merma.toJson(),
      );
      return MermaModel.fromJson(response.data as Map<String, dynamic>);
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
        400 => 'Datos invalidos. Revisa el formulario.',
        404 => 'Lote no encontrado.',
        409 => 'Cantidad perdida supera el stock disponible.',
        500 => 'Error del servidor. Intenta mas tarde.',
        _   => 'Ocurrio un error. Intenta de nuevo.',
      };
}