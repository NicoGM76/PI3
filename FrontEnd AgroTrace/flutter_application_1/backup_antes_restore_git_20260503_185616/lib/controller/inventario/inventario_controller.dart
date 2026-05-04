// lib/controller/inventario/inventario_controller.dart

import 'package:flutter/foundation.dart';
import '../../model/inventario_item_model.dart';
import 'inventario_repository.dart';

enum InventarioStatus { idle, loading, loaded, error }

class InventarioController extends ChangeNotifier {
  InventarioController({InventarioRepository? repository})
      : _repository = repository ?? InventarioRepository() {
  }

  final InventarioRepository _repository;
  InventarioStatus        _status       = InventarioStatus.idle;
  String?                 _errorMessage;
  List<InventarioItemModel> _items      = [];
  List<InventarioItemModel> _itemsFiltrados = [];
  String                  _busqueda     = '';
  int                     _paginaActual = 1;
  static const int        _itemsPorPagina = 3;
  InventarioStatus          get status        => _status;
  String?                   get errorMessage  => _errorMessage;
  bool                      get isLoading     => _status == InventarioStatus.loading;
  String                    get busqueda      => _busqueda;
  int                       get paginaActual  => _paginaActual;

  int get totalPaginas =>
      (_itemsFiltrados.length / _itemsPorPagina).ceil().clamp(1, 999);

  List<InventarioItemModel> get itemsPagina {
    final inicio = (_paginaActual - 1) * _itemsPorPagina;
    final fin    = (inicio + _itemsPorPagina).clamp(0, _itemsFiltrados.length);
    if (inicio >= _itemsFiltrados.length) return [];
    return _itemsFiltrados.sublist(inicio, fin);
  }
  void buscar(String query) {
    _busqueda     = query.toLowerCase();
    _paginaActual = 1;
    _filtrar();
  }

  void _filtrar() {
    if (_busqueda.isEmpty) {
      _itemsFiltrados = List.from(_items);
    } else {
      _itemsFiltrados = _items.where((item) {
        return item.variedad.toLowerCase().contains(_busqueda) ||
            item.idLote.toLowerCase().contains(_busqueda);
      }).toList();
    }
    notifyListeners();
  }
  void irAPagina(int pagina) {
    if (pagina < 1 || pagina > totalPaginas) return;
    _paginaActual = pagina;
    notifyListeners();
  }

  
   Future<void> cargarInventario() async {
     _setStatus(InventarioStatus.loading);
     try {
       _items = await _repository.obtenerInventario(
         query: _busqueda,
         page:  _paginaActual,
       );
       _filtrar();
       _setStatus(InventarioStatus.loaded);
     } catch (e) {
       _errorMessage = e.toString();
       _setStatus(InventarioStatus.error);
     }
   }


  void _setStatus(InventarioStatus status) {
    _status = status;
    notifyListeners();
  }
}