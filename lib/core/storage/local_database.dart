import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

@lazySingleton
class LocalDatabase {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('visionprice_local.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sync_queue (
        local_id TEXT PRIMARY KEY,
        audio_path TEXT NOT NULL,
        proyecto_id INTEGER NOT NULL,
        duracion_segundos INTEGER,
        fecha_grabacion TEXT NOT NULL,
        estado TEXT NOT NULL,
        progreso REAL NOT NULL DEFAULT 0.0,
        api_id INTEGER
      )
    ''');
  }
}
