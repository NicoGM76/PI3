// lib/controller/empaque/empaque_controller.dart

import 'package:flutter/foundation.dart';
import '../../core/network/api_exception.dart';
import '../../model/empaque_model.dart';
import 'empaque_repository.dart';

enum EmpaqueStatus { idle, loading, success, error }

class EmpaqueController extends ChangeNotifier {
  EmpaqueController({EmpaqueRepository? repository})
      : _repository = repository ?? EmpaqueRepository();

  final EmpaqueRepository _repository;
  EmpaqueStatus _status       = EmpaqueStatus.idle;
  String?       _errorMessage;
  // TODO: recibir el idLote desde la pantalla anterior
  final String idLote = 'LT-023';

  // Tipos de empaque disponibles
  final List<String> tiposEmpaque = ['Bolsa', 'Caja', 'Bandeja'];

  String? _tipoSeleccionado;
  EmpaqueStatus get status          => _status;
  String?       get errorMessage    => _errorMessage;
  bool          get isLoading       => _status == EmpaqueStatus.loading;
  String?       get tipoSeleccionado => _tipoSeleccionado;
  void seleccionarTipo(String tipo) {
    _tipoSeleccionado = tipo;
    notifyListeners();
  }

  Future<void> finalizarEmpaque({
    required String pesoTotal,
    required String unidades,
    required VoidCallback onSuccess,
  }) async {
    _setStatus(EmpaqueStatus.loading);

  

   
    try {
     final empaque = EmpaqueModel(
      id:          '',
        idLote:      idLote,
        pesoTotal:   double.tryParse(pesoTotal) ?? 0,
        unidades:    int.tryParse(unidades) ?? 0,
         tipoEmpaque: _tipoSeleccionado ?? '',
       );
       await _repository.registrarEmpaque(empaque);
      _setStatus(EmpaqueStatus.success);
      onSuccess();
     } on ApiException catch (e) {
      _errorMessage = e.message;
       _setStatus(EmpaqueStatus.error);
     } catch (_) {
       _errorMessage = 'Ocurrio un error inesperado.';
      _setStatus(EmpaqueStatus.error);
     }

  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      _setStatus(EmpaqueStatus.idle);
    }
  }

  void _setStatus(EmpaqueStatus status) {
    _status = status;
    notifyListeners();
  }
}