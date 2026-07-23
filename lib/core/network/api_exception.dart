/// Excepción tipada para los errores de red / API.
///
/// Lleva el [statusCode] para que las capas superiores puedan reaccionar de
/// forma distinta (p. ej. un `404` en Google Login significa "usuario no
/// registrado" → mandar a la pantalla de registro).
class ApiException implements Exception {
  final int statusCode;
  final String message;

  /// `error.code` del cuerpo (p. ej. `"plan_limit_reached"`,
  /// `"plan_required"`) — `null` si el back-end no lo mandó o el cuerpo no
  /// traía ese formato.
  final String? code;

  const ApiException(this.statusCode, this.message, {this.code});

  /// `true` cuando el back-end respondió 404 (recurso/usuario inexistente).
  bool get isNotFound => statusCode == 404;

  /// `true` para fallos de red/timeout (sin respuesta HTTP).
  bool get isNetwork => statusCode == 0;

  /// `true` cuando el back-end respondió 429 (demasiadas peticiones) → conviene
  /// esperar (backoff) antes de reintentar.
  bool get isTooManyRequests => statusCode == 429;

  /// `true` cuando el back-end respondió 402: llegaste al límite del plan
  /// gratis (`plan_limit_reached`) o la función exige suscripción activa
  /// (`plan_required`) — en ambos casos toca mostrar el paywall.
  bool get isPaymentRequired => statusCode == 402;

  factory ApiException.network([String? detail]) => ApiException(
      0, detail ?? 'No se pudo conectar con el servidor. Revisa tu conexión.');

  @override
  String toString() => 'ApiException($statusCode): $message';
}
