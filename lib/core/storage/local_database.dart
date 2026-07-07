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
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      CREATE TABLE perfil (
        id INTEGER PRIMARY KEY,
        nombre TEXT NOT NULL,
        correo TEXT NOT NULL,
        telefono TEXT NOT NULL,
        rol TEXT NOT NULL,
        activo INTEGER NOT NULL,
        proveedor_auth TEXT NOT NULL,
        fecha_registro TEXT,
        plan_activo TEXT,
        vigencia_hasta TEXT
      );
      ''');
      
      await db.execute('''
      CREATE TABLE proyectos (
        id INTEGER PRIMARY KEY,
        nombre TEXT NOT NULL,
        direccion TEXT,
        estado TEXT NOT NULL,
        total_presupuestos INTEGER NOT NULL DEFAULT 0,
        is_synced INTEGER NOT NULL DEFAULT 1
      );
      ''');
    }
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
      );
      
      CREATE TABLE perfil (
        id INTEGER PRIMARY KEY,
        nombre TEXT NOT NULL,
        correo TEXT NOT NULL,
        telefono TEXT NOT NULL,
        rol TEXT NOT NULL,
        activo INTEGER NOT NULL,
        proveedor_auth TEXT NOT NULL,
        fecha_registro TEXT,
        plan_activo TEXT,
        vigencia_hasta TEXT
      );

      CREATE TABLE proyectos (
        id INTEGER PRIMARY KEY,
        nombre TEXT NOT NULL,
        direccion TEXT,
        estado TEXT NOT NULL,
        total_presupuestos INTEGER NOT NULL DEFAULT 0,
        is_synced INTEGER NOT NULL DEFAULT 1
      );
    ''');
  }
}
