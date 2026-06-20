import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:safe_device/safe_device.dart';

const bool kRaspForceCheckInDebug = false;

class RaspChecker {
  RaspChecker._();

  static const MethodChannel _channel =
      MethodChannel('com.visionprice.vision_price/rasp');

  static Future<bool> isUsbDebuggingEnabled() async {
    if (kDebugMode && !kRaspForceCheckInDebug) {
      return false;
    }

    if (defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }

    try {
      return await SafeDevice.isUsbDebuggingEnabled;
    } catch (e) {
      debugPrint('RASP: error al consultar safe_device -> $e');
      return false;
    }
  }

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
