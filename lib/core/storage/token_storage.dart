import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Almacén del `access_token` JWT con **persistencia segura**
/// (`flutter_secure_storage` → Keystore en Android / Keychain en iOS).
///
/// La sesión **sobrevive al cierre de la app**: al volver a abrir, si hay un
/// token guardado se entra directo sin pedir login otra vez. Para cerrar
/// sesión se usa [clear] (borra el token del almacenamiento seguro).
///
/// Mantiene además una copia en memoria ([_token]) para acceso síncrono desde
/// el [ApiClient] al construir el header `Authorization`.
class TokenStorage extends ChangeNotifier {
  static const _kKey = 'access_token';
  // Desde flutter_secure_storage v10, el cifrado en Android migra solo a un
  // cifrador propio (Jetpack Security/EncryptedSharedPreferences quedó
  // deprecado por Google) — ya no hace falta pedirlo explícitamente.
  static const _storage = FlutterSecureStorage();

  String? _token;
  int? _userId;

  String? get token => _token;
  bool get hasToken => (_token ?? '').isNotEmpty;

  /// El `sub` (id de usuario) del JWT actual, o `null` sin sesión. Se
  /// recalcula cada vez que el token cambia — es la fuente de verdad para
  /// que las cachés locales (SQLite: proyectos, cotizaciones, perfil) sepan
  /// a qué cuenta pertenece cada fila, en vez de mostrarse a cualquiera que
  /// tenga sesión abierta en el mismo dispositivo.
  int? get userId => _userId;

  /// Carga el token persistido a memoria. Llamar una vez al arrancar la app
  /// (antes de decidir si mostrar login o home).
  Future<void> load() async {
    _token = await _storage.read(key: _kKey);
    _userId = _decodeUserId(_token);
    notifyListeners();
  }

  Future<void> saveToken(String token) async {
    _token = token;
    _userId = _decodeUserId(_token);
    await _storage.write(key: _kKey, value: token);
    notifyListeners();
  }

  Future<void> clear() async {
    _token = null;
    _userId = null;
    notifyListeners();
    await _storage.delete(key: _kKey);
  }

  /// Decodifica el claim `sub` del payload del JWT — solo lectura local, sin
  /// verificar firma (no hace falta: es el mismo token que ya autenticó al
  /// backend; aquí únicamente se usa para separar cachés por cuenta).
  static int? _decodeUserId(String? token) {
    if (token == null) return null;
    try {
      final partes = token.split('.');
      if (partes.length != 3) return null;
      final payload =
          utf8.decode(base64Url.decode(base64Url.normalize(partes[1])));
      final claims = jsonDecode(payload) as Map<String, dynamic>;
      final sub = claims['sub'];
      if (sub is int) return sub;
      return int.tryParse('$sub');
    } catch (_) {
      return null;
    }
  }
}
