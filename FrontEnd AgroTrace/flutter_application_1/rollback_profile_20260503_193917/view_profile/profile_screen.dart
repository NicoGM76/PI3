// lib/view/profile/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/profile/profile_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/session/auth_session.dart';
import '../../core/utils/app_validators.dart';
import '../widgets/agro_app_bar.dart';
import '../widgets/agro_primary_button.dart';
import '../widgets/agro_app_bar.dart';
import '../widgets/agro_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey           = GlobalKey<FormState>();
  final _firstNameCtrl     = TextEditingController();
  final _lastNameCtrl      = TextEditingController();
  final _emailCtrl         = TextEditingController();
  final _phoneCtrl         = TextEditingController();
  final _roleCtrl          = TextEditingController();
  final _empresaCtrl       = TextEditingController();

  @override
  void initState() {
    super.initState();
    _llenarCampos();
  }

  void _llenarCampos() {
    final profile =
        context.read<ProfileController>().profile;
    if (profile == null) return;
    _firstNameCtrl.text = profile.firstName;
    _lastNameCtrl.text  = profile.lastName;
    _emailCtrl.text     = profile.email;
    _phoneCtrl.text     = profile.phone     ?? '';
    _roleCtrl.text      = profile.role      ?? '';
    _empresaCtrl.text   = profile.empresa   ?? '';
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _roleCtrl.dispose();
    _empresaCtrl.dispose();
    super.dispose();
  }

  void _guardar(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<ProfileController>().guardarPerfil(
      firstName: _firstNameCtrl.text.trim(),
      lastName:  _lastNameCtrl.text.trim(),
      email:     _emailCtrl.text.trim(),
      phone:     _phoneCtrl.text.trim(),
      role:      _roleCtrl.text.trim(),
      empresa:   _empresaCtrl.text.trim(),
      onSuccess: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:         Text('Perfil actualizado correctamente'),
          backgroundColor: AppColors.success,
        ),
      ),
    );
  }

  void _mostrarCambioPassword(BuildContext context) {
    final currentCtrl = TextEditingController();
    final newCtrl     = TextEditingController();
    final confirmCtrl = TextEditingController();
    final formKey     = GlobalKey<FormState>();

    showModalBottomSheet(
      context:       context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimens.radiusXL)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left:   AppDimens.pageHorizontalPad,
          right:  AppDimens.pageHorizontalPad,
          top:    AppDimens.spaceLG,
          bottom: MediaQuery.of(context).viewInsets.bottom +
              AppDimens.spaceXL,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width:  40,
                  height: 4,
                  decoration: BoxDecoration(
                    color:        AppColors.inputFill,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.spaceLG),
              Text('Cambiar contraseÃ±a',
                  style: AppTextStyles.headingMedium),
              const SizedBox(height: AppDimens.spaceLG),

              AgroTextField(
                label:      'ContraseÃ±a actual',
                controller: currentCtrl,
                obscureText: true,
                validator: (v) => v == null || v.isEmpty
                    ? 'Campo obligatorio'
                    : null,
              ),
              const SizedBox(height: AppDimens.spaceMD),

              AgroTextField(
                label:      'Nueva contraseÃ±a',
                controller: newCtrl,
                obscureText: true,
                validator:  AppValidators.validatePassword,
              ),
              const SizedBox(height: AppDimens.spaceMD),

              AgroTextField(
                label:      'Confirmar nueva contraseÃ±a',
                controller: confirmCtrl,
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: (v) => AppValidators.validateConfirmPassword(
                    v, newCtrl.text),
              ),
              const SizedBox(height: AppDimens.spaceXL),

              Consumer<ProfileController>(
                builder: (_, ctrl, __) => AgroPrimaryButton(
                  label:     'Guardar contraseÃ±a',
                  isLoading: ctrl.isSaving,
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    ctrl.cambiarPassword(
                      currentPassword: currentCtrl.text,
                      newPassword:     newCtrl.text,
                      onSuccess: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'ContraseÃ±a actualizada correctamente'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                    );
                  },
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmarCierreSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cerrar sesiÃ³n'),
        content:
            const Text('Â¿EstÃ¡s seguro que deseas cerrar sesiÃ³n?'),
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppDimens.radiusMD)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar',
                style:
                    TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              AuthSession.instance.clear();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar sesiÃ³n'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ProfileController>();

    return Scaffold(
      body: Column(
        children: [
          AgroAppBar(titulo: 'Mi Perfil'),

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
                    top:    AppDimens.spaceLG,
                    bottom: 120,
                  ),
                  child: Column(
                    children: [

                      // â”€â”€ Avatar e info principal â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      _AvatarSection(profile: ctrl.profile),
                      const SizedBox(height: AppDimens.spaceXL),

                      // â”€â”€ Formulario â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.pageHorizontalPad),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              // Nombres
                              AgroTextField(
                                label:      'Nombres',
                                controller: _firstNameCtrl,
                                validator:  AppValidators.validateName,
                              ),
                              const SizedBox(height: AppDimens.spaceMD),

                              // Apellidos
                              AgroTextField(
                                label:      'Apellidos',
                                controller: _lastNameCtrl,
                                validator:  AppValidators.validateName,
                              ),
                              const SizedBox(height: AppDimens.spaceMD),

                              // Correo
                              AgroTextField(
                                label:        'Correo',
                                controller:   _emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                validator:    AppValidators.validateEmail,
                              ),
                              const SizedBox(height: AppDimens.spaceMD),

                              // TelÃ©fono
                              AgroTextField(
                                label:        'TelÃ©fono',
                                controller:   _phoneCtrl,
                                keyboardType: TextInputType.phone,
                                hint:         'Ej. +57 300 123 4567',
                                validator: (v) => null,
                              ),
                              const SizedBox(height: AppDimens.spaceMD),

                              // Rol
                              AgroTextField(
                                label:      'Rol / Cargo',
                                controller: _roleCtrl,
                                hint:       'Ej. Administrador',
                                validator: (v) => null,
                              ),
                              const SizedBox(height: AppDimens.spaceMD),

                              // Empresa / Finca
                              AgroTextField(
                                label:      'Empresa / Finca',
                                controller: _empresaCtrl,
                                hint:       'Ej. Finca Verde',
                                textInputAction: TextInputAction.done,
                                validator: (v) => null,
                              ),
                              const SizedBox(height: AppDimens.spaceXL),

                              // â”€â”€ BotÃ³n guardar â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                              AgroPrimaryButton(
                                label:     'Guardar cambios',
                                isLoading: ctrl.isSaving,
                                onPressed: () => _guardar(context),
                                width:     double.infinity,
                              ),
                              const SizedBox(height: AppDimens.spaceMD),

                              // â”€â”€ BotÃ³n cambiar contraseÃ±a â”€â”€â”€â”€â”€â”€â”€
                              SizedBox(
                                width:  double.infinity,
                                height: AppDimens.buttonHeight,
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      _mostrarCambioPassword(context),
                                  icon: const Icon(
                                      Icons.lock_outline,
                                      color: AppColors.primaryDark),
                                  label: const Text(
                                    'Cambiar contraseÃ±a',
                                    style: TextStyle(
                                      color:      AppColors.primaryDark,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: AppColors.primary,
                                        width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppDimens.buttonBorderRadius),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppDimens.spaceMD),

                              // â”€â”€ BotÃ³n cerrar sesiÃ³n â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                              SizedBox(
                                width:  double.infinity,
                                height: AppDimens.buttonHeight,
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      _confirmarCierreSesion(context),
                                  icon: const Icon(
                                      Icons.logout,
                                      color: AppColors.error),
                                  label: const Text(
                                    'Cerrar sesiÃ³n',
                                    style: TextStyle(
                                      color:      AppColors.error,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: AppColors.error,
                                        width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppDimens.buttonBorderRadius),
                                    ),
                                  ),
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
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€ SecciÃ³n avatar â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _AvatarSection extends StatelessWidget {
  const _AvatarSection({required this.profile});
  final dynamic profile;

  @override
  Widget build(BuildContext context) {
    if (profile == null) return const SizedBox.shrink();

    return Column(
      children: [
        // Avatar con iniciales
        Container(
          width:  90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            boxShadow: [
              BoxShadow(
                color:      AppColors.primary.withOpacity(0.3),
                blurRadius: 16,
                offset:     const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              profile.initials,
              style: const TextStyle(
                color:      Colors.white,
                fontSize:   32,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimens.spaceMD),

        // Nombre completo
        Text(
          profile.fullName,
          style: AppTextStyles.headingMedium.copyWith(fontSize: 20),
        ),
        const SizedBox(height: AppDimens.spaceXS),

        // Rol + empresa
        if (profile.role != null || profile.empresa != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (profile.role != null)
                _BadgeChip(label: profile.role!),
              if (profile.role != null && profile.empresa != null)
                const SizedBox(width: AppDimens.spaceSM),
              if (profile.empresa != null)
                _BadgeChip(
                  label:   profile.empresa!,
                  color:   AppColors.accent,
                  txtColor: AppColors.textOnAccent,
                ),
            ],
          ),
      ],
    );
  }
}

// â”€â”€â”€ Badge chip â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _BadgeChip extends StatelessWidget {
  const _BadgeChip({
    required this.label,
    this.color    = AppColors.primary,
    this.txtColor = Colors.white,
  });
  final String label;
  final Color  color;
  final Color  txtColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMD, vertical: AppDimens.spaceXS),
      decoration: BoxDecoration(
        color:        color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        border:       Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color:      color,
          fontSize:   12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}