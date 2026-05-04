// lib/controller/merma/merma_controller.dart

import 'package:flutter/foundation.dart';

import '../../core/network/api_exception.dart';
import '../../model/merma_model.dart';
import 'merma_repository.dart';

enum MermaStatus { idle, loading, success, error }

class MermaController extends ChangeNotifier {
  MermaController({MermaRepository? repository})
      : _repository = repository ?? MermaRepository();

  final MermaRepository _repository;
  MermaStatus _status = MermaStatus.idle;
  String? _errorMessage;
  String? _loteSeleccionado;
  String? _motivoSeleccionado;

  // Lotes disponibles
  // TODO: cargar desde el backend o desde InventarioController.
  final List<String> lotesDisponibles = [
    'LT-023',
    'LT-015',
    'LT-011',
    'LT-008',
    'LT-006',
    'LT-004',
    'LT-002',
  ];

  // Motivos de merma
  final List<String> motivos = [
    'Dano',
    'Vencimiento',
    'Transporte',
    'Plaga',
    'Clima',
    'Otro',
  ];
  MermaStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == MermaStatus.loading;
  String? get loteSeleccionado => _loteSeleccionado;
  String? get motivoSeleccionado => _motivoSeleccionado;
  void seleccionarLote(String? lote) {
    _loteSeleccionado = lote;
    notifyListeners();
  }

  void seleccionarMotivo(String motivo) {
    _motivoSeleccionado = motivo;
    notifyListeners();
  }

  Future<void> registrarMerma({
    required String cantidadPerdida,
    required VoidCallback onSuccess,
  }) async {
    _setStatus(MermaStatus.loading);
    _errorMessage = null;

    try {
      final merma = MermaModel(
        id: '',
        idLote: _loteSeleccionado ?? '',
        cantidadPerdida: int.tryParse(cantidadPerdida) ?? 0,
        motivo: _motivoSeleccionado ?? '',
      );

      await _repository.registrarMerma(merma);

      _setStatus(MermaStatus.success);
      onSuccess();
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _setStatus(MermaStatus.error);
    } catch (_) {
      _errorMessage = 'Ocurrio un error inesperado.';
      _setStatus(MermaStatus.error);
    }
  }

  void limpiar() {
    _loteSeleccionado = null;
    _motivoSeleccionado = null;
    _errorMessage = null;
    _setStatus(MermaStatus.idle);
  }

  void _setStatus(MermaStatus status) {
    _status = status;
    notifyListeners();
  }
}