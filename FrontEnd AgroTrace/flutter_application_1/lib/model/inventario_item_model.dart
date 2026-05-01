// lib/model/inventario_item_model.dart

class InventarioItemModel {
  const InventarioItemModel({
    required this.id,
    required this.idLote,
    required this.variedad,
    required this.fechaEmpaque,
    required this.stock,
  });

  final String   id;
  final String   idLote;
  final String   variedad;
  final DateTime fechaEmpaque;
  final int      stock;

  String get fechaFormateada {
    return '${fechaEmpaque.day.toString().padLeft(2, '0')}/'
        '${fechaEmpaque.month.toString().padLeft(2, '0')}';
  }

  factory InventarioItemModel.fromJson(Map<String, dynamic> json) {
    return InventarioItemModel(
      id:           json['id']          as String,
      idLote:       json['idLote']      as String,
      variedad:     json['variedad']    as String,
      fechaEmpaque: DateTime.parse(json['fechaEmpaque'] as String),
      stock:        json['stock']       as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id':           id,
        'idLote':       idLote,
        'variedad':     variedad,
        'fechaEmpaque': fechaEmpaque.toIso8601String(),
        'stock':        stock,
      };
}