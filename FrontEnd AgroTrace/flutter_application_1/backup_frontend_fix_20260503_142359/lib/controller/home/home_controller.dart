// lib/controller/home/home_controller.dart

import 'package:flutter/foundation.dart';

class HomeController extends ChangeNotifier {
  HomeController();

  // â”€â”€â”€ Estado â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  final String _userName = 'Luis'; // TODO: recibir del UserModel tras login

  // â”€â”€â”€ Getters â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  String get userName => _userName;

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos dÃ­as';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }

  String get greetingEmoji {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'â˜€ï¸';
    if (hour < 18) return 'ðŸŒ¤ï¸';
    return 'ðŸŒ™';
  }

  // â”€â”€â”€ Opciones del menÃº principal â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Agrega o quita opciones aquÃ­ sin tocar la Vista
  List<DashboardOption> get options => const [
        DashboardOption(
          label: 'Registrar Lote',
          emoji: 'ðŸŒ±',
          route: '/registrar-lote',
        ),
        DashboardOption(
          label: 'Empaque',
          emoji: 'ðŸ“¦',
          route: '/empaque',
        ),
        DashboardOption(
          label: 'Inventario',
          emoji: 'ðŸ“Š',
          route: '/inventario',
        ),
        DashboardOption(
          label: 'Generar QR',
          emoji: 'ðŸ“²',
          route: '/generacion-qr',
        ),
        DashboardOption(
          label: 'Escanear QR',
          emoji: 'ðŸ”',
          route: '/escanear-qr',
        ),
        DashboardOption(
          label: 'Merma',
          emoji: 'â—',
          route: '/merma',
        ),
        DashboardOption(
          label: 'Salida',
          emoji: 'ðŸšš',
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
