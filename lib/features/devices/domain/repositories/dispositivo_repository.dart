abstract class DispositivoRepository {
  /// Registra el device token FCM en el back-end (para push).
  Future<void> registrar({required String token, required String plataforma});

  /// Borra el device token (al cerrar sesión).
  Future<void> borrar({required String token});
}
