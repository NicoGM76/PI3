// lib/view/qr/escanear_qr_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../controller/qr/scan_qr_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';
import '../widgets/agro_app_bar.dart';
import '../widgets/agro_primary_button.dart';

class EscanearQrScreen extends StatefulWidget {
  const EscanearQrScreen({super.key});

  @override
  State<EscanearQrScreen> createState() => _EscanearQrScreenState();
}

class _EscanearQrScreenState extends State<EscanearQrScreen> {
  MobileScannerController? _scannerController;

  @override
  void dispose() {
    _scannerController?.dispose();
    super.dispose();
  }

  void _abrirCamara(BuildContext context) {
    final ctrl = context.read<ScanQrController>();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing:         CameraFacing.back,
    );
    ctrl.abrirCamara();
  }

  void _cerrarCamara(BuildContext context) {
    _scannerController?.dispose();
    _scannerController = null;
    context.read<ScanQrController>().cerrarCamara();
  }

  void _escanearDeNuevo(BuildContext context) {
    context.read<ScanQrController>().limpiar();
    _abrirCamara(context);
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ScanQrController>();

    return Scaffold(
      body: Column(
        children: [
          AgroAppBar(titulo: 'Escanear QR'),

          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                    child: Container(color: AppColors.background)),

                // Pasto inferior
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

                      // ── Chip título ────────────────────────────
                      _ChipLabel(label: 'Escanear QR'),
                      const SizedBox(height: AppDimens.spaceLG),

                      // ── Visor de cámara o placeholder ──────────
                      Center(
                        child: Container(
                          width:  220,
                          height: 220,
                          decoration: BoxDecoration(
                            color:        AppColors.inputFill,
                            borderRadius: BorderRadius.circular(
                                AppDimens.radiusMD),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                AppDimens.radiusMD - 2),
                            child: ctrl.camaraActiva &&
                                    _scannerController != null
                                ? MobileScanner(
                                    controller: _scannerController!,
                                    onDetect: (capture) {
                                      final barcode =
                                          capture.barcodes.firstOrNull;
                                      if (barcode?.rawValue != null) {
                                        ctrl.onQrDetectado(
                                            barcode!.rawValue!);
                                        _scannerController?.dispose();
                                        _scannerController = null;
                                      }
                                    },
                                  )
                                : Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        ctrl.status == ScanStatus.detected
                                            ? Icons.check_circle_outline
                                            : Icons.qr_code_scanner,
                                        size:  64,
                                        color: ctrl.status ==
                                                ScanStatus.detected
                                            ? AppColors.primary
                                            : AppColors.textHint,
                                      ),
                                      const SizedBox(
                                          height: AppDimens.spaceSM),
                                      Text(
                                        ctrl.status == ScanStatus.detected
                                            ? 'QR detectado'
                                            : 'Cámara inactiva',
                                        style: AppTextStyles.bodyRegular,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceMD),

                      // ── Instrucción ────────────────────────────
                      if (ctrl.camaraActiva)
                        Center(
                          child: Text(
                            'Coloque el QR dentro del marco',
                            style: AppTextStyles.bodyRegular,
                          ),
                        ),

                      // ── Error ──────────────────────────────────
                      if (ctrl.status == ScanStatus.error)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: AppDimens.spaceSM),
                          child: Center(
                            child: Text(
                              ctrl.errorMessage ?? '',
                              style: AppTextStyles.errorText,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                      const SizedBox(height: AppDimens.spaceLG),

                      // ── Botón Abrir Cámara ─────────────────────
                      if (!ctrl.camaraActiva &&
                          ctrl.status != ScanStatus.detected)
                        AgroPrimaryButton(
                          label:     'Abrir Cámara',
                          isLoading: false,
                          onPressed: () => _abrirCamara(context),
                        ),

                      // ── Botón Cerrar cámara ────────────────────
                      if (ctrl.camaraActiva)
                        AgroPrimaryButton(
                          label:     'Cancelar',
                          isLoading: false,
                          onPressed: () => _cerrarCamara(context),
                        ),

                      // ── Resultado del QR detectado ─────────────
                      if (ctrl.hasResult) ...[
                        const SizedBox(height: AppDimens.spaceLG),
                        const Divider(),
                        const SizedBox(height: AppDimens.spaceMD),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppDimens.spaceMD),
                          decoration: BoxDecoration(
                            color: AppColors.inputFill,
                            borderRadius: BorderRadius.circular(
                                AppDimens.radiusMD),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cuando se detecta:',
                                style: AppTextStyles.labelField,
                              ),
                              const SizedBox(height: AppDimens.spaceSM),
                              _ResultRow(
                                  label: 'Lote',
                                  value: ctrl.idLote),
                              _ResultRow(
                                  label: 'Variedad',
                                  value: ctrl.variedad),
                              _ResultRow(
                                  label: 'Peso',
                                  value: ctrl.peso),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceLG),

                        // Botón escanear de nuevo
                        AgroPrimaryButton(
                          label:     'Escanear otro QR',
                          isLoading: false,
                          onPressed: () => _escanearDeNuevo(context),
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

// ─── Fila de resultado ────────────────────────────────────────────────────────
class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceXS),
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.bodyRegular,
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

// ─── Chip verde ───────────────────────────────────────────────────────────────
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