import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Módulo de DI para librerías externas que **no** controla Injectable
/// (no podemos anotar sus clases). Se declara una clase abstracta y el
/// generador implementa los getters.
///
/// - `http.Client`: `@lazySingleton`, una sola instancia reutilizable.
/// - `SharedPreferences`: `@preResolve`, porque su creación es asíncrona
///   (`getInstance()`); con `preResolve` se resuelve durante
///   `configureDependencies()` (antes de `runApp`) y luego se puede pedir de
///   forma síncrona con `getIt<SharedPreferences>()`.
@module
abstract class RegisterModule {
  @lazySingleton
  http.Client get httpClient => http.Client();

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
