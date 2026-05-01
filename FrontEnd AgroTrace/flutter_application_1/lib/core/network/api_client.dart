// lib/core/network/api_client.dart
//
// Centraliza todas las llamadas HTTP.
// Depende del paquete: dio: ^5.x
//
// Para conectar con el backend basta con cambiar baseUrl
// y agregar el token de autenticación en el interceptor.

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
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  static final ApiClient instance = ApiClient._();

  // ─── Cambia esta URL al endpoint real de tu backend ───────────────
  static const String _baseUrl = 'http://10.0.2.2:3000/api';
  // ──────────────────────────────────────────────────────────────────

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
      // TODO: Redirigir al login o refrescar token
    }
    handler.next(err);
  }
}