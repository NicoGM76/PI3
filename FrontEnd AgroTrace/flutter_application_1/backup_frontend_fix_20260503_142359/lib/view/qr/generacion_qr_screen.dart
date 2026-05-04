// lib/view/qr/generacion_qr_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../controller/qr/qr_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';
import '../widgets/agro_app_bar.dart';
import '../widgets/agro_primary_button.dart';
import '../widgets/agro_app_bar.dart';
import '../widgets/agro_text_field.dart';

class GeneracionQrScreen extends StatefulWidget {
  const GeneracionQrScreen({super.key});

  @override
  State<GeneracionQrScreen> createState() => _GeneracionQrScreenState();
}

class _GeneracionQrScreenState extends State<GeneracionQrScreen> {
  final _formKey          = GlobalKey<FormState>();
  final _idLoteController = TextEditingController();
  final _variedadController = TextEditingController();
  final _pesoController   = TextEditingController();

  @override
  void dispose() {
    _idLoteController.dispose();
    _variedadController.dispose();
    _pesoController.dispose();
    super.dispose();
  }

  void _generarQr(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<QrController>().generarQr(
      idLote:   _idLoteController.text.trim(),
      variedad: _variedadController.text.trim(),
      peso:     _pesoController.text.trim(),
    );
  }

  void _guardar(BuildContext context) {
    context.read<QrController>().guardarQr(
      onSuccess: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR guardado exitosamente')),
      ),
    );
  }

  void _compartir(BuildContext context) {
    // TODO: implementar compartir con share_plus cuando esté disponible
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función compartir próximamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<QrController>();

    return Scaffold(
      body: Column(
        children: [
          AgroAppBar(titulo: 'Generación QR'),

          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                    child: Container(color: AppColors.background)),

                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Image.asset(
                    'assets/images/grass_bottom.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 100,
                  ),
                ),

                SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    top:    AppDimens.spaceXL,
                    left:   AppDimens.pageHorizontalPad,
                    right:  AppDimens.pageHorizontalPad,
                    bottom: 120,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ── Formulario para generar QR ───────────────
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AgroTextField(
                              label:      'ID del Lote',
                              controller: _idLoteController,
                              hint:       'Ej. LT-023',
                              validator:  (v) => v == null || v.isEmpty
                                  ? 'Campo obligatorio'
                                  : null,
                            ),
                            const SizedBox(height: AppDimens.spaceMD),

                            AgroTextField(
                              label:      'Variedad',
                              controller: _variedadController,
                              hint:       'Ej. Tomate Cherry',
                              validator:  (v) => v == null || v.isEmpty
                                  ? 'Campo obligatorio'
                                  : null,
                            ),
                            const SizedBox(height: AppDimens.spaceMD),

                            AgroTextField(
                              label:      'Peso',
                              controller: _pesoController,
                              hint:       'Ej. 15kg',
                              validator:  (v) => v == null || v.isEmpty
                                  ? 'Campo obligatorio'
                                  : null,
                            ),
                            const SizedBox(height: AppDimens.spaceLG),

                            AgroPrimaryButton(
                              label:     'Generar QR',
                              isLoading: ctrl.isLoading,
                              onPressed: () => _generarQr(context),
                            ),
                          ],
                        ),
                      ),

                      // ── Resultado del QR ─────────────────────────
                      if (ctrl.hasQr) ...[
                        const SizedBox(height: AppDimens.spaceXL),
                        const Divider(),
                        const SizedBox(height: AppDimens.spaceLG),

                        // Título
                        _ChipLabel(label: 'Código QR generado'),
                        const SizedBox(height: AppDimens.spaceLG),

                        // QR real generado con qr_flutter
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(AppDimens.spaceMD),
                            decoration: BoxDecoration(
                              color:        Colors.white,
                              borderRadius: BorderRadius.circular(
                                  AppDimens.radiusMD),
                              boxShadow: [
                                BoxShadow(
                                  color:      Colors.black.withOpacity(0.08),
                                  blurRadius: 12,
                                  offset:     const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: QrImageView(
                              data:            ctrl.qrActual!.qrData,
                              version:         QrVersions.auto,
                              size:            180,
                              eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color:    Colors.black,
                              ),
                              dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color:           Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceLG),

                        // Chips de info del lote
                        Wrap(
                          spacing:   AppDimens.spaceSM,
                          runSpacing: AppDimens.spaceSM,
                          children: [
                            _InfoChip(
                                label:
                                    'Lote: ${ctrl.qrActual!.idLote}'),
                            _InfoChip(
                                label:
                                    'Variedad: ${ctrl.qrActual!.variedad}'),
                            _InfoChip(
                                label: 'Peso: ${ctrl.qrActual!.peso}'),
                          ],
                        ),
                        const SizedBox(height: AppDimens.spaceXL),

                        // Botones Guardar y Compartir
                        Row(
                          children: [
                            AgroPrimaryButton(
                              label:     'Guardar',
                              isLoading: ctrl.isSaving,
                              onPressed: () => _guardar(context),
                              width:     130,
                            ),
                            const SizedBox(width: AppDimens.spaceMD),
                            AgroPrimaryButton(
                              label:     'Compartir',
                              isLoading: false,
                              onPressed: () => _compartir(context),
                              width:     130,
                            ),
                          ],
                        ),

                        // Error
                        if (ctrl.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(
                                top: AppDimens.spaceSM),
                            child: Text(ctrl.errorMessage!,
                                style: AppTextStyles.errorText),
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Chip verde de etiqueta ────────────────────────────────────────────────────
class _ChipLabel extends StatelessWidget {
  const _ChipLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical:   AppDimens.spaceSM,
      ),
      decoration: BoxDecoration(
        color:        AppColors.primary,
        borderRadius: BorderRadius.circular(AppDimens.radiusSM),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color:      Colors.white,
          fontWeight: FontWeight.w600,
          fontSize:   14,
        ),
      ),
    );
  }
}

// ─── Chip de info del lote ────────────────────────────────────────────────────
class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical:   AppDimens.spaceSM,
      ),
      decoration: BoxDecoration(
        color:        AppColors.primary,
        borderRadius: BorderRadius.circular(AppDimens.radiusSM),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color:      Colors.white,
          fontWeight: FontWeight.w500,
          fontSize:   13,
        ),
      ),
    );
  }
}