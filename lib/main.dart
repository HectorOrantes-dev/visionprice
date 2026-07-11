import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/di/infra_providers.dart';
import 'features/devices/data/providers/device_providers.dart';
import 'features/security/services/notification_service.dart';
import 'app.dart';

// main async para las operaciones de arranque (carga de token, push).
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ProviderContainer de arranque: se reutiliza en la app vía
  // UncontrolledProviderScope, así los singletons (keepAlive) sobreviven.
  final container = ProviderContainer();

  // Carga el token persistido para decidir login vs home (auto-login).
  await container.read(tokenStorageProvider).load();

  // Inicialización segura: si Firebase no está configurado, no rompe.
  await NotificationService.init();

  // Si ya había sesión (auto-login), registra el device token para push.
  if (container.read(tokenStorageProvider).hasToken) {
    container.read(deviceRegistrarProvider).register();
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
}
