// lib/view/merma/merma_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/merma/merma_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';
import '../widgets/agro_primary_button.dart';
import '../widgets/agro_text_field.dart';

class MermaScreen extends StatefulWidget {
  const MermaScreen({super.key});

  @override
  State<MermaScreen> createState() => _MermaScreenState();
}

class _MermaScreenState extends State<MermaScreen> {
  final _formKey              = GlobalKey<FormState>();
  final _cantidadController   = TextEditingController();

  @override
  void dispose() {
    _cantidadController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final ctrl = context.read<MermaController>();

    if (!_formKey.currentState!.validate()) return;

    if (ctrl.loteSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un lote')),
      );
      return;
    }

    if (ctrl.motivoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un motivo de merma')),
      );
      return;
    }

    ctrl.registrarMerma(
      cantidadPerdida: _cantidadController.text.trim(),
      onSuccess: () {
        _cantidadController.clear();
        ctrl.limpiar();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:         Text('Merma registrada exitosamente'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<MermaController>();

    return Scaffold(
      body: Column(
        children: [
          _MermaHeader(),
          _MermaNavBar(),

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
                      _ChipLabel(label: 'Registrar Merma'),
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
                              label:        'Cantidad Perdida',
                              controller:   _cantidadController,
                              hint:         'Ej. 5',
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
                            const SizedBox(height: AppDimens.spaceLG),
                            Text('Motivo', style: AppTextStyles.labelField),
                            const SizedBox(height: AppDimens.spaceXS + 2),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.inputFill,
                                borderRadius: BorderRadius.circular(
                                    AppDimens.inputBorderRadius),
                              ),
                              child: Column(
                                children: ctrl.motivos.map((motivo) {
                                  return RadioListTile<String>(
                                    value:      motivo,
                                    groupValue: ctrl.motivoSeleccionado,
                                    onChanged: (v) {
                                      if (v != null) {
                                        ctrl.seleccionarMotivo(v);
                                      }
                                    },
                                    title: Row(
                                      children: [
                                        Text(
                                          _motivoEmoji(motivo),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(width: AppDimens.spaceSM),
                                        Text(motivo,
                                            style: AppTextStyles.bodyRegular),
                                      ],
                                    ),
                                    activeColor:    AppColors.primary,
                                    dense:          true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: AppDimens.spaceSM),
                                  );
                                }).toList(),
                              ),
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
                              label:     'Registrar merma',
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

  String _motivoEmoji(String motivo) {
    return switch (motivo) {
      'Dano'        => '',
      'Vencimiento' => '',
      'Transporte' => '',
      'Plaga'       => '',
      'Clima' => '',
      _             => '',
    };
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
class _MermaHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          SizedBox(height: topPadding),
          SizedBox(
            height: 110,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(width: 130, height: 110,
                    child: Image.asset('assets/images/grass_bottom.png',
                        fit: BoxFit.cover)),
                Expanded(
                  child: Center(
                    child: Image.asset('assets/images/logo_agrotrace.png',
                        height: 80),
                  ),
                ),
                SizedBox(width: 130, height: 110,
                    child: Image.asset('assets/images/grass_bottom.png',
                        fit: BoxFit.cover)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _MermaNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF7B5E3A),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.pageHorizontalPad,
        vertical:   AppDimens.spaceMD,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back,
                color: Colors.white, size: 28),
          ),
          const Text(
            'Registrar Merma',
            style: TextStyle(
              color:      Colors.white,
              fontSize:   16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }
}