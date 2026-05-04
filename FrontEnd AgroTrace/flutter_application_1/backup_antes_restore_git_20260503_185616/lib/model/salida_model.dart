// lib/model/salida_model.dart

class SalidaModel {
  const SalidaModel({
    required this.id,
    required this.idLote,
    required this.cantidad,
    required this.destino,
    this.fechaSalida,
  });

  final String   id;
  final String   idLote;
  final int      cantidad;
  final String   destino;
  final DateTime? fechaSalida;

  factory SalidaModel.fromJson(Map<String, dynamic> json) {
    return SalidaModel(
      id:          json['id']       as String,
      idLote:      json['idLote']   as String,
      cantidad:    json['cantidad'] as int,
      destino:     json['destino']  as String,
      fechaSalida: json['fechaSalida'] != null
          ? DateTime.tryParse(json['fechaSalida'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'idLote':      idLote,
        'cantidad':    cantidad,
        'destino':     destino,
        'fechaSalida': (fechaSalida ?? DateTime.now()).toIso8601String(),
      };
}