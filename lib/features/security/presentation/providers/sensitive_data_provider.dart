import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sensitive_data_provider.g.dart';

/// Claves en SharedPreferences → etiqueta visible de cada dato sensible.
const _campos = {
  'sensitive_email': 'Correo',
  'sensitive_token': 'Token de sesión',
  'sensitive_card': 'Tarjeta',
  'sensitive_key': 'Clave privada',
};

/// AsyncNotifier de los datos sensibles guardados en local (SharedPreferences).
/// `build()` los lee y Riverpod los expone como `AsyncValue<Map<label,valor>>`.
/// La señal remota WIPE_DATA se refleja invalidando este provider (la pantalla
/// lo hace en su callback `onWipe`).
@riverpod
class SensitiveData extends _$SensitiveData {
  @override
  Future<Map<String, String>> build() => _leer();

  Future<Map<String, String>> _leer() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      for (final e in _campos.entries)
        e.value: prefs.getString(e.key) ?? 'Vacío',
    };
  }

  /// Guarda los 4 campos en local y recarga la lista (AsyncData nuevo).
  Future<void> guardar({
    required String email,
    required String token,
    required String card,
    required String key,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sensitive_email', email);
    await prefs.setString('sensitive_token', token);
    await prefs.setString('sensitive_card', card);
    await prefs.setString('sensitive_key', key);
    state = AsyncData(await _leer());
  }
}
