import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/security/presentation/screens/security_gateway.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Los ViewModels se resuelven por pantalla desde la DI automatizada
    // (getIt), cada uno provisto localmente con ChangeNotifierProvider.
    return MaterialApp(
      title: 'VisionPrice',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // El gateway de seguridad (RASP + Fake GPS) protege la entrada.
      // Va dentro del MaterialApp para tener Directionality y tema.
      home: const SecurityGateway(child: LoginScreen()),
    );
  }
}
