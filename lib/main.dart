import 'package:flutter/material.dart';
import 'core/di/injector.dart';
import 'core/storage/token_storage.dart';
import 'features/security/services/notification_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  // Carga el token persistido para decidir login vs home (auto-login).
  await getIt<TokenStorage>().load();
  // Inicialización segura: si Firebase no está configurado, no rompe.
  await NotificationService.init();
  runApp(const App());
}
