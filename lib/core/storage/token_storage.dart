import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Almacén del `access_token` JWT con **persistencia segura**
/// (`flutter_secure_storage` → Keystore en Android / Keychain en iOS).
///
/// La sesión **sobrevive al cierre de la app**: al volver a abrir, si hay un
/// token guardado se entra directo sin pedir login otra vez. Para cerrar
/// sesión se usa [clear] (borra el token del almacenamiento seguro).
///
/// Mantiene además una copia en memoria ([_token]) para acceso síncrono desde
/// el [ApiClient] al construir el header `Authorization`.
@lazySingleton
class TokenStorage {
  static const _kKey = 'access_token';
  static const _kRefreshKey = 'refresh_token';
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  String? _token;
  String? _refreshToken;

  String? get token => _token;
  bool get hasToken => (_token ?? '').isNotEmpty;

  /// Refresh token (larga vida) para renovar el access token sin re-login.
  String? get refreshToken => _refreshToken;
  bool get hasRefreshToken => (_refreshToken ?? '').isNotEmpty;

  /// Carga los tokens persistidos a memoria. Llamar una vez al arrancar la app
  /// (antes de decidir si mostrar login o home). Si la lectura del almacén
  /// seguro falla (p. ej. error de descifrado en algunos Android), no rompe el
  /// arranque: deja los tokens en `null` y la app pedirá login.
  Future<void> load() async {
    try {
      _token = await _storage.read(key: _kKey);
      _refreshToken = await _storage.read(key: _kRefreshKey);
    } catch (_) {
      _token = null;
      _refreshToken = null;
    }
  }

  Future<void> saveToken(String token) async {
    _token = token;
    await _storage.write(key: _kKey, value: token);
  }

  /// Guarda access + refresh token juntos (tras login/verify o /auth/refresh).
  /// Si [refreshToken] es `null`, conserva el refresh actual.
  Future<void> saveSession(String accessToken, [String? refreshToken]) async {
    _token = accessToken;
    await _storage.write(key: _kKey, value: accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      _refreshToken = refreshToken;
      await _storage.write(key: _kRefreshKey, value: refreshToken);
    }
  }

  Future<void> clear() async {
    _token = null;
    _refreshToken = null;
    await _storage.delete(key: _kKey);
    await _storage.delete(key: _kRefreshKey);
  }
}
