// lib/view/widgets/agro_drawer.dart
//
// Se usa en HomeScreen y en todas las pantallas internas.
// Para abrirlo: Scaffold.of(context).openDrawer()

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_text_styles.dart';

class AgroDrawer extends StatefulWidget {
  const AgroDrawer({super.key});

  @override
  State<AgroDrawer> createState() => _AgroDrawerState();
}

class _AgroDrawerState extends State<AgroDrawer> {
  bool _qrExpanded = false;

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    return Drawer(
      backgroundColor: const Color(0xFF8D6E63),
      child: Column(
        children: [
          _DrawerHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                vertical:   AppDimens.spaceMD,
              ),
              children: [
                // Inicio
                _DrawerItem(
                  emoji: '',
                  label:    'Inicio',
                  isActive: currentRoute == AppRoutes.home,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.home,
                      (route) => false,
                    );
                  },
                ),

                // Inventario
                _DrawerItem(
                  emoji: '',
                  label:    'Inventario',
                  isActive: currentRoute == AppRoutes.inventario,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.inventario);
                  },
                ),
                _DrawerExpandable(
                  emoji: '',
                  label:      'QR',
                  isExpanded: _qrExpanded,
                  onTap: () =>
                      setState(() => _qrExpanded = !_qrExpanded),
                  children: [
                    _DrawerSubItem(
                      emoji: '',
                      label: 'Generar QR',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                            context, AppRoutes.generacionQr);
                      },
                    ),
                    _DrawerSubItem(
                      emoji: '',
                      label: 'Escanear QR',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                            context, AppRoutes.escanearQr);
                      },
                    ),
                  ],
                ),

                // Lotes
                _DrawerItem(
                  emoji: '',
                  label:    'Lotes',
                  isActive: currentRoute == AppRoutes.registrarLote,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                        context, AppRoutes.registrarLote);
                  },
                ),

                // Perfil
                _DrawerItem(
                  emoji: '',
                  label:    'Perfil',
                  isActive: currentRoute == AppRoutes.profile,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.profile);
                  },
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.pageHorizontalPad,
                    vertical:   AppDimens.spaceSM,
                  ),
                  child: Divider(color: Colors.white24, thickness: 1),
                ),

                // Cerrar sesion
                _DrawerItem(
                  emoji: '',
                  label:    'Cerrar sesion',
                  isActive: false,
                  textColor: Colors.redAccent.shade100,
                  onTap: () => _confirmarCierreSesion(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.spaceLG),
            child: Text(
              'AgroTrace v1.0.0',
              style: AppTextStyles.bodyRegular.copyWith(
                color:    Colors.white38,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmarCierreSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cerrar sesion'),
        content: const Text('Estas seguro que deseas cerrar sesion?'),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMD)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // cierra el dialog
              Navigator.pop(context); // cierra el drawer
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
            child: const Text('Cerrar sesion'),
          ),
        ],
      ),
    );
  }
}
class _DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      color: const Color(0xFF5D4037),
      padding: EdgeInsets.only(
        top:    topPadding + AppDimens.spaceMD,
        bottom: AppDimens.spaceMD,
        left:   AppDimens.pageHorizontalPad,
        right:  AppDimens.pageHorizontalPad,
      ),
      child: Row(
        children: [
          Image.asset('assets/images/logo_agrotrace.png', height: 40),
          const SizedBox(width: AppDimens.spaceMD),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AgroTrace',
                style: TextStyle(
                  color:      Colors.white,
                  fontSize:   18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Trazabilidad agricola',
                style: TextStyle(
                  color:    Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.emoji,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.textColor,
  });

  final String        emoji;
  final String        label;
  final bool          isActive;
  final VoidCallback  onTap;
  final Color?        textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMD,
        vertical:   AppDimens.spaceXS,
      ),
      decoration: BoxDecoration(
        color:        isActive
            ? Colors.white.withOpacity(0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
      ),
      child: ListTile(
        leading: Text(emoji,
            style: const TextStyle(fontSize: 22)),
        title: Text(
          label,
          style: TextStyle(
            color:      textColor ?? Colors.white,
            fontSize:   16,
            fontWeight: isActive
                ? FontWeight.w600
                : FontWeight.w400,
          ),
        ),
        trailing: isActive
            ? Container(
                width:  4,
                height: 24,
                decoration: BoxDecoration(
                  color:        AppColors.accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              )
            : null,
        onTap: onTap,
        dense: true,
      ),
    );
  }
}
class _DrawerExpandable extends StatelessWidget {
  const _DrawerExpandable({
    required this.emoji,
    required this.label,
    required this.isExpanded,
    required this.onTap,
    required this.children,
  });

  final String        emoji;
  final String        label;
  final bool          isExpanded;
  final VoidCallback  onTap;
  final List<Widget>  children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMD,
            vertical:   AppDimens.spaceXS,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radiusMD),
          ),
          child: ListTile(
            leading: Text(emoji,
                style: const TextStyle(fontSize: 22)),
            title: Text(
              label,
              style: const TextStyle(
                color:    Colors.white,
                fontSize: 16,
              ),
            ),
            trailing: Icon(
              isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: Colors.white70,
            ),
            onTap: onTap,
            dense: true,
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: AppDimens.spaceXL),
            child: Column(children: children),
          ),
      ],
    );
  }
}
class _DrawerSubItem extends StatelessWidget {
  const _DrawerSubItem({
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  final String       emoji;
  final String       label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(emoji,
          style: const TextStyle(fontSize: 18)),
      title: Text(
        label,
        style: const TextStyle(
          color:    Colors.white70,
          fontSize: 14,
        ),
      ),
      onTap:  onTap,
      dense:  true,
    );
  }
}