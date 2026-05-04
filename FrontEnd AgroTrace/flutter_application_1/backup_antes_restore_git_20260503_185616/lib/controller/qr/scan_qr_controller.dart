// lib/controller/qr/scan_qr_controller.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';

enum ScanStatus { idle, scanning, detected, error }

class ScanQrController extends ChangeNotifier {
  ScanStatus _status      = ScanStatus.idle;
  String?    _errorMessage;
  Map<String, dynamic>? _datosDetectados;
  bool _camaraActiva = false;
  ScanStatus            get status          => _status;
  String?               get errorMessage    => _errorMessage;
  Map<String, dynamic>? get datosDetectados => _datosDetectados;
  bool                  get camaraActiva    => _camaraActiva;
  bool                  get hasResult       => _datosDetectados != null;

  // Getters de cada campo del QR detectado
  String get idLote    => _datosDetectados?['idLote']   ?? '-';
  String get variedad  => _datosDetectados?['variedad'] ?? '-';
  String get peso      => _datosDetectados?['peso']     ?? '-';
  String get fecha     => _datosDetectados?['fecha']    ?? '-';
  void abrirCamara() {
    _camaraActiva = true;
    _datosDetectados = null;
    _setStatus(ScanStatus.scanning);
  }

  void cerrarCamara() {
    _camaraActiva = false;
    _setStatus(ScanStatus.idle);
  }
  /// Intenta parsear el JSON generado por la app.
  void onQrDetectado(String rawValue) {
    if (_status == ScanStatus.detected) return; // evitar doble deteccion

    try {
      final data = jsonDecode(rawValue) as Map<String, dynamic>;

      // Valida que sea un QR generado por AgroTrace
      if (!data.containsKey('idLote')) {
        _errorMessage = 'QR no reconocido. Usa un QR generado por AgroTrace.';
        _setStatus(ScanStatus.error);
        return;
      }

      _datosDetectados = data;
      _camaraActiva    = false;
      _errorMessage    = null;
      _setStatus(ScanStatus.detected);
    } catch (_) {
      _errorMessage = 'QR no reconocido. Usa un QR generado por AgroTrace.';
      _setStatus(ScanStatus.error);
    }
  }

  void limpiar() {
    _datosDetectados = null;
    _errorMessage    = null;
    _camaraActiva    = false;
    _setStatus(ScanStatus.idle);
  }

  void _setStatus(ScanStatus status) {
    _status = status;
    notifyListeners();
  }
}