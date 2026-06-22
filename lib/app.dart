import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/login_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/recording/presentation/providers/recording_provider.dart';
import 'features/security/presentation/screens/security_gateway.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RecordingViewModel()),
      ],
      child: MaterialApp(
        title: 'VisionPrice',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        // El gateway de seguridad (RASP + Fake GPS) protege la entrada.
        // Va dentro del MaterialApp para tener Directionality y tema.
        home: const SecurityGateway(child: LoginScreen()),
      ),
    );
  }
}
