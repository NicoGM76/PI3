// lib/view/lote/registrar_lote_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/lote/lote_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/app_validators.dart';
import '../widgets/agro_app_bar.dart';
import '../widgets/agro_primary_button.dart';
import '../widgets/agro_text_field.dart';

class RegistrarLoteScreen extends StatefulWidget {
  const RegistrarLoteScreen({super.key});

  @override
  State<RegistrarLoteScreen> createState() => _RegistrarLoteScreenState();
}

class _RegistrarLoteScreenState extends State<RegistrarLoteScreen> {
  final _formKey          = GlobalKey<FormState>();
  final _idLoteController = TextEditingController();
  final _ubicacionController = TextEditingController();

  @override
  void dispose() {
    _idLoteController.dispose();
    _ubicacionController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final ctrl = context.read<LoteController>();

    if (!_formKey.currentState!.validate()) return;

    if (ctrl.variedadSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una variedad')),
      );
      return;
    }

    if (ctrl.fechaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una fecha de siembra')),
      );
      return;
    }

    ctrl.guardarLote(
      idLote:    _idLoteController.text.trim(),
      ubicacion: _ubicacionController.text.trim(),
      onSuccess: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lote registrado exitosamente')),
        );
        Navigator.pop(context);
      },
    );
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final ctrl = context.read<LoteController>();
    final hoy  = DateTime.now();

    final fecha = await showDatePicker(
      context:     context,
      initialDate: ctrl.fechaSeleccionada ?? hoy,
      firstDate:   DateTime(2000),
      lastDate:    hoy,
      locale:      const Locale('es', 'CO'),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary:   AppColors.primary,
            secondary: AppColors.accent,
          ),
        ),
        child: child!,
      ),
    );

    if (fecha != null) ctrl.seleccionarFecha(fecha);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AgroAppBar(titulo: 'Registrar Lote'),

          // ── Contenido ─────────────────────────────────────────────
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
                        // ID del Lote
                        AgroTextField(
                          label:     'ID del Lote',
                          controller: _idLoteController,
                          validator: AppValidators.validateName,
                        ),
                        const SizedBox(height: AppDimens.spaceMD),

                        // Variedad — dropdown
                        Text('Variedad', style: AppTextStyles.labelField),
                        const SizedBox(height: AppDimens.spaceXS + 2),
                        Consumer<LoteController>(
                          builder: (_, ctrl, __) => Container(
                            height:     AppDimens.inputHeight,
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppDimens.inputHorizontalPad),
                            decoration: BoxDecoration(
                              color:        AppColors.inputFill,
                              borderRadius: BorderRadius.circular(
                                  AppDimens.inputBorderRadius),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value:    ctrl.variedadSeleccionada,
                                isExpanded: true,
                                hint: Text('Seleccionar',
                                    style: AppTextStyles.hintText),
                                icon: const Icon(Icons.arrow_drop_down,
                                    color: AppColors.textHint),
                                items: ctrl.variedades
                                    .map((v) => DropdownMenuItem(
                                          value: v,
                                          child: Text(v,
                                              style:
                                                  AppTextStyles.bodyRegular),
                                        ))
                                    .toList(),
                                onChanged: ctrl.seleccionarVariedad,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceMD),

                        // Fecha de siembra
                        Text('Fecha de siembra',
                            style: AppTextStyles.labelField),
                        const SizedBox(height: AppDimens.spaceXS + 2),
                        Consumer<LoteController>(
                          builder: (_, ctrl, __) => GestureDetector(
                            onTap: () => _seleccionarFecha(context),
                            child: Container(
                              height: AppDimens.inputHeight,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimens.inputHorizontalPad),
                              decoration: BoxDecoration(
                                color:        AppColors.inputFill,
                                borderRadius: BorderRadius.circular(
                                    AppDimens.inputBorderRadius),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ctrl.fechaFormateada,
                                    style: ctrl.fechaSeleccionada == null
                                        ? AppTextStyles.hintText
                                        : AppTextStyles.bodyRegular.copyWith(
                                            color: AppColors.textPrimary),
                                  ),
                                  const Icon(Icons.calendar_month_outlined,
                                      color: AppColors.primary),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceMD),

                        // Ubicación
                        AgroTextField(
                          label:      'Ubicación',
                          controller: _ubicacionController,
                          validator:  AppValidators.validateName,
                        ),
                        const SizedBox(height: AppDimens.spaceXS),

                        // Error
                        Consumer<LoteController>(
                          builder: (_, ctrl, __) {
                            if (ctrl.errorMessage == null) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: AppDimens.spaceSM),
                              child: Text(ctrl.errorMessage!,
                                  style: AppTextStyles.errorText),
                            );
                          },
                        ),

                        const SizedBox(height: AppDimens.spaceXL),

                        // Botón guardar
                        Consumer<LoteController>(
                          builder: (_, ctrl, __) => AgroPrimaryButton(
                            label:     'Guardar Lote',
                            isLoading: ctrl.isLoading,
                            onPressed: () => _submit(context),
                          ),
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