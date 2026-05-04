// lib/model/lote_model.dart

class LoteModel {
  const LoteModel({
    required this.id,
    required this.idLote,
    required this.variedad,
    required this.fechaSiembra,
    required this.ubicacion,
  });

  final String id;
  final String idLote;
  final String variedad;
  final DateTime fechaSiembra;
  final String ubicacion;

  factory LoteModel.fromJson(Map<String, dynamic> json) {
    return LoteModel(
      id:           json['id']           as String,
      idLote:       json['idLote']       as String,
      variedad:     json['variedad']     as String,
      fechaSiembra: DateTime.parse(json['fechaSiembra'] as String),
      ubicacion:    json['ubicacion']    as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'idLote':       idLote,
        'variedad':     variedad,
        'fechaSiembra': fechaSiembra.toIso8601String(),
        'ubicacion':    ubicacion,
      };
}