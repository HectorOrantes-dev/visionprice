import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../devices/data/providers/device_providers.dart';
import '../../../security/presentation/screens/inactivity_detector.dart';
import '../../../sync/presentation/screens/sync_queue_screen.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/dashboard_tab.dart';
import '../widgets/mis_obras_tab.dart';
import '../widgets/perfil_tab.dart';

/// Shell de la zona autenticada: navegación inferior entre Inicio, Mis Obras,
/// Sync y Perfil, protegida por el detector de inactividad.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    await Permission.location.request();
  }

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
    final deviceRegistrar = ref.read(deviceRegistrarProvider);
    final logoutUseCase = ref.read(logoutUseCaseProvider);
    () async {
      await deviceRegistrar.unregister();
      await logoutUseCase.call();
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
        backgroundColor: context.colors.background,
        body: _currentIndex == 3
            ? PerfilTab(onLogout: () => _logout())
            : _pages[_currentIndex],
        bottomNavigationBar: BottomNav(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
        ),
      ),
    );
  }
}
