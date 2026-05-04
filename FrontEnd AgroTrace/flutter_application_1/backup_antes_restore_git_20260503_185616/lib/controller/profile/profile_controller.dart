// lib/controller/profile/profile_controller.dart

import 'package:flutter/foundation.dart';
import '../../core/network/api_exception.dart';
import '../../model/profile_model.dart';
import 'profile_repository.dart';

enum ProfileStatus { idle, loading, saving, success, error }

class ProfileController extends ChangeNotifier {
  ProfileController({ProfileRepository? repository})
      : _repository = repository ?? ProfileRepository() {
    _cargarDatosMock();
  }

  final ProfileRepository _repository;
  ProfileStatus _status       = ProfileStatus.idle;
  String?       _errorMessage;
  ProfileModel? _profile;
  bool          _editando      = false;
  ProfileStatus get status       => _status;
  String?       get errorMessage => _errorMessage;
  ProfileModel? get profile      => _profile;
  bool          get isLoading    => _status == ProfileStatus.loading;
  bool          get isSaving     => _status == ProfileStatus.saving;
  bool          get editando     => _editando;
  void toggleEditar() {
    _editando = !_editando;
    notifyListeners();
  }

  Future<void> guardarPerfil({
    required String       firstName,
    required String       lastName,
    required String       email,
    required String       phone,
    required String       role,
    required String       empresa,
    required VoidCallback onSuccess,
  }) async {
    if (_profile == null) return;
    _setStatus(ProfileStatus.saving);
    await Future.delayed(const Duration(seconds: 1));
    _profile = _profile!.copyWith(
      firstName: firstName,
      lastName:  lastName,
      email:     email,
      phone:     phone,
      role:      role,
      empresa:   empresa,
    );
    _editando = false;
    _setStatus(ProfileStatus.success);
    onSuccess();
    return;
    // try {
    //   _profile = await _repository.actualizarPerfil(
    //     _profile!.copyWith(
    //       firstName: firstName,
    //       lastName:  lastName,
    //       email:     email,
    //       phone:     phone,
    //       role:      role,
    //       empresa:   empresa,
    //     ),
    //   );
    //   _editando = false;
    //   _setStatus(ProfileStatus.success);
    //   onSuccess();
    // } on ApiException catch (e) {
    //   _errorMessage = e.message;
    //   _setStatus(ProfileStatus.error);
    // }
  }

  Future<void> cambiarPassword({
    required String       currentPassword,
    required String       newPassword,
    required VoidCallback onSuccess,
  }) async {
    _setStatus(ProfileStatus.saving);
    await Future.delayed(const Duration(seconds: 1));
    _setStatus(ProfileStatus.idle);
    onSuccess();
    return;
    // try {
    //   await _repository.cambiarPassword(
    //     currentPassword: currentPassword,
    //     newPassword:     newPassword,
    //   );
    //   _setStatus(ProfileStatus.idle);
    //   onSuccess();
    // } on ApiException catch (e) {
    //   _errorMessage = e.message;
    //   _setStatus(ProfileStatus.error);
    // }
  }
  void _cargarDatosMock() {
    _profile = const ProfileModel(
      id:        '1',
      firstName: 'Luis',
      lastName:  'API',
      email:     'jLuislAPI2401@outlook.com',
      phone:     '+57 300 0000000',
      role:      'Administrador',
      empresa:   'AgroTrace Demo',
    );
    _status = ProfileStatus.idle;
  }

  void _setStatus(ProfileStatus status) {
    _status = status;
    notifyListeners();
  }
}