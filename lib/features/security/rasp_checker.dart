import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:safe_device/safe_device.dart';

/// Interruptor SOLO para pruebas / capturas de pantalla.
///
/// - `true`: la verificación RASP corre SIEMPRE, incluso en modo debug — así el
///   bloqueo por Depuración USB se ve también corriendo desde el IDE.
/// - `false`: la verificación se omite en debug ([kDebugMode]) para poder
///   desarrollar por USB sin quedar bloqueado.
///
/// Solo tiene efecto en debug: en release ([kDebugMode] == false) la
/// verificación corre siempre, independientemente de este valor.
const bool kRaspForceCheckInDebug = true;

/// Módulo RASP (Runtime Application Self-Protection) para VisionPrice.
///
/// Detecta si la **Depuración USB (USB Debugging / ADB)** está activa.
/// Mecanismo: lee de forma nativa `Settings.Global.ADB_ENABLED` a través del
/// canal `rasp` (autoritativo); si el canal fallara, cae en el plugin
/// [`safe_device`] como respaldo.
class RaspChecker {
  RaspChecker._();

  /// Canal nativo hacia [MainActivity]: lectura de ADB y abrir ajustes.
  static const MethodChannel _channel =
      MethodChannel('com.visionprice.vision_price/rasp');

  /// Devuelve `true` cuando la app corre sobre Android **y** la Depuración USB
  /// está activa. En debug respeta [kRaspForceCheckInDebug].
  static Future<bool> isUsbDebuggingEnabled() async {
    // 1. Excepción de desarrollo (solo si se desactiva el chequeo en debug).
    if (kDebugMode && !kRaspForceCheckInDebug) {
      return false;
    }
    // 2. La verificación solo aplica en Android.
    if (defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }
    // 3. Lectura nativa directa de ADB_ENABLED (fuente autoritativa).
    try {
      final enabled =
          await _channel.invokeMethod<bool>('isUsbDebuggingEnabled');
      if (enabled != null) return enabled;
    } catch (e) {
      debugPrint('RASP: canal nativo no disponible, uso safe_device -> $e');
    }
    // 4. Respaldo: plugin comunitario.
    try {
      return await SafeDevice.isUsbDebuggingEnabled;
    } catch (e) {
      debugPrint('RASP: error al consultar safe_device -> $e');
      return false;
    }
  }

  /// Abre las "Opciones de desarrollador" para que el usuario desactive la
  /// Depuración por USB sin salir manualmente de la app.
  static Future<void> openDeveloperSettings() async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _channel.invokeMethod<bool>('openDeveloperSettings');
    } on PlatformException catch (e) {
      debugPrint('RASP: no se pudo abrir Ajustes -> $e');
    } on MissingPluginException catch (e) {
      debugPrint('RASP: canal de navegación no disponible -> $e');
    }
  }
}
