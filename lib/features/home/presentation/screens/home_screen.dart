import 'package:flutter/material.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../sync/presentation/screens/sync_queue_screen.dart';
import '../../../security/presentation/screens/inactivity_detector.dart';
import '../../../auth/domain/usecases/auth_usecases.dart';
import '../../../devices/data/services/device_registrar.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../widgets/dashboard_tab.dart';
import '../widgets/home_bottom_nav.dart';
import '../widgets/mis_obras_tab.dart';
import '../widgets/perfil_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardTab(),
    MisObrasTab(),
    SyncQueueScreen(),
    SizedBox.shrink(), // index 3 (Perfil) se construye con onLogout en build()
  ];

  /// Cierra la sesión y regresa al login limpiando la pila de navegación.
  void _logout({String? reason}) {
    final messenger = ScaffoldMessenger.of(context);
    // Borra el device token de push y limpia la sesión (token + caché perfil).
    // Se hace en orden: unregister primero (necesita el JWT) y luego logout.
    () async {
      await getIt<DeviceRegistrar>().unregister();
      await getIt<LogoutUseCase>().call();
    }();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
    if (reason != null) {
      messenger.showSnackBar(SnackBar(content: Text(reason)));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Toda la zona autenticada queda protegida por el detector de inactividad.
    return InactivityDetector(
      onTimeout: () => _logout(reason: 'Sesión cerrada por inactividad.'),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: _currentIndex == 3
            ? PerfilTab(onLogout: () => _logout())
            : _pages[_currentIndex],
        bottomNavigationBar: HomeBottomNav(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
        ),
      ),
    );
  }
}
