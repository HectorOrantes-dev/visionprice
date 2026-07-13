import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/storage/local_database.dart';
import '../../domain/entities/proyecto_entity.dart';
import '../../domain/repositories/proyecto_repository.dart';
import '../datasources/proyecto_remote_datasource.dart';

class ProyectoRepositoryImpl implements ProyectoRepository {
  final ProyectoRemoteDataSource _remote;
  final LocalDatabase _localDatabase;
  
  ProyectoRepositoryImpl(this._remote, this._localDatabase);

  @override
  Future<List<ProyectoEntity>> listar() async {
    final db = await _localDatabase.database;
    List<ProyectoEntity> locales;
    try {
      locales = await _leerProyectosLocales(db);
    } catch (e) {
      debugPrint('PROYECTOS ERROR (repo.listar, lectura local inicial): $e');
      rethrow;
    }

    // Si ya tenemos proyectos locales, los retornamos sin llamar al back-end.
    // Solo hace la petición si está vacío.
    if (locales.isNotEmpty) {
      return locales;
    }
    
    try {
      final proyectos = await _remote.listar();
      // Guardar en la base de datos local
      final batch = db.batch();
      for (var p in proyectos) {
        final map = p.toJson();
        map['is_synced'] = 1;
        batch.insert('proyectos', map, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
      
      // Leer todo de local (esto incluirá los offline que no se hayan sincronizado)
      return await _leerProyectosLocales(db);
    } catch (e) {
      debugPrint('PROYECTOS ERROR (repo.listar): $e');
      // Offline fallback
      return locales;
    }
  }
  
  Future<List<ProyectoEntity>> _leerProyectosLocales(Database db) async {
    final maps = await db.query('proyectos', orderBy: 'id DESC');
    return maps.map(ProyectoEntity.fromJson).toList();
  }

  @override
  Future<ProyectoEntity> crear({required String nombre, String? direccion}) async {
    try {
      final proyecto = await _remote.crear(nombre, direccion: direccion);
      final db = await _localDatabase.database;
      final map = proyecto.toJson();
      map['is_synced'] = 1;
      await db.insert('proyectos', map, conflictAlgorithm: ConflictAlgorithm.replace);
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
      );
      
      final map = offlineProyecto.toJson();
      map['is_synced'] = 0; // Pendiente de sincronizar
      await db.insert('proyectos', map);
      
      return offlineProyecto;
    }
  }
}
