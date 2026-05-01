// lib/controller/home/home_controller.dart

import 'package:flutter/foundation.dart';

class HomeController extends ChangeNotifier {
  HomeController();

  // ─── Estado ───────────────────────────────────────────────────────
  final String _userName = 'Daniel'; // TODO: recibir del UserModel tras login

  // ─── Getters ──────────────────────────────────────────────────────
  String get userName => _userName;

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }

  String get greetingEmoji {
    final hour = DateTime.now().hour;
    if (hour < 12) return '☀️';
    if (hour < 18) return '🌤️';
    return '🌙';
  }

  // ─── Opciones del menú principal ──────────────────────────────────
  // Agrega o quita opciones aquí sin tocar la Vista
  List<DashboardOption> get options => const [
        DashboardOption(
          label: 'Registrar Lote',
          emoji: '🌱',
          route: '/registrar-lote',
        ),
        DashboardOption(
          label: 'Empaque',
          emoji: '📦',
          route: '/empaque',
        ),
        DashboardOption(
          label: 'Inventario',
          emoji: '📊',
          route: '/inventario',
        ),
        DashboardOption(
          label: 'Generar QR',
          emoji: '📲',
          route: '/generacion-qr',
        ),
        DashboardOption(
          label: 'Escanear QR',
          emoji: '🔍',
          route: '/escanear-qr',
        ),
        DashboardOption(
          label: 'Merma',
          emoji: '❗',
          route: '/merma',
        ),
        DashboardOption(
          label: 'Salida',
          emoji: '🚚',
          route: '/salida',
        ),
      ];
}

// ─── Modelo simple para cada opción del dashboard ─────────────────────────────
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
