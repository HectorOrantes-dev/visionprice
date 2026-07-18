/// Posibles estados de seguridad del dispositivo respecto a la ubicación.
enum SecurityStatus {
  /// Dispositivo seguro, sin Fake GPS.
  secure,

  /// Se detectó ubicación simulada (Fake GPS).
  fakeGpsDetected,

  /// Permisos de ubicación denegados o servicio de ubicación apagado.
  permissionDenied,

  /// Se detectó depuración por USB activa.
  usbDebuggingDetected,
}
