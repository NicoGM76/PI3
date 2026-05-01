// lib/views/auth/register_screen.dart
//
// Vista MVC: solo maneja UI y delega toda la lógica al controller.
// Lee estado con Consumer<RegisterController> / context.watch.
// Navega usando AppRoutes para desacoplar rutas.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/auth/register_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/app_validators.dart';
import '../widgets/agro_primary_button.dart';
import '../widgets/agro_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  // ─── Submit ───────────────────────────────────────────────────────
  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<RegisterController>().register(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          onSuccess: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.home),
        );
  }

  // ─── Build ────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sin AppBar; el diseño tiene el header integrado en el Stack
      body: Stack(
        children: [
          // ── Fondo sage ──────────────────────────────────────────
          Positioned.fill(
            child: Container(color: AppColors.background),
          ),

          // ── Imagen decorativa — pasto inferior ──────────────────
          // DESPUÉS
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/grass_bottom.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 120,
            ),
          ),

          // ── Contenido principal ─────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                bottom: 140, // espacio para el pasto inferior
              ),
              child: Column(
                children: [
                  // ── Logo ──────────────────────────────────────
                  const SizedBox(height: AppDimens.spaceLG),
                  Image.asset(
                    'assets/images/logo_agrotrace.png',
                    height: 160,
                  ),
                  const SizedBox(height: AppDimens.spaceMD),

                  // ── Formulario ────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.pageHorizontalPad,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nombres
                          AgroTextField(
                            label: 'Nombres',
                            controller: _firstNameController,
                            hint: 'Ej. María',
                            validator: AppValidators.validateName,
                            autofillHints: const [AutofillHints.givenName],
                          ),
                          const SizedBox(height: AppDimens.spaceMD),

                          // Apellidos
                          AgroTextField(
                            label: 'Apellidos',
                            controller: _lastNameController,
                            hint: 'Ej. Gómez',
                            validator: AppValidators.validateName,
                            autofillHints: const [AutofillHints.familyName],
                          ),
                          const SizedBox(height: AppDimens.spaceMD),

                          // Correo
                          AgroTextField(
                            label: 'Correo',
                            controller: _emailController,
                            hint: 'ejemplo@correo.com',
                            keyboardType: TextInputType.emailAddress,
                            validator: AppValidators.validateEmail,
                            autofillHints: const [AutofillHints.email],
                          ),
                          const SizedBox(height: AppDimens.spaceMD),

                          // Contraseña
                          Consumer<RegisterController>(
                            builder: (_, ctrl, __) => AgroTextField(
                              label: 'Contraseña',
                              controller: _passwordController,
                              obscureText: ctrl.obscurePassword,
                              validator: AppValidators.validatePassword,
                              autofillHints: const [AutofillHints.newPassword],
                              suffixIcon: IconButton(
                                icon: Icon(
                                  ctrl.obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.textHint,
                                ),
                                onPressed: ctrl.toggleObscurePassword,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimens.spaceMD),

                          // Confirmar contraseña
                          Consumer<RegisterController>(
                            builder: (_, ctrl, __) => AgroTextField(
                              label: 'Confirmar Contraseña',
                              controller: _confirmPassController,
                              obscureText: ctrl.obscureConfirmPassword,
                              textInputAction: TextInputAction.done,
                              validator: (v) =>
                                  AppValidators.validateConfirmPassword(
                                v,
                                _passwordController.text,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  ctrl.obscureConfirmPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.textHint,
                                ),
                                onPressed: ctrl.toggleObscureConfirmPassword,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimens.spaceXS),

                          // ── Error general del servidor ─────────
                          Consumer<RegisterController>(
                            builder: (_, ctrl, __) {
                              if (ctrl.errorMessage == null) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: AppDimens.spaceSM),
                                child: Text(
                                  ctrl.errorMessage!,
                                  style: AppTextStyles.errorText,
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: AppDimens.spaceXL),

                          // ── Botón Registrarse ──────────────────
                          Center(
                            child: Consumer<RegisterController>(
                              builder: (_, ctrl, __) => AgroPrimaryButton(
                                label: 'Registrarse',
                                isLoading: ctrl.isLoading,
                                onPressed: () => _submit(context),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimens.spaceMD),

                          // ── ¿Ya tienes cuenta? ─────────────────
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.pushReplacementNamed(
                                  context, AppRoutes.login),
                              child: RichText(
                                text: TextSpan(
                                  style: AppTextStyles.bodyRegular,
                                  children: const [
                                    TextSpan(text: '¿Ya tienes cuenta? '),
                                    TextSpan(
                                      text: 'Inicia sesión',
                                      style: TextStyle(
                                        color: AppColors.primaryDark,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
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
          ),
        ],
      ),
    );
  }
}
