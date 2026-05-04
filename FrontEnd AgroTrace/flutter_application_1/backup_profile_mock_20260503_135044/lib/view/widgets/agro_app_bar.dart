// lib/view/widgets/agro_app_bar.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_routes.dart';

class AgroAppBar extends StatelessWidget {
  const AgroAppBar({
    super.key,
    this.titulo,
    this.mostrarMenu   = false,
    this.mostrarPerfil = false,
    this.mostrarAtras  = true,
  });

  final String? titulo;
  final bool    mostrarMenu;
  final bool    mostrarPerfil;
  final bool    mostrarAtras;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Header: pasto + logo ────────────────────────────────────
        Container(
          color: AppColors.background,
          child: Column(
            children: [
              SizedBox(height: topPadding),
              SizedBox(
                height: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width:  120,
                      height: 100,
                      child: Image.asset(
                        'assets/images/grass_bottom.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          'assets/images/logo_agrotrace.png',
                          height: 72,
                        ),
                      ),
                    ),
                    SizedBox(
                      width:  120,
                      height: 100,
                      child: Image.asset(
                        'assets/images/grass_bottom.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Barra marrón pegada al pasto ────────────────────────────
        Transform.translate(
          offset: const Offset(0, -22),
          child: Container(
            color: const Color(0xFF7B5E3A),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.pageHorizontalPad,
              vertical:   AppDimens.spaceMD,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Izquierda: menú o flecha atrás
                if (mostrarMenu)
                  GestureDetector(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: const Icon(Icons.menu,
                        color: Colors.white, size: 28),
                  )
                else if (mostrarAtras)
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 28),
                  )
                else
                  const SizedBox(width: 28),

                // Centro: título
                if (titulo != null)
                  Text(
                    titulo!,
                    style: const TextStyle(
                      color:      Colors.white,
                      fontSize:   16,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  const SizedBox.shrink(),

                // Derecha: perfil o espacio
                if (mostrarPerfil)
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.profile),
                    child: const Icon(Icons.person_outline,
                        color: Colors.white, size: 28),
                  )
                else
                  const SizedBox(width: 28),
              ],
            ),
          ),
        ),
      ],
    );
  }
}