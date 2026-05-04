// lib/view/empaque/empaque_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../controller/empaque/empaque_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';
import '../widgets/agro_app_bar.dart';
import '../widgets/agro_primary_button.dart';
import '../widgets/agro_app_bar.dart';
import '../widgets/agro_text_field.dart';

class EmpaqueScreen extends StatefulWidget {
  const EmpaqueScreen({super.key});

  @override
  State<EmpaqueScreen> createState() => _EmpaqueScreenState();
}

class _EmpaqueScreenState extends State<EmpaqueScreen> {
  final _formKey            = GlobalKey<FormState>();
  final _pesoController     = TextEditingController();
  final _unidadesController = TextEditingController();

  @override
  void dispose() {
    _pesoController.dispose();
    _unidadesController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final ctrl = context.read<EmpaqueController>();

    if (!_formKey.currentState!.validate()) return;

    if (ctrl.tipoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un tipo de empaque')),
      );
      return;
    }

    ctrl.finalizarEmpaque(
      pesoTotal: _pesoController.text.trim(),
      unidades:  _unidadesController.text.trim(),
      onSuccess: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Empaque registrado exitosamente')),
        );
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<EmpaqueController>();

    return Scaffold(
      body: Column(
        children: [
          AgroAppBar(titulo: 'Empaque'),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(color: AppColors.background),
                ),

                // Pasto inferior
                Positioned(
                  bottom: 0,
                  left:   0,
                  right:  0,
                  child: Image.asset(
                    'assets/images/grass_bottom.png',
                    fit:    BoxFit.cover,
                    width:  double.infinity,
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.spaceMD,
                            vertical:   AppDimens.spaceSM,
                          ),
                          decoration: BoxDecoration(
                            color:        AppColors.primary,
                            borderRadius: BorderRadius.circular(
                                AppDimens.radiusSM),
                          ),
                          child: const Text(
                            'ID Lote',
                            style: TextStyle(
                              color:      Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize:   14,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceSM),
                        Text(
                          ctrl.idLote,
                          style: AppTextStyles.headingMedium,
                        ),
                        const SizedBox(height: AppDimens.spaceLG),
                        AgroTextField(
                          label:       'Peso Total',
                          controller:  _pesoController,
                          hint:        'Ej. 150.5',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'El peso es obligatorio';
                            }
                            if (double.tryParse(v) == null) {
                              return 'Ingresa un numero valido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppDimens.spaceMD),
                        AgroTextField(
                          label:       'Unidades',
                          controller:  _unidadesController,
                          hint:        'Ej. 50',
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Las unidades son obligatorias';
                            }
                            if (int.tryParse(v) == null) {
                              return 'Ingresa un numero entero';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppDimens.spaceLG),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.spaceMD,
                            vertical:   AppDimens.spaceSM,
                          ),
                          decoration: BoxDecoration(
                            color:        AppColors.primary,
                            borderRadius: BorderRadius.circular(
                                AppDimens.radiusSM),
                          ),
                          child: const Text(
                            'Tipo de empaque',
                            style: TextStyle(
                              color:      Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize:   14,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceSM),
                        Container(
                          decoration: BoxDecoration(
                            color:        AppColors.inputFill,
                            borderRadius: BorderRadius.circular(
                                AppDimens.inputBorderRadius),
                          ),
                          child: Column(
                            children: ctrl.tiposEmpaque.map((tipo) {
                              return RadioListTile<String>(
                                value:    tipo,
                                groupValue: ctrl.tipoSeleccionado,
                                onChanged: (v) {
                                  if (v != null) {
                                    ctrl.seleccionarTipo(v);
                                  }
                                },
                                title: Text(
                                  tipo,
                                  style: AppTextStyles.bodyRegular,
                                ),
                                activeColor:  AppColors.primary,
                                dense:        true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: AppDimens.spaceSM,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceXS),
                        if (ctrl.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(
                                top: AppDimens.spaceSM),
                            child: Text(
                              ctrl.errorMessage!,
                              style: AppTextStyles.errorText,
                            ),
                          ),

                        const SizedBox(height: AppDimens.spaceXL),
                        AgroPrimaryButton(
                          label:     'Finalizar Empaque',
                          isLoading: ctrl.isLoading,
                          onPressed: () => _submit(context),
                        ),
                      ],
                    ),
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