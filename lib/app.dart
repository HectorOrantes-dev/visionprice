import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/session/auth_state_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/responsive_app_wrapper.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/security/presentation/screens/usb_debugging_gate.dart';

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
      // Locale que DevicePreview (ver main.dart) deja elegir desde su panel.
      locale: DevicePreview.locale(context),
      // El gateway de Depuración USB envuelve toda la navegación de la app;
      // ResponsiveAppWrapper centra el contenido en pantallas anchas
      // (tablet/escritorio/web) en vez de estirarlo de borde a borde — un
      // solo lugar para que TODAS las pantallas queden responsive, sin tener
      // que tocar cada una por separado. DevicePreview.appBuilder agrega el
      // marco/toolbar del dispositivo simulado alrededor de todo eso.
      builder: (context, child) {
        final content = ResponsiveAppWrapper(
          child: UsbDebuggingGate(child: child ?? const SizedBox.shrink()),
        );
        return DevicePreview.appBuilder(context, content);
      },
      home: loggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
