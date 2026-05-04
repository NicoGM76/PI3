import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'controller/auth/register_controller.dart';
import 'controller/auth/login_controller.dart';
import 'controller/home/home_controller.dart';
import 'controller/lote/lote_controller.dart';
import 'controller/empaque/empaque_controller.dart';
import 'controller/qr/qr_controller.dart';
import 'controller/qr/scan_qr_controller.dart';
import 'controller/inventario/inventario_controller.dart';
import 'controller/salida/salida_controller.dart';
import 'controller/merma/merma_controller.dart';
import 'controller/profile/profile_controller.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'view/auth/register_screen.dart';
import 'view/auth/login_screen.dart';
import 'view/home/home_screen.dart';
import 'view/lote/registrar_lote_screen.dart';
import 'view/empaque/empaque_screen.dart';
import 'view/qr/generacion_qr_screen.dart';
import 'view/qr/escanear_qr_screen.dart';
import 'view/inventario/inventario_screen.dart';
import 'view/salida/salida_screen.dart';
import 'view/merma/merma_screen.dart';
import 'view/profile/profile_screen.dart';

void main() {
  runApp(const AgroTraceApp());
}

class AgroTraceApp extends StatelessWidget {
  const AgroTraceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterController()),
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => LoteController()),
        ChangeNotifierProvider(create: (_) => EmpaqueController()),
        ChangeNotifierProvider(create: (_) => QrController()),
        ChangeNotifierProvider(create: (_) => ScanQrController()),
        ChangeNotifierProvider(create: (_) => InventarioController()),
        ChangeNotifierProvider(create: (_) => SalidaController()),
        ChangeNotifierProvider(create: (_) => MermaController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
      ],
      child: MaterialApp(
        title: 'AgroTrace',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.login,
        locale: const Locale('es', 'CO'),
        supportedLocales: const [
          Locale('es', 'CO'),
          Locale('en', 'US'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routes: {
          AppRoutes.register:      (_) => const RegisterScreen(),
          AppRoutes.login:         (_) => const LoginScreen(),
          AppRoutes.home:          (_) => const HomeScreen(),
          AppRoutes.registrarLote: (_) => const RegistrarLoteScreen(),
          AppRoutes.empaque:       (_) => const EmpaqueScreen(),
          AppRoutes.generacionQr:  (_) => const GeneracionQrScreen(),
          AppRoutes.escanearQr:    (_) => const EscanearQrScreen(),
          AppRoutes.inventario:    (_) => const InventarioScreen(),
          AppRoutes.salida:        (_) => const SalidaScreen(),
          AppRoutes.merma:         (_) => const MermaScreen(),
          AppRoutes.profile:       (_) => const ProfileScreen(),
        },
      ),
    );
  }
}