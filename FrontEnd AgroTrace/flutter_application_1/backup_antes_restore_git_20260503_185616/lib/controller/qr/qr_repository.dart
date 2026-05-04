// lib/controller/qr/qr_repository.dart

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../model/qr_model.dart';

class QrRepository {
  QrRepository({ApiClient? client})
      : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  /// Guarda el QR generado en el backend
  Future<void> guardarQr(QrModel qr) async {
    try {
      await _client.dio.post('qr', data: qr.toJson());
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
        404 => 'Lote no encontrado.',
        500 => 'Error del servidor. Intenta mas tarde.',
        _   => 'Ocurrio un error. Intenta de nuevo.',
      };
}