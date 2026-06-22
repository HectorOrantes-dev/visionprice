import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:safe_device/safe_device.dart';

/// Interruptor SOLO para pruebas / capturas de pantalla.
///
/// - `false` (valor para la ENTREGA): la verificación RASP respeta la excepción
///   de desarrollo y se omite cuando la app corre en modo debug ([kDebugMode]).
/// - `true`: fuerza la verificación incluso en debug, para demostrar el bloqueo
///   sin compilar en release. **Vuelve a `false` antes de entregar.**
const bool kRaspForceCheckInDebug = false;

/// Módulo RASP (Runtime Application Self-Protection) para VisionPrice.
///
/// Detecta si la **Depuración USB (USB Debugging / ADB)** está activa.
/// Mecanismo: el plugin [`safe_device`] consulta de forma nativa el ajuste
/// `Settings.Global.ADB_ENABLED` del sistema.
class RaspChecker {
  RaspChecker._();

  /// Canal nativo SOLO para abrir los ajustes de desarrollador (no forma parte
  /// del mecanismo de detección).
  static const MethodChannel _channel =
      MethodChannel('com.visionprice.vision_price/rasp');

  /// Devuelve `true` únicamente cuando la app corre fuera de desarrollo
  /// (Release) sobre Android **y** la Depuración USB está activa.
  static Future<bool> isUsbDebuggingEnabled() async {
    // 1. Excepción estricta para el entorno de desarrollo local.
    if (kDebugMode && !kRaspForceCheckInDebug) {
      return false;
    }
    // 2. La verificación solo aplica en Android.
    if (defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }
    // 3. Delegar la lectura del estado del sistema en el paquete comunitario.
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
