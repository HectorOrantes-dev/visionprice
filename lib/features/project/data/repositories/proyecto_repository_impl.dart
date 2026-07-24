import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/storage/local_database.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/proyecto_entity.dart';
import '../../domain/repositories/proyecto_repository.dart';
import '../datasources/proyecto_remote_datasource.dart';

class ProyectoRepositoryImpl implements ProyectoRepository {
  final ProyectoRemoteDataSource _remote;
  final LocalDatabase _localDatabase;
  final TokenStorage _tokenStorage;

  ProyectoRepositoryImpl(this._remote, this._localDatabase, this._tokenStorage);

  /// `proyectos`/`cotizaciones_pdf` son cachés del DISPOSITIVO, no de la
  /// cuenta — cada fila se marca con este id y toda lectura se filtra por
  /// él, para que cambiar de cuenta en el mismo teléfono no mezcle datos.
  int? get _usuarioId => _tokenStorage.userId;

  @override
  Future<List<ProyectoEntity>> listar() async {
    final db = await _localDatabase.database;
    final usuarioId = _usuarioId;
    // Remoto primero, SIEMPRE — antes esto se saltaba la red por completo en
    // cuanto la tabla local tenía una fila, así que una vez creado un solo
    // proyecto la lista dejaba de refrescarse para siempre. Local solo como
    // fallback si de verdad falla la red.
    try {
      final proyectos = await _remote.listar();
      final batch = db.batch();
      for (var p in proyectos) {
        final map = p.toJson();
        map['is_synced'] = 1;
        map['usuario_id'] = usuarioId;
        batch.insert('proyectos', map,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);

      // Incluye los creados offline que aún no se hayan sincronizado.
      return await _leerProyectosLocales(db, usuarioId);
    } catch (e) {
      debugPrint('PROYECTOS ERROR (repo.listar): $e — uso caché local.');
      return await _leerProyectosLocales(db, usuarioId);
    }
  }

  Future<List<ProyectoEntity>> _leerProyectosLocales(
      Database db, int? usuarioId) async {
    final maps = await db.query(
      'proyectos',
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
      orderBy: 'id DESC',
    );
    return maps.map(ProyectoEntity.fromJson).toList();
  }

  @override
  Future<ProyectoEntity> crear({
    required String nombre,
    String? direccion,
    double? latitud,
    double? longitud,
  }) async {
    final usuarioId = _usuarioId;
    try {
      final proyecto = await _remote.crear(
        nombre,
        direccion: direccion,
        latitud: latitud,
        longitud: longitud,
      );
      final db = await _localDatabase.database;
      final map = proyecto.toJson();
      map['is_synced'] = 1;
      map['usuario_id'] = usuarioId;
      await db.insert('proyectos', map,
          conflictAlgorithm: ConflictAlgorithm.replace);
      return proyecto;
    } catch (e) {
      // Creación offline
      final db = await _localDatabase.database;

      // Generamos un ID negativo temporal basado en el tiempo
      final offlineId = -DateTime.now().millisecondsSinceEpoch;

      final offlineProyecto = ProyectoEntity(
        id: offlineId,
        nombre: nombre,
        direccion: direccion,
        estado: 'activo',
        totalPresupuestos: 0,
        latitud: latitud,
        longitud: longitud,
      );

      final map = offlineProyecto.toJson();
      map['is_synced'] = 0; // Pendiente de sincronizar
      map['usuario_id'] = usuarioId;
      await db.insert('proyectos', map);

      return offlineProyecto;
    }
  }

  @override
  Future<ProyectoEntity> actualizarUbicacion({
    required int id,
    required double latitud,
    required double longitud,
  }) async {
    final proyecto = await _remote.actualizarUbicacion(
      id,
      latitud: latitud,
      longitud: longitud,
    );
    final db = await _localDatabase.database;
    final map = proyecto.toJson();
    map['is_synced'] = 1;
    map['usuario_id'] = _usuarioId;
    await db.insert('proyectos', map,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return proyecto;
  }
}
