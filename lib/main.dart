import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'core/di/injector.dart';
import 'core/storage/token_storage.dart';
import 'features/devices/data/services/device_registrar.dart';
import 'features/security/services/notification_service.dart';
import 'app.dart';

// crear a main async para operaciones concurrentes
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  // Carga el token persistido para decidir login vs home (auto-login).
  await getIt<TokenStorage>().load();
  // Inicialización segura: si Firebase no está configurado, no rompe.
  await NotificationService.init();
  // Si ya había sesión (auto-login), registra el device token para push.
  if (getIt<TokenStorage>().hasToken) {
    getIt<DeviceRegistrar>().register();
  }
  // DevicePreview solo en debug: permite ver la app en distintos dispositivos
  // y orientaciones sin recompilar. En release corre la App directamente.
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (_) => const App(),
    ),
  );
}
