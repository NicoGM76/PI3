// lib/controller/inventario/inventario_repository.dart

import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../model/inventario_item_model.dart';

class InventarioRepository {
  InventarioRepository({ApiClient? client})
      : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  /// Obtiene la lista paginada del inventario.
  Future<List<InventarioItemModel>> obtenerInventario({
    int    page  = 1,
    int    limit = 10,
    String query = '',
  }) async {
    try {
      final response = await _client.dio.get(
        'inventario',
        queryParameters: {
          'page':  page,
          'limit': limit,
          if (query.isNotEmpty) 'q': query,
        },
      );
      final lista = response.data['items'] as List<dynamic>;
      return lista
          .map((e) => InventarioItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
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
        500 => 'Error del servidor. Intenta mas tarde.',
        _   => 'Ocurrio un error. Intenta de nuevo.',
      };
}