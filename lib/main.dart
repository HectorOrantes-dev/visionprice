import 'package:flutter/material.dart';
import 'core/di/injector.dart';
import 'features/security/services/notification_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  // Inicialización segura: si Firebase no está configurado, no rompe.
  await NotificationService.init();
  runApp(const App());
}
