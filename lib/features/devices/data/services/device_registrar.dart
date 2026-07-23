import 'dart:io' show Platform;

import '../../../security/services/notification_service.dart';
import '../../domain/usecases/dispositivo_usecases.dart';

/// Orquesta el registro/baja del device token FCM contra el back-end.
/// `@lazySingleton`. Se llama tras iniciar sesión ([register]) y al cerrar
/// sesión ([unregister]). Nunca lanza (el push es best-effort).
class DeviceRegistrar {
  final RegistrarDispositivoUseCase _registrar;
  final BorrarDispositivoUseCase _borrar;

  DeviceRegistrar(this._registrar, this._borrar);

  String get _plataforma => Platform.isIOS ? 'ios' : 'android';

  Future<void> register() async {
    try {
      final token = await NotificationService.getToken();
      if (token == null || token.isEmpty) return;
      await _registrar(token: token, plataforma: _plataforma);
    } catch (_) {/* best-effort */}
  }

  Future<void> unregister() async {
    try {
      final token = await NotificationService.getToken();
      if (token == null || token.isEmpty) return;
      await _borrar(token: token);
    } catch (_) {/* best-effort */}
  }
}
