import 'package:flutter/foundation.dart';
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
class TokenStorage extends ChangeNotifier {
  static const _kKey = 'access_token';
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  String? _token;

  String? get token => _token;
  bool get hasToken => (_token ?? '').isNotEmpty;

  /// Carga el token persistido a memoria. Llamar una vez al arrancar la app
  /// (antes de decidir si mostrar login o home).
  Future<void> load() async {
    _token = await _storage.read(key: _kKey);
    notifyListeners();
  }

  Future<void> saveToken(String token) async {
    _token = token;
    await _storage.write(key: _kKey, value: token);
    notifyListeners();
  }

  Future<void> clear() async {
    _token = null;
    await _storage.delete(key: _kKey);
    notifyListeners();
  }
}
