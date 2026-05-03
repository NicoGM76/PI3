// lib/core/network/api_client.dart
//
// Centraliza todas las llamadas HTTP.
// Backend FastAPI local:
// http://127.0.0.1:8000

import 'package:dio/dio.dart';

class ApiClient {
  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(_AuthInterceptor());

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('================ HTTP REQUEST ================');
          print('${options.method} ${options.uri}');
          print('Headers: ${options.headers}');
          print('Data: ${options.data}');
          print('==============================================');
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('================ HTTP RESPONSE ===============');
          print('${response.statusCode} ${response.requestOptions.uri}');
          print('Data: ${response.data}');
          print('==============================================');
          handler.next(response);
        },
        onError: (error, handler) {
          print('================ HTTP ERROR ==================');
          print('URL: ${error.requestOptions.uri}');
          print('Method: ${error.requestOptions.method}');
          print('Status: ${error.response?.statusCode}');
          print('Response data: ${error.response?.data}');
          print('Message: ${error.message}');
          print('Type: ${error.type}');
          print('Error: ${error.error}');
          print('==============================================');
          handler.next(error);
        },
      ),
    );
  }

  static final ApiClient instance = ApiClient._();

  // Flutter Web local contra FastAPI local.
  static const String _baseUrl = 'http://127.0.0.1:8000';

  late final Dio _dio;

  Dio get dio => _dio;

  /// Almacena el token JWT después del login.
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}

// ─── Interceptor de autenticación ─────────────────────────────────────────────
class _AuthInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Aquí se podría redirigir al login o refrescar token.
    }

    handler.next(err);
  }
}