import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Punto de entrada de la aplicación VisionPrice.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa GetIt + Injectable — registra todas las dependencias
  await configureDependencies();

  runApp(
    // ProviderScope envuelve toda la app para Riverpod
    const ProviderScope(
      child: VisionPriceApp(),
    ),
  );
}

class VisionPriceApp extends StatelessWidget {
  const VisionPriceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'VisionPrice',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
