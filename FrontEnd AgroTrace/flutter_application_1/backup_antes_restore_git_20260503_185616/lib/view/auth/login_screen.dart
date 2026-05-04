// lib/view/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/auth/login_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/app_validators.dart';
import '../widgets/agro_primary_button.dart';
import '../widgets/agro_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<LoginController>().login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          onSuccess: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.home),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
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
              height: 100,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 160),
              child: Column(
                children: [
                  const SizedBox(height: AppDimens.spaceXL),
                  Image.asset(
                    'assets/images/logo_agrotrace.png',
                    height: 160,
                  ),
                  const SizedBox(height: AppDimens.spaceLG),
                  Text(
                    'Iniciar sesion',
                    style: AppTextStyles.displayLarge.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceXL),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.pageHorizontalPad,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          Consumer<LoginController>(
                            builder: (_, ctrl, __) => AgroTextField(
                              label: 'Contrasena',
                              controller: _passwordController,
                              obscureText: ctrl.obscurePassword,
                              textInputAction: TextInputAction.done,
                              validator: AppValidators.validatePassword,
                              autofillHints: const [AutofillHints.password],
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
                          const SizedBox(height: AppDimens.spaceXS),
                          Consumer<LoginController>(
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
                            child: Consumer<LoginController>(
                              builder: (_, ctrl, __) => AgroPrimaryButton(
                                label: 'Entrar',
                                isLoading: ctrl.isLoading,
                                onPressed: () => _submit(context),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimens.spaceMD),
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.pushReplacementNamed(
                                  context, AppRoutes.register),
                              child: RichText(
                                text: TextSpan(
                                  style: AppTextStyles.bodyRegular,
                                  children: const [
                                    TextSpan(text: 'No tienes cuenta? '),
                                    TextSpan(
                                      text: 'Registrate',
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
    ));
  }
}
