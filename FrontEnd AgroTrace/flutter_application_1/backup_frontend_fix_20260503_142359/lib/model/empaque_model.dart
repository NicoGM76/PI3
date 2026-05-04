// lib/model/empaque_model.dart

class EmpaqueModel {
  const EmpaqueModel({
    required this.id,
    required this.idLote,
    required this.pesoTotal,
    required this.unidades,
    required this.tipoEmpaque,
  });

  final String id;
  final String idLote;
  final double pesoTotal;
  final int    unidades;
  final String tipoEmpaque;

  factory EmpaqueModel.fromJson(Map<String, dynamic> json) {
    return EmpaqueModel(
      id:          json['id']          as String,
      idLote:      json['idLote']      as String,
      pesoTotal:   (json['pesoTotal']  as num).toDouble(),
      unidades:    json['unidades']    as int,
      tipoEmpaque: json['tipoEmpaque'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'idLote':      idLote,
        'pesoTotal':   pesoTotal,
        'unidades':    unidades,
        'tipoEmpaque': tipoEmpaque,
      };
}