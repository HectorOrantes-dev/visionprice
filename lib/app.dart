import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'core/di/injector.dart';
import 'core/storage/token_storage.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/security/presentation/screens/security_gateway.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: getIt<TokenStorage>(),
      builder: (context, _) {
        // Auto-login: si hay un token guardado (sesión previa), entra directo a
        // Home; si no, muestra el login. Si caduca, este valor cambia y resetea la app.
        final loggedIn = getIt<TokenStorage>().hasToken;

        return MaterialApp(
          key: ValueKey(loggedIn),
          title: 'VisionPrice',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          // Integración con DevicePreview (activo solo en debug desde main()).
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          // El gateway de seguridad (RASP + Fake GPS) protege la entrada.
          home: SecurityGateway(
            child: loggedIn ? const HomeScreen() : const LoginScreen(),
          ),
        );
      },
    );
  }
}
