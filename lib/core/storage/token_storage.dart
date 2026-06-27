import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistencia del `access_token` JWT.
///
/// Registrado como `@lazySingleton`: se crea la primera vez que alguien lo
/// pide y se reutiliza durante toda la vida de la app (mantiene estado → es
/// un buen candidato a singleton, según la guía de Injectable).
///
/// Recibe [SharedPreferences] por inyección; esa instancia la provee
/// `RegisterModule` con `@preResolve` (resuelta antes de `runApp`).
@lazySingleton
class TokenStorage {
  static const _kTokenKey = 'access_token';

  final SharedPreferences _prefs;
  TokenStorage(this._prefs);

  String? get token => _prefs.getString(_kTokenKey);
  bool get hasToken => (token ?? '').isNotEmpty;

  Future<void> saveToken(String token) => _prefs.setString(_kTokenKey, token);
  Future<void> clear() => _prefs.remove(_kTokenKey);
}
