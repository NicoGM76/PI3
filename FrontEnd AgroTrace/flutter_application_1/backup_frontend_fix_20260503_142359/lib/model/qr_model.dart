// lib/model/qr_model.dart
//
// Modelo que representa un código QR generado para un lote.
// El contenido del QR es un JSON serializado con los datos del lote.

class QrModel {
  const QrModel({
    required this.idLote,
    required this.variedad,
    required this.peso,
    this.fechaGenerado,
  });

  final String    idLote;
  final String    variedad;
  final String    peso;
  final DateTime? fechaGenerado;

  // ─── Contenido que se codifica dentro del QR ──────────────────────
  // El backend puede leer este JSON al escanear
  String get qrData => '{'
      '"idLote":"$idLote",'
      '"variedad":"$variedad",'
      '"peso":"$peso",'
      '"fecha":"${(fechaGenerado ?? DateTime.now()).toIso8601String()}"'
      '}';

  factory QrModel.fromJson(Map<String, dynamic> json) {
    return QrModel(
      idLote:         json['idLote']   as String,
      variedad:       json['variedad'] as String,
      peso:           json['peso']     as String,
      fechaGenerado:  json['fecha'] != null
          ? DateTime.tryParse(json['fecha'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'idLote':   idLote,
        'variedad': variedad,
        'peso':     peso,
        'fecha':    (fechaGenerado ?? DateTime.now()).toIso8601String(),
      };
}