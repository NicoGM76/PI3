// lib/core/session/auth_session.dart

import '../../model/user_model.dart';

class AuthSession {
  AuthSession._();

  static final AuthSession instance = AuthSession._();

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  void setUser(UserModel user) {
    _currentUser = user;
  }

  void clear() {
    _currentUser = null;
  }
}