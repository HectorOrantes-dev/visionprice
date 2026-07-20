/// Excepción tipada para los errores de red / API.
///
/// Lleva el [statusCode] para que las capas superiores puedan reaccionar de
/// forma distinta (p. ej. un `404` en Google Login significa "usuario no
/// registrado" → mandar a la pantalla de registro).
class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException(this.statusCode, this.message);

  /// `true` cuando el back-end respondió 404 (recurso/usuario inexistente).
  bool get isNotFound => statusCode == 404;

  /// `true` para fallos de red/timeout (sin respuesta HTTP).
  bool get isNetwork => statusCode == 0;

  /// `true` cuando el back-end respondió 429 (demasiadas peticiones) → conviene
  /// esperar (backoff) antes de reintentar.
  bool get isTooManyRequests => statusCode == 429;

  factory ApiException.network([String? detail]) => ApiException(
      0, detail ?? 'No se pudo conectar con el servidor. Revisa tu conexión.');

  @override
  String toString() => 'ApiException($statusCode): $message';
}
