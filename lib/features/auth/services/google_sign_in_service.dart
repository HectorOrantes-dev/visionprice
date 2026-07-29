import 'package:google_sign_in/google_sign_in.dart';

/// Envoltura fina sobre `google_sign_in` (API v7: `GoogleSignIn.instance`).
///
/// En Android, mientras `google-services.json` tenga un cliente OAuth *web*
/// (se genera solo al activar "Google" como proveedor en Firebase
/// Authentication), no hace falta pasar ningún `clientId` aquí — por eso
/// [initialize] no recibe parámetros.
class GoogleSignInService {
  GoogleSignInService._();

  /// Se guarda el `Future` en sí (no un `bool` puesto en `true` DESPUÉS del
  /// `await`) — con un `bool`, dos llamadas casi simultáneas (doble tap en
  /// "Google", o reintentar rápido) ven `_initialized == false` las dos y
  /// ambas llaman a `GoogleSignIn.instance.initialize()`, que en la segunda
  /// vez truena con "Bad state: init() has already been called." Cacheando
  /// el `Future`, la segunda llamada espera la MISMA inicialización en vez
  /// de disparar una nueva.
  static Future<void>? _initFuture;

  static Future<void> initialize() {
    return _initFuture ??= GoogleSignIn.instance.initialize().catchError((e) {
      // Si falla, se limpia el caché para poder reintentar en la próxima
      // llamada en vez de quedar atascado con un Future ya fallido.
      _initFuture = null;
      throw e;
    });
  }

  /// Abre el selector de cuenta de Google y devuelve el `idToken` (el mismo
  /// que espera el back-end en `POST /auth/google/login|register`).
  ///
  /// Devuelve `null` si el usuario canceló el selector (no es un error).
  /// Lanza [Exception] con un mensaje legible para cualquier otro fallo.
  static Future<String?> signIn() async {
    await initialize();
    try {
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw Exception(
            'Google no devolvió un token válido. Intenta de nuevo.');
      }
      return idToken;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      throw Exception(
          'No se pudo iniciar sesión con Google: ${e.description ?? e.code}');
    }
  }

  static Future<void> signOut() => GoogleSignIn.instance.signOut();
}
