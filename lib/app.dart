import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/session/auth_state_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Auto-login: si hay un token guardado (sesión previa), entra directo a
    // Home; si no, muestra el login. Si caduca, este valor cambia y resetea la app.
    final loggedIn = ref.watch(authStateProvider);

    return MaterialApp(
      key: ValueKey(loggedIn),
      title: 'VisionPrice',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // Toda la UI usa `context.colors`, así que el modo oscuro aplica de punta
      // a punta. Sigue el ajuste del sistema; el claro queda idéntico al actual.
      themeMode: ThemeMode.system,
      home: loggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
