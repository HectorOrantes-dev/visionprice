import 'package:injectable/injectable.dart';
import '../../../../core/storage/local_database.dart';
import '../../domain/entities/sync_item_entity.dart';

@lazySingleton
class SyncLocalDataSource {
  final LocalDatabase _localDb;

  SyncLocalDataSource(this._localDb);

  Future<void> insertItem(SyncItemEntity item) async {
    final db = await _localDb.database;
    await db.insert('sync_queue', item.toMap());
  }

  Future<void> updateItem(SyncItemEntity item) async {
    final db = await _localDb.database;
    await db.update(
      'sync_queue',
      item.toMap(),
      where: 'local_id = ?',
      whereArgs: [item.localId],
    );
  }

  Future<List<SyncItemEntity>> getAllItems() async {
    final db = await _localDb.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT s.*, p.nombre as proyecto_nombre 
      FROM sync_queue s 
      LEFT JOIN proyectos p ON s.proyecto_id = p.id 
      ORDER BY s.fecha_grabacion DESC
    ''');
    return maps.map((e) => SyncItemEntity.fromMap(e)).toList();
  }

  Future<List<SyncItemEntity>> getPendingItems() async {
    final db = await _localDb.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT s.*, p.nombre as proyecto_nombre 
      FROM sync_queue s 
      LEFT JOIN proyectos p ON s.proyecto_id = p.id 
      WHERE s.estado = 'pending' OR s.estado = 'error'
      ORDER BY s.fecha_grabacion ASC
    ''');
    return maps.map((e) => SyncItemEntity.fromMap(e)).toList();
  }

  Future<List<SyncItemEntity>> getProcessingItems() async {
    final db = await _localDb.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT s.*, p.nombre as proyecto_nombre 
      FROM sync_queue s 
      LEFT JOIN proyectos p ON s.proyecto_id = p.id 
      WHERE s.estado = 'processing'
      ORDER BY s.fecha_grabacion ASC
    ''');
    return maps.map((e) => SyncItemEntity.fromMap(e)).toList();
  }

  Future<void> deleteItem(String localId) async {
    final db = await _localDb.database;
    await db.delete(
      'sync_queue',
      where: 'local_id = ?',
      whereArgs: [localId],
    );
  }

  Future<void> clearReadyItems() async {
    final db = await _localDb.database;
    await db.delete(
      'sync_queue',
      where: "estado = 'ready'",
    );
  }
}
