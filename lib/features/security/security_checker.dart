import 'dart:async';

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, debugPrint;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

enum SecurityStatus {
  secure,
  fakeGpsDetected,
  permissionDenied,
}

class SecurityChecker {
  static const Duration _locationTimeout = Duration(seconds: 10);

  static Future<SecurityStatus> checkDeviceSecurity() async {
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
      debugPrint('Verificación Fake GPS: tiempo agotado.');
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
