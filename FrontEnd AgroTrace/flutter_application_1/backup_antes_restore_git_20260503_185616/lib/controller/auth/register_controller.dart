// lib/controllers/auth/register_controller.dart
//
// Controlador MVC para la pantalla de registro.
// Usa ChangeNotifier (Provider) para notificar cambios a la Vista.

import 'package:flutter/foundation.dart';
import '../../core/network/api_exception.dart';
import '../../model/register_request.dart';
import '../../model/user_model.dart';
import 'auth_repository.dart';

enum RegisterStatus { idle, loading, success, error }

class RegisterController extends ChangeNotifier {
  RegisterController({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;
  RegisterStatus _status = RegisterStatus.idle;
  String?        _errorMessage;
  UserModel?     _registeredUser;

  // Controla la visibilidad de Contrasenas
  bool _obscurePassword        = true;
  bool _obscureConfirmPassword = true;
  RegisterStatus get status          => _status;
  String?        get errorMessage    => _errorMessage;
  UserModel?     get registeredUser  => _registeredUser;
  bool get isLoading                 => _status == RegisterStatus.loading;
  bool get obscurePassword           => _obscurePassword;
  bool get obscureConfirmPassword    => _obscureConfirmPassword;

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleObscureConfirmPassword() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  /// Llamado desde la Vista cuando el usuario presiona "Registrarse".
  /// [onSuccess] se invoca con el usuario creado para que la Vista
  /// pueda navegar a la siguiente pantalla.
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required VoidCallback onSuccess,
  }) async {
    _setStatus(RegisterStatus.loading);

    try {
      final request = RegisterRequest(
        firstName: firstName,
        lastName:  lastName,
        email:     email,
        password:  password,
      );

      _registeredUser = await _repository.register(request);
      _setStatus(RegisterStatus.success);
      onSuccess();
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _setStatus(RegisterStatus.error);
    } catch (_) {
      _errorMessage = 'Ocurrio un error inesperado. Intenta de nuevo.';
      _setStatus(RegisterStatus.error);
    }
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      _setStatus(RegisterStatus.idle);
    }
  }
  void _setStatus(RegisterStatus status) {
    _status = status;
    notifyListeners();
  }
}