import 'package:flutter/foundation.dart' show debugPrint;
import 'package:screen_protector/screen_protector.dart';

/// Protección de pantalla (anti-screenshot / anti-grabación) de la app.
class SecurityChecker {
  /// Activa la protección global de pantalla (Anti-screenshot y Anti-grabación).
  /// En Android pone la pantalla negra en capturas/recientes.
  /// En iOS previene la captura y grabación.
  static Future<void> enableScreenProtection() async {
    try {
      await ScreenProtector.preventScreenshotOn();
      await ScreenProtector.protectDataLeakageOn();
      debugPrint('Seguridad de pantalla: ACTIVADA');
    } catch (e) {
      debugPrint('Error al activar seguridad de pantalla: $e');
    }
  }

  /// Desactiva la protección de pantalla.
  static Future<void> disableScreenProtection() async {
    try {
      await ScreenProtector.preventScreenshotOff();
      await ScreenProtector.protectDataLeakageOff();
      debugPrint('Seguridad de pantalla: DESACTIVADA');
    } catch (e) {
      debugPrint('Error al activar seguridad de pantalla: $e');
    }
  }
}
