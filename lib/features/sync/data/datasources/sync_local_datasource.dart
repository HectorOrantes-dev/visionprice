import 'package:flutter/foundation.dart';

import '../../../../core/storage/local_database.dart';
import '../../domain/entities/sync_item_entity.dart';

/// Cola de sincronización de audios grabados offline — funcionalidad
/// puramente de dispositivo (graba un archivo local y lo sube cuando hay
/// red). En Flutter Web no hay archivos de audio locales que encolar, y
/// `sqflite` no tiene backend real ahí (`databaseFactory not initialized`).
/// Cada método es best-effort: en vez de tronar sin capturar (rompía
/// `SyncService._init()` en cuanto arrancaba la app en web), una falla local
/// se trata como "no hay nada pendiente que sincronizar".
class SyncLocalDataSource {
  final LocalDatabase _localDb;

  SyncLocalDataSource(this._localDb);

  Future<void> insertItem(SyncItemEntity item) async {
    try {
      final db = await _localDb.database;
      await db.insert('sync_queue', item.toMap());
    } catch (e) {
      debugPrint('SyncLocalDataSource.insertItem: no se pudo guardar ($e).');
    }
  }

  Future<void> updateItem(SyncItemEntity item) async {
    try {
      final db = await _localDb.database;
      await db.update(
        'sync_queue',
        item.toMap(),
        where: 'local_id = ?',
        whereArgs: [item.localId],
      );
    } catch (e) {
      debugPrint('SyncLocalDataSource.updateItem: no se pudo actualizar ($e).');
    }
  }

  Future<List<SyncItemEntity>> getAllItems() async {
    try {
      final db = await _localDb.database;
      final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT s.*, p.nombre as proyecto_nombre
      FROM sync_queue s
      LEFT JOIN proyectos p ON s.proyecto_id = p.id
      ORDER BY s.fecha_grabacion DESC
    ''');
      return maps.map((e) => SyncItemEntity.fromMap(e)).toList();
    } catch (e) {
      debugPrint('SyncLocalDataSource.getAllItems: sin cola local ($e).');
      return const [];
    }
  }

  Future<List<SyncItemEntity>> getPendingItems() async {
    try {
      final db = await _localDb.database;
      final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT s.*, p.nombre as proyecto_nombre
      FROM sync_queue s
      LEFT JOIN proyectos p ON s.proyecto_id = p.id
      WHERE s.estado = 'pending' OR s.estado = 'error'
      ORDER BY s.fecha_grabacion ASC
    ''');
      return maps.map((e) => SyncItemEntity.fromMap(e)).toList();
    } catch (e) {
      debugPrint('SyncLocalDataSource.getPendingItems: sin cola local ($e).');
      return const [];
    }
  }

  Future<List<SyncItemEntity>> getProcessingItems() async {
    try {
      final db = await _localDb.database;
      final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT s.*, p.nombre as proyecto_nombre
      FROM sync_queue s
      LEFT JOIN proyectos p ON s.proyecto_id = p.id
      WHERE s.estado = 'processing'
      ORDER BY s.fecha_grabacion ASC
    ''');
      return maps.map((e) => SyncItemEntity.fromMap(e)).toList();
    } catch (e) {
      debugPrint('SyncLocalDataSource.getProcessingItems: sin cola local ($e).');
      return const [];
    }
  }

  Future<void> deleteItem(String localId) async {
    try {
      final db = await _localDb.database;
      await db.delete(
        'sync_queue',
        where: 'local_id = ?',
        whereArgs: [localId],
      );
    } catch (e) {
      debugPrint('SyncLocalDataSource.deleteItem: no se pudo borrar ($e).');
    }
  }

  Future<void> clearReadyItems() async {
    try {
      final db = await _localDb.database;
      await db.delete(
        'sync_queue',
        where: "estado = 'ready'",
      );
    } catch (e) {
      debugPrint('SyncLocalDataSource.clearReadyItems: no se pudo borrar ($e).');
    }
  }
}
