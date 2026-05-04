// lib/controller/home/home_controller.dart

import 'package:flutter/foundation.dart';

class DashboardOption {
  const DashboardOption({
    required this.title,
    required this.subtitle,
    required this.route,
    this.emoji = '',
  });

  final String title;
  final String subtitle;
  final String route;
  final String emoji;

  String get routeName => route;
}

class HomeController extends ChangeNotifier {
  String get greeting {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Buenos dias';
    }

    if (hour < 18) {
      return 'Buenas tardes';
    }

    return 'Buenas noches';
  }

  String get saludo => greeting;

  String get greetingIcon => '';

  String get iconoSaludo => greetingIcon;

  final List<DashboardOption> options = const [
    DashboardOption(
      title: 'Registrar Lote',
      subtitle: 'Crear y consultar lotes agricolas',
      route: '/lotes',
    ),
    DashboardOption(
      title: 'Inventario',
      subtitle: 'Consultar paquetes y existencias',
      route: '/inventario',
    ),
    DashboardOption(
      title: 'Estadisticas',
      subtitle: 'Resumen general del sistema',
      route: '/estadisticas',
    ),
    DashboardOption(
      title: 'Escanear QR',
      subtitle: 'Consultar trazabilidad por codigo QR',
      route: '/qr',
    ),
    DashboardOption(
      title: 'Mermas',
      subtitle: 'Registrar perdidas o novedades',
      route: '/mermas',
    ),
    DashboardOption(
      title: 'Perfil',
      subtitle: 'Consultar informacion del usuario',
      route: '/perfil',
    ),
  ];

  List<DashboardOption> get dashboardOptions => options;
}