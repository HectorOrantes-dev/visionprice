import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/security/presentation/pages/security_gateway_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  runApp(
    const ProviderScope(
      child: VisionPriceApp(),
    ),
  );
}

class VisionPriceApp extends StatelessWidget {
  const VisionPriceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SecurityGatewayPage(
      child: MaterialApp.router(
        title: 'VisionPrice',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        routerConfig: appRouter,
      ),
    );
  }
}
