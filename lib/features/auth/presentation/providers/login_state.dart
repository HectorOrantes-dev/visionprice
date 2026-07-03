/// Flujo del login:
/// - [idle] → estado inicial.
/// - [loading] → petición en curso.
/// - [codeSent] → el back-end mandó el código 2FA al correo (paso 1 ok).
/// - [success] → 2FA verificado, token guardado.
/// - [error] → ver `errorMessage`.
enum LoginState { idle, loading, codeSent, success, error }
