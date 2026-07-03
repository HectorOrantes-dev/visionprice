/// Flujo del registro (refleja al del login):
/// - [idle] → estado inicial.
/// - [loading] → petición en curso.
/// - [codeSent] → el back-end registró y mandó el código 2FA al correo.
/// - [success] → 2FA verificado, token guardado.
/// - [error] → ver `errorMessage`.
enum RegisterState { idle, loading, codeSent, success, error }
