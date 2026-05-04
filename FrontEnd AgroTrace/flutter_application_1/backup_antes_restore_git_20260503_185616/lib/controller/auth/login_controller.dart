// lib/controller/auth/login_controller.dart

import 'package:flutter/foundation.dart';
import '../../core/network/api_exception.dart';
import '../../model/login_request.dart';
import '../../model/user_model.dart';
import 'auth_repository.dart';

enum LoginStatus { idle, loading, success, error }

class LoginController extends ChangeNotifier {
  LoginController({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;
  LoginStatus _status       = LoginStatus.idle;
  String?     _errorMessage;
  UserModel?  _loggedUser;
  bool        _obscurePassword = true;
  LoginStatus get status         => _status;
  String?     get errorMessage   => _errorMessage;
  UserModel?  get loggedUser     => _loggedUser;
  bool        get isLoading      => _status == LoginStatus.loading;
  bool        get obscurePassword => _obscurePassword;
  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
    required VoidCallback onSuccess,
  }) async {
    _setStatus(LoginStatus.loading);


 
    
     try {
       final request = LoginRequest(email: email, password: password);
    
       _loggedUser = await _repository.login(
        email:    request.email,
        password: request.password,
       );
    
       _setStatus(LoginStatus.success);
       onSuccess();
     } on ApiException catch (e) {
       _errorMessage = e.message;
       _setStatus(LoginStatus.error);
     } catch (_) {
       _errorMessage = 'Ocurrio un error inesperado. Intenta de nuevo.';
       _setStatus(LoginStatus.error);
     }

  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      _setStatus(LoginStatus.idle);
    }
  }

  void _setStatus(LoginStatus status) {
    _status = status;
    notifyListeners();
  }
}