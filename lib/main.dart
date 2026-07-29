import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/di/token_storage_provider.dart';
import 'features/devices/data/providers/device_providers.dart';
import 'features/security/security_checker.dart';
import 'features/security/services/notification_service.dart';
import 'app.dart';

// Anti-screenshot / anti-grabación de pantalla en toda la app. En `false`
// para poder tomar capturas (pruebas/documentación); `true` para producción.
const bool kScreenProtectionEnabled = false;

// main async para las operaciones de arranque (carga de token, push).
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kScreenProtectionEnabled) {
    SecurityChecker.enableScreenProtection();
  }

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

  // DevicePreview: simula distintos tamaños de pantalla (celular/tablet/
  // escritorio) dentro de una sola ventana, para probar el layout responsive
  // sin tener que abrir cada dispositivo real. Solo en debug — nunca en
  // release, para no meter la barra de herramientas de preview a producción.
  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => UncontrolledProviderScope(
        container: container,
        child: const App(),
      ),
    ),
  );
}
