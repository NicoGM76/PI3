// lib/views/auth/register_screen.dart
//
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: AppColors.background),
          ),
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
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                bottom: 140, // espacio para el pasto inferior
              ),
              child: Column(
                children: [
                  const SizedBox(height: AppDimens.spaceLG),
                  Image.asset(
                    'assets/images/logo_agrotrace.png',
                    height: 160,
                  ),
                  const SizedBox(height: AppDimens.spaceMD),
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
                            hint: 'Ej. Maria',
                            validator: AppValidators.validateName,
                            autofillHints: const [AutofillHints.givenName],
                          ),
                          const SizedBox(height: AppDimens.spaceMD),

                          // Apellidos
                          AgroTextField(
                            label: 'Apellidos',
                            controller: _lastNameController,
                            hint: 'Ej. Gomez',
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

                          // Contrasena
                          Consumer<RegisterController>(
                            builder: (_, ctrl, __) => AgroTextField(
                              label: 'Contrasena',
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

                          // Confirmar Contrasena
                          Consumer<RegisterController>(
                            builder: (_, ctrl, __) => AgroTextField(
                              label: 'Confirmar Contrasena',
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
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.pushReplacementNamed(
                                  context, AppRoutes.login),
                              child: RichText(
                                text: TextSpan(
                                  style: AppTextStyles.bodyRegular,
                                  children: const [
                                    TextSpan(text: 'Ya tienes cuenta? '),
                                    TextSpan(
                                      text: 'Inicia sesion',
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
