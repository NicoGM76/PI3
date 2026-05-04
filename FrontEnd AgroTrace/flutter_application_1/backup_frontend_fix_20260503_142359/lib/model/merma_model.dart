// lib/model/merma_model.dart

class MermaModel {
  const MermaModel({
    required this.id,
    required this.idLote,
    required this.cantidadPerdida,
    required this.motivo,
    this.fechaRegistro,
  });

  final String    id;
  final String    idLote;
  final int       cantidadPerdida;
  final String    motivo;
  final DateTime? fechaRegistro;

  factory MermaModel.fromJson(Map<String, dynamic> json) {
    return MermaModel(
      id:               json['id']               as String,
      idLote:           json['idLote']           as String,
      cantidadPerdida:  json['cantidadPerdida']  as int,
      motivo:           json['motivo']           as String,
      fechaRegistro:    json['fechaRegistro'] != null
          ? DateTime.tryParse(json['fechaRegistro'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'idLote':          idLote,
        'cantidadPerdida': cantidadPerdida,
        'motivo':          motivo,
        'fechaRegistro':   (fechaRegistro ?? DateTime.now()).toIso8601String(),
      };
}