// lib/view/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/home/home_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_text_styles.dart';
import '../widgets/agro_app_bar.dart';
import '../widgets/agro_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<HomeController>();

    return Scaffold(
      drawer: const AgroDrawer(),
      body: Column(
        children: [
          // ── Header + navbar compartido ───────────────────────────
          AgroAppBar(
            mostrarMenu:   true,
            mostrarPerfil: true,
            mostrarAtras:  false,
          ),

          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(color: AppColors.background),
                ),
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
                    bottom: 120,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left:   AppDimens.pageHorizontalPad,
                          bottom: AppDimens.spaceXL,
                        ),
                        child: Row(
                          children: [
                            Text(ctrl.greetingEmoji,
                                style: const TextStyle(fontSize: 32)),
                            const SizedBox(width: AppDimens.spaceMD),
                            Text(
                              '${ctrl.greeting}, ${ctrl.userName}',
                              style: AppTextStyles.headingMedium,
                            ),
                          ],
                        ),
                      ),
                      ...ctrl.options.map(
                        (option) => _DashboardButton(option: option),
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

class _DashboardButton extends StatelessWidget {
  const _DashboardButton({required this.option});
  final DashboardOption option;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.pageHorizontalPad,
        vertical:   AppDimens.spaceSM,
      ),
      child: SizedBox(
        width:  double.infinity,
        height: AppDimens.buttonHeight + 8,
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, option.route),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.textOnAccent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.buttonBorderRadius),
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceLG),
          ),
          child: Row(
            children: [
              Text(option.emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: AppDimens.spaceMD),
              Text(option.label,
                  style: AppTextStyles.buttonText.copyWith(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}