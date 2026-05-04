// lib/controller/home/home_controller.dart

import 'package:flutter/foundation.dart';

import '../../core/session/auth_session.dart';

class HomeController extends ChangeNotifier {
  HomeController();

  // â”€â”€â”€ Estado â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  String get userName {
    final user = AuthSession.instance.currentUser;
    if (user != null && user.firstName.isNotEmpty) {
      return user.firstName;
    }
    return 'Usuario';
  }

  // â”€â”€â”€ Getters â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return '';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }

  String get greetingEmoji {
    final hour = DateTime.now().hour;
    if (hour < 12) return '';
    if (hour < 18) return '';
    return '';
  }

  // â”€â”€â”€ Opciones del menÃº principal â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Agrega o quita opciones aquÃ­ sin tocar la Vista
  List<DashboardOption> get options => const [
        DashboardOption(
          label: 'Registrar Lote',
          emoji: '',
          route: '/registrar-lote',
        ),
        DashboardOption(
          label: 'Empaque',
          emoji: '',
          route: '/empaque',
        ),
        DashboardOption(
          label: 'Inventario',
          emoji: '',
          route: '/inventario',
        ),
        DashboardOption(
          label: 'Generar QR',
          emoji: '',
          route: '/generacion-qr',
        ),
        DashboardOption(
          label: 'Escanear QR',
          emoji: '',
          route: '/escanear-qr',
        ),
        DashboardOption(
          label: 'Merma',
          emoji: '',
          route: '/merma',
        ),
        DashboardOption(
          label: 'Salida',
          emoji: '',
          route: '/salida',
        ),
      ];
}

// â”€â”€â”€ Modelo simple para cada opciÃ³n del dashboard â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class DashboardOption {
  const DashboardOption({
    required this.label,
    required this.emoji,
    required this.route,
  });

  final String label;
  final String emoji;
  final String route;
}
