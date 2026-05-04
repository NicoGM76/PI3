// lib/controller/profile/profile_controller.dart

import 'package:flutter/foundation.dart';

import '../../core/session/auth_session.dart';
import '../../model/profile_model.dart';
import '../../model/user_model.dart';
import 'profile_repository.dart';

enum ProfileStatus { idle, loading, saving, success, error }

class ProfileController extends ChangeNotifier {
  ProfileController({ProfileRepository? repository})
      : _repository = repository ?? ProfileRepository() {
    _cargarDesdeSesion();
  }

  final ProfileRepository _repository;

  ProfileStatus _status = ProfileStatus.idle;
  String? _errorMessage;
  ProfileModel? _profile;
  bool _editando = false;

  ProfileStatus get status => _status;
  String? get errorMessage => _errorMessage;

  ProfileModel? get profile {
    final user = AuthSession.instance.currentUser;

    if (user != null && (_profile == null || _profile!.email != user.email)) {
      _profile = _profileFromUser(user);
    }

    return _profile;
  }

  bool get isLoading => _status == ProfileStatus.loading;
  bool get isSaving => _status == ProfileStatus.saving;
  bool get editando => _editando;

  void toggleEditar() {
    _editando = !_editando;
    notifyListeners();
  }

  Future<void> cargarPerfil() async {
    final user = AuthSession.instance.currentUser;

    if (user != null) {
      _profile = _profileFromUser(user);
      notifyListeners();
    }

    _setStatus(ProfileStatus.loading);
    _errorMessage = null;

    try {
      _profile = await _repository.obtenerPerfil();
      _setStatus(ProfileStatus.success);
    } catch (e) {
      // No dejamos el perfil en blanco si /auth/me falla.
      if (_profile == null && user != null) {
        _profile = _profileFromUser(user);
      }

      _errorMessage = e.toString();
      _setStatus(_profile == null ? ProfileStatus.error : ProfileStatus.success);
    }
  }

  Future<void> guardarPerfil({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String role,
    required String empresa,
    required VoidCallback onSuccess,
  }) async {
    if (_profile == null) return;

    _setStatus(ProfileStatus.saving);
    _errorMessage = null;

    try {
      final updatedProfile = _profile!.copyWith(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        role: role,
        empresa: empresa,
      );

      _profile = await _repository.actualizarPerfil(updatedProfile);
      _editando = false;
      _setStatus(ProfileStatus.success);
      onSuccess();
    } catch (e) {
      _errorMessage = e.toString();
      _setStatus(ProfileStatus.error);
    }
  }

  Future<void> cambiarPassword({
    required String currentPassword,
    required String newPassword,
    required VoidCallback onSuccess,
  }) async {
    _setStatus(ProfileStatus.saving);
    _errorMessage = null;

    try {
      await _repository.cambiarPassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      _setStatus(ProfileStatus.success);
      onSuccess();
    } catch (e) {
      _errorMessage = e.toString();
      _setStatus(ProfileStatus.error);
    }
  }

  void limpiar() {
    _profile = null;
    _errorMessage = null;
    _editando = false;
    _setStatus(ProfileStatus.idle);
  }

  void _cargarDesdeSesion() {
    final user = AuthSession.instance.currentUser;

    if (user != null) {
      _profile = _profileFromUser(user);
      _status = ProfileStatus.success;
    }
  }

  ProfileModel _profileFromUser(UserModel user) {
    return ProfileModel(
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      phone: '',
      role: _roleFromId(user.idRol),
      empresa: 'AgroTrace',
    );
  }

  String _roleFromId(int? idRol) {
    return switch (idRol) {
      1 => 'Administrador',
      2 => 'Operario',
      3 => 'Supervisor',
      _ => '',
    };
  }

  void _setStatus(ProfileStatus status) {
    _status = status;
    notifyListeners();
  }
}