// lib/controller/lote/lote_controller.dart

import 'package:flutter/foundation.dart';
import '../../core/network/api_exception.dart';
import '../../model/lote_model.dart';
import 'lote_repository.dart';

enum LoteStatus { idle, loading, success, error }

class LoteController extends ChangeNotifier {
  LoteController({LoteRepository? repository})
      : _repository = repository ?? LoteRepository();

  final LoteRepository _repository;
  LoteStatus _status       = LoteStatus.idle;
  String?    _errorMessage;
  DateTime?  _fechaSeleccionada;

  // Opciones del dropdown de variedades
  final List<String> variedades = [
    'Tomate',
    'Papa',
    'Maiz',
    'Arroz',
    'Cebolla',
    'Zanahoria',
    'Lechuga',
  ];

  String? _variedadSeleccionada;
  LoteStatus get status              => _status;
  String?    get errorMessage        => _errorMessage;
  bool       get isLoading           => _status == LoteStatus.loading;
  DateTime?  get fechaSeleccionada   => _fechaSeleccionada;
  String?    get variedadSeleccionada => _variedadSeleccionada;

  String get fechaFormateada {
    if (_fechaSeleccionada == null) return 'Seleccionar fecha';
    final d = _fechaSeleccionada!;
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
  }
  void seleccionarVariedad(String? variedad) {
    _variedadSeleccionada = variedad;
    notifyListeners();
  }

  void seleccionarFecha(DateTime fecha) {
    _fechaSeleccionada = fecha;
    notifyListeners();
  }

  Future<void> guardarLote({
    required String idLote,
    required String ubicacion,
    required VoidCallback onSuccess,
  }) async {
    _setStatus(LoteStatus.loading);





    
     try {
       final lote = LoteModel(
         id:           '',
         idLote:       idLote,
         variedad:     _variedadSeleccionada ?? '',
         fechaSiembra: _fechaSeleccionada ?? DateTime.now(),
         ubicacion:    ubicacion,
       );
       await _repository.registrarLote(lote);
       _setStatus(LoteStatus.success);
       onSuccess();
     } on ApiException catch (e) {
       _errorMessage = e.message;
       _setStatus(LoteStatus.error);
     } catch (_) {
       _errorMessage = 'Ocurrio un error inesperado.';
       _setStatus(LoteStatus.error);
     }

  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      _setStatus(LoteStatus.idle);
    }
  }

  void _setStatus(LoteStatus status) {
    _status = status;
    notifyListeners();
  }
}