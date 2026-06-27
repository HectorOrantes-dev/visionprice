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

  factory ApiException.network([String? detail]) =>
      ApiException(0, detail ?? 'No hay conexión con el servidor.');

  @override
  String toString() => 'ApiException($statusCode): $message';
}
