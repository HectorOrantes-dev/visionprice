import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/perfil_entity.dart';

/// Persistencia local del perfil del usuario (`SharedPreferences`).
///
/// Hace que los datos de perfil **sobrevivan al cierre de la app** y se puedan
/// mostrar aunque no haya red. Se limpia solo al cerrar sesión.
@lazySingleton
class PerfilStorage {
  static const _kKey = 'perfil_cache';

  final SharedPreferences _prefs;
  PerfilStorage(this._prefs);

  /// Guarda el perfil serializado a JSON.
  Future<void> save(PerfilEntity perfil) async {
    await _prefs.setString(_kKey, jsonEncode(perfil.toJson()));
  }

  /// Lee el perfil guardado (o `null` si no hay / está corrupto).
  PerfilEntity? read() {
    final raw = _prefs.getString(_kKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return PerfilEntity.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    await _prefs.remove(_kKey);
  }
}
