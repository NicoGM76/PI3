// lib/view/salida/salida_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/salida/salida_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';
import '../widgets/agro_app_bar.dart';
import '../widgets/agro_primary_button.dart';
import '../widgets/agro_app_bar.dart';
import '../widgets/agro_text_field.dart';

class SalidaScreen extends StatefulWidget {
  const SalidaScreen({super.key});

  @override
  State<SalidaScreen> createState() => _SalidaScreenState();
}

class _SalidaScreenState extends State<SalidaScreen> {
  final _formKey            = GlobalKey<FormState>();
  final _cantidadController = TextEditingController();
  final _destinoController  = TextEditingController();

  @override
  void dispose() {
    _cantidadController.dispose();
    _destinoController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final ctrl = context.read<SalidaController>();

    if (!_formKey.currentState!.validate()) return;

    if (ctrl.loteSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un lote')),
      );
      return;
    }

    ctrl.registrarSalida(
      cantidad: _cantidadController.text.trim(),
      destino:  _destinoController.text.trim(),
      onSuccess: () {
        // Limpiar formulario
        _cantidadController.clear();
        _destinoController.clear();
        context.read<SalidaController>().seleccionarLote(null);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:          Text('Salida registrada exitosamente'),
            backgroundColor:  AppColors.success,
          ),
        );
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<SalidaController>();

    return Scaffold(
      body: Column(
        children: [
          AgroAppBar(titulo: 'Registrar Salida'),

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
                      _ChipLabel(label: 'Registrar Salida'),
                      const SizedBox(height: AppDimens.spaceXL),

                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Seleccionar Lote',
                                style: AppTextStyles.labelField),
                            const SizedBox(height: AppDimens.spaceXS + 2),
                            Container(
                              height: AppDimens.inputHeight,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimens.inputHorizontalPad),
                              decoration: BoxDecoration(
                                color: AppColors.inputFill,
                                borderRadius: BorderRadius.circular(
                                    AppDimens.inputBorderRadius),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value:      ctrl.loteSeleccionado,
                                  isExpanded: true,
                                  hint: Text('Seleccionar',
                                      style: AppTextStyles.hintText),
                                  icon: const Icon(Icons.arrow_drop_down,
                                      color: AppColors.textHint),
                                  items: ctrl.lotesDisponibles
                                      .map((lote) => DropdownMenuItem(
                                            value: lote,
                                            child: Text(lote,
                                                style: AppTextStyles
                                                    .bodyRegular),
                                          ))
                                      .toList(),
                                  onChanged: ctrl.seleccionarLote,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppDimens.spaceMD),
                            AgroTextField(
                              label:       'Cantidad',
                              controller:  _cantidadController,
                              hint:        'Ej. 10',
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'La cantidad es obligatoria';
                                }
                                final n = int.tryParse(v);
                                if (n == null || n <= 0) {
                                  return 'Ingresa una cantidad valida';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppDimens.spaceMD),
                            AgroTextField(
                              label:          'Destino',
                              controller:     _destinoController,
                              hint:           'Ej. Mercado Central',
                              textInputAction: TextInputAction.done,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'El destino es obligatorio';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppDimens.spaceXS),
                            if (ctrl.errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: AppDimens.spaceSM),
                                child: Text(ctrl.errorMessage!,
                                    style: AppTextStyles.errorText),
                              ),

                            const SizedBox(height: AppDimens.spaceXL),
                            AgroPrimaryButton(
                              label:     'Registrar salida',
                              isLoading: ctrl.isLoading,
                              onPressed: () => _submit(context),
                            ),
                          ],
                        ),
                      ),
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