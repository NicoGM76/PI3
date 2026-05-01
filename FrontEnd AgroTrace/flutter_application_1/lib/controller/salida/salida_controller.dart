// lib/controller/salida/salida_controller.dart

import 'package:flutter/foundation.dart';
import '../../core/network/api_exception.dart';
import '../../model/salida_model.dart';
import 'salida_repository.dart';

enum SalidaStatus { idle, loading, success, error }

class SalidaController extends ChangeNotifier {
  SalidaController({SalidaRepository? repository})
      : _repository = repository ?? SalidaRepository();

  final SalidaRepository _repository;

  // ─── Estado ───────────────────────────────────────────────────────
  SalidaStatus _status        = SalidaStatus.idle;
  String?      _errorMessage;
  String?      _loteSeleccionado;

  // Lotes disponibles
  // TODO: cargar desde el backend o desde InventarioController
  final List<String> lotesDisponibles = [
    'LT-023',
    'LT-015',
    'LT-011',
    'LT-008',
    'LT-006',
    'LT-004',
    'LT-002',
  ];

  // ─── Getters ──────────────────────────────────────────────────────
  SalidaStatus get status           => _status;
  String?      get errorMessage     => _errorMessage;
  bool         get isLoading        => _status == SalidaStatus.loading;
  String?      get loteSeleccionado => _loteSeleccionado;

  // ─── Acciones ─────────────────────────────────────────────────────
  void seleccionarLote(String? lote) {
    _loteSeleccionado = lote;
    notifyListeners();
  }

  Future<void> registrarSalida({
    required String   cantidad,
    required String   destino,
    required VoidCallback onSuccess,
  }) async {
    _setStatus(SalidaStatus.loading);

    // ── SIMULACIÓN TEMPORAL ─────────────────────────────────────────
    // Elimina este bloque cuando el backend esté listo
    await Future.delayed(const Duration(seconds: 1));
    _setStatus(SalidaStatus.success);
    onSuccess();
    return;
    // ───────────────────────────────────────────────────────────────

    // ── CONEXIÓN CON BACKEND ────────────────────────────────────────
    // Descomenta cuando el backend esté listo
    //
    // try {
    //   final salida = SalidaModel(
    //     id:       '',
    //     idLote:   _loteSeleccionado ?? '',
    //     cantidad: int.tryParse(cantidad) ?? 0,
    //     destino:  destino,
    //   );
    //   await _repository.registrarSalida(salida);
    //   _setStatus(SalidaStatus.success);
    //   onSuccess();
    // } on ApiException catch (e) {
    //   _errorMessage = e.message;
    //   _setStatus(SalidaStatus.error);
    // } catch (_) {
    //   _errorMessage = 'Ocurrió un error inesperado.';
    //   _setStatus(SalidaStatus.error);
    // }
    // ───────────────────────────────────────────────────────────────
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      _setStatus(SalidaStatus.idle);
    }
  }

  void _setStatus(SalidaStatus status) {
    _status = status;
    notifyListeners();
  }
}