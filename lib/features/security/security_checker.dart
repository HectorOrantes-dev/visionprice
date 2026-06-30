import 'dart:async';

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, debugPrint;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screen_protector/screen_protector.dart';

/// Posibles estados de seguridad del dispositivo respecto a la ubicación.
enum SecurityStatus {
  /// Dispositivo seguro, sin Fake GPS.
  secure,

  /// Se detectó ubicación simulada (Fake GPS).
  fakeGpsDetected,

  /// Permisos de ubicación denegados o servicio de ubicación apagado.
  permissionDenied,
}

/// Audita la seguridad del dispositivo respecto a la ubicación (Anti Fake-GPS).
class SecurityChecker {
  static const Duration _locationTimeout = Duration(seconds: 10);

  /// Comprobación integral:
  /// 1. Permiso de ubicación.
  /// 2. Servicio de ubicación activo.
  /// 3. Pide una ubicación **fresca** (no cacheada) y revisa `isMocked`.
  static Future<SecurityStatus> checkDeviceSecurity() async {
    // En web/escritorio la detección de Fake GPS no aplica: se considera seguro.
    if (defaultTargetPlatform != TargetPlatform.android) {
      return SecurityStatus.secure;
    }
    try {
      PermissionStatus permissionStatus = await Permission.location.status;
      if (permissionStatus.isDenied) {
        permissionStatus = await Permission.location.request();
      }
      if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
        return SecurityStatus.permissionDenied;
      }

      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return SecurityStatus.permissionDenied;
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: _buildLocationSettings(),
      );

      if (position.isMocked) {
        return SecurityStatus.fakeGpsDetected;
      }
      return SecurityStatus.secure;
    } on TimeoutException catch (_) {
      debugPrint('Fake GPS: tiempo de espera agotado al obtener ubicación.');
      return SecurityStatus.secure;
    } on LocationServiceDisabledException catch (_) {
      return SecurityStatus.permissionDenied;
    } on PermissionDeniedException catch (_) {
      return SecurityStatus.permissionDenied;
    } catch (e) {
      debugPrint('Error en verificación de Fake GPS: $e');
      return SecurityStatus.secure;
    }
  }

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
      debugPrint('Error al desactivar seguridad de pantalla: $e');
    }
  }

  static LocationSettings _buildLocationSettings() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidSettings(
        accuracy: LocationAccuracy.medium,
        forceLocationManager: true,
        timeLimit: _locationTimeout,
      );
    }
    return const LocationSettings(
      accuracy: LocationAccuracy.medium,
      timeLimit: _locationTimeout,
    );
  }
}
