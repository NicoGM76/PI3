// lib/controller/qr/qr_controller.dart

import 'package:flutter/foundation.dart';
import '../../core/network/api_exception.dart';
import '../../model/qr_model.dart';
import 'qr_repository.dart';

enum QrStatus { idle, loading, generated, saving, saved, error }

class QrController extends ChangeNotifier {
  QrController({QrRepository? repository})
      : _repository = repository ?? QrRepository();

  final QrRepository _repository;

  // ─── Estado ───────────────────────────────────────────────────────
  QrStatus _status       = QrStatus.idle;
  String?  _errorMessage;
  QrModel? _qrActual;

  // ─── Getters ──────────────────────────────────────────────────────
  QrStatus get status        => _status;
  String?  get errorMessage  => _errorMessage;
  QrModel? get qrActual      => _qrActual;
  bool     get isLoading     => _status == QrStatus.loading;
  bool     get isSaving      => _status == QrStatus.saving;
  bool     get hasQr         => _qrActual != null;

  // ─── Generar QR ───────────────────────────────────────────────────
  /// Genera un QR nuevo con los datos del lote.
  /// En producción estos datos vendrán del lote seleccionado.
  void generarQr({
    required String idLote,
    required String variedad,
    required String peso,
  }) {
    _qrActual = QrModel(
      idLote:        idLote,
      variedad:      variedad,
      peso:          peso,
      fechaGenerado: DateTime.now(),
    );
    _setStatus(QrStatus.generated);
  }

  // ─── Guardar QR ───────────────────────────────────────────────────
  Future<void> guardarQr({required VoidCallback onSuccess}) async {
    if (_qrActual == null) return;
    _setStatus(QrStatus.saving);

    // ── SIMULACIÓN TEMPORAL ─────────────────────────────────────────
    // Elimina este bloque cuando el backend esté listo
    await Future.delayed(const Duration(seconds: 1));
    _setStatus(QrStatus.saved);
    onSuccess();
    return;
    // ───────────────────────────────────────────────────────────────

    // ── CONEXIÓN CON BACKEND ────────────────────────────────────────
    // Descomenta cuando el backend esté listo
    //
    // try {
    //   await _repository.guardarQr(_qrActual!);
    //   _setStatus(QrStatus.saved);
    //   onSuccess();
    // } on ApiException catch (e) {
    //   _errorMessage = e.message;
    //   _setStatus(QrStatus.error);
    // } catch (_) {
    //   _errorMessage = 'Ocurrió un error inesperado.';
    //   _setStatus(QrStatus.error);
    // }
    // ───────────────────────────────────────────────────────────────
  }

  void limpiar() {
    _qrActual      = null;
    _errorMessage  = null;
    _setStatus(QrStatus.idle);
  }

  void _setStatus(QrStatus status) {
    _status = status;
    notifyListeners();
  }
}