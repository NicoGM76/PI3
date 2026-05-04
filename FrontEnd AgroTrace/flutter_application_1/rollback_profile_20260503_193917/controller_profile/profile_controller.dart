// lib/controller/profile/profile_controller.dart

import 'package:flutter/foundation.dart';

import '../../model/profile_model.dart';
import 'profile_repository.dart';

enum ProfileStatus { idle, loading, saving, success, error }

class ProfileController extends ChangeNotifier {
  ProfileController({ProfileRepository? repository})
      : _repository = repository ?? ProfileRepository() {
    Future.microtask(cargarPerfil);
  }

  final ProfileRepository _repository;

  ProfileStatus _status = ProfileStatus.idle;
  String? _errorMessage;
  ProfileModel? _profile;
  bool _editando = false;

  ProfileStatus get status => _status;
  String? get errorMessage => _errorMessage;
  ProfileModel? get profile => _profile;
  bool get isLoading => _status == ProfileStatus.loading;
  bool get isSaving => _status == ProfileStatus.saving;
  bool get editando => _editando;

  void toggleEditar() {
    _editando = !_editando;
    notifyListeners();
  }

  Future<void> cargarPerfil() async {
    _setStatus(ProfileStatus.loading);
    _errorMessage = null;

    try {
      _profile = await _repository.obtenerPerfil();
      _setStatus(ProfileStatus.success);
    } catch (e) {
      _errorMessage = e.toString();
      _setStatus(ProfileStatus.error);
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

  void _setStatus(ProfileStatus status) {
    _status = status;
    notifyListeners();
  }
}