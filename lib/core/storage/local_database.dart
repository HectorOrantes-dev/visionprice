import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
      // v3: repara instalaciones donde faltaban las tablas `perfil`/`proyectos`
      // (el `_createDB` antiguo metía varios CREATE en un solo execute() y
      // sqflite solo ejecuta la PRIMERA sentencia → solo se creaba sync_queue).
      // v4: agrega `cotizaciones_pdf` (caché offline de la pestaña Mis Cotizaciones).
      // v5: agrega `latitud`/`longitud` a `proyectos` (ubicación de la obra).
      // v6: agrega `numero` a `cotizaciones_pdf` (número de cotización para
      // mostrar al usuario; `id` se sigue usando solo para la URL del PDF).
      // v7: agrega `plan_nombre`/`plan_precio_mxn` a `perfil` (nombre/precio
      // legibles del plan, calculados por el back-end a partir del slug).
      // v8: agrega `usuario_id` a `proyectos` y `cotizaciones_pdf` — estas
      // cachés son "del dispositivo", no de la cuenta, así que sin esto
      // cualquier cuenta que entre en el mismo teléfono ve los proyectos y
      // cotizaciones de la cuenta anterior. Ahora cada fila queda marcada
      // con el dueño y las lecturas se filtran por el usuario actual.
      // v9: agrega `es_dueno` a `proyectos` (viene de `GET /proyectos`) — lo
      // necesita `ProjectMembersScreen` para saber si mostrar "Invitar".
      version: 9,
      onCreate: (db, version) => _createAllTables(db),
      onUpgrade: (db, oldVersion, newVersion) async {
        await _createAllTables(db);
        // Las columnas nuevas NO las agrega `CREATE TABLE IF NOT EXISTS` en
        // tablas ya existentes: hay que hacer ALTER TABLE.
        await _addColumnIfMissing(db, 'proyectos', 'latitud', 'REAL');
        await _addColumnIfMissing(db, 'proyectos', 'longitud', 'REAL');
        await _addColumnIfMissing(db, 'cotizaciones_pdf', 'numero', 'INTEGER');
        await _addColumnIfMissing(db, 'perfil', 'plan_nombre', 'TEXT');
        await _addColumnIfMissing(db, 'perfil', 'plan_precio_mxn', 'REAL');
        await _addColumnIfMissing(db, 'proyectos', 'usuario_id', 'INTEGER');
        await _addColumnIfMissing(
            db, 'cotizaciones_pdf', 'usuario_id', 'INTEGER');
        await _addColumnIfMissing(db, 'proyectos', 'es_dueno', 'INTEGER');
        // Filas de antes de v8 no tienen dueño conocido: se borran en vez de
        // dejarlas huérfanas mostrándose a cualquier cuenta (mismo criterio
        // que ya se usaba al cambiar de cuenta, pero de una vez por todas).
        await db.delete('proyectos', where: 'usuario_id IS NULL');
        await db.delete('cotizaciones_pdf', where: 'usuario_id IS NULL');
      },
    );
  }

  /// Agrega una columna solo si la tabla aún no la tiene (idempotente).
  /// El nombre de tabla/columna viene de constantes del código, nunca del
  /// usuario, y los valores nunca se concatenan aquí.
  Future<void> _addColumnIfMissing(
      Database db, String tabla, String columna, String tipo) async {
    final info = await db.rawQuery('PRAGMA table_info($tabla)');
    final existe = info.any((row) => row['name'] == columna);
    if (existe) return;
    await db.execute('ALTER TABLE $tabla ADD COLUMN $columna $tipo');
  }

  /// Crea TODAS las tablas de forma idempotente. Se usa tanto en `onCreate`
  /// (instalación limpia) como en `onUpgrade` (repara BDs viejas a las que les
  /// falten tablas), sin borrar datos existentes gracias a `IF NOT EXISTS`.
  ///
  /// IMPORTANTE: cada `CREATE TABLE` va en su PROPIO `execute()` — sqflite solo
  /// ejecuta una sentencia por llamada; varias separadas por `;` hacen que solo
  /// corra la primera (ese era el bug que dejaba sin `proyectos`/`perfil`).
  Future<void> _createAllTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS sync_queue (
        local_id TEXT PRIMARY KEY,
        audio_path TEXT NOT NULL,
        proyecto_id INTEGER NOT NULL,
        duracion_segundos INTEGER,
        fecha_grabacion TEXT NOT NULL,
        estado TEXT NOT NULL,
        progreso REAL NOT NULL DEFAULT 0.0,
        api_id INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS perfil (
        id INTEGER PRIMARY KEY,
        nombre TEXT NOT NULL,
        correo TEXT NOT NULL,
        telefono TEXT NOT NULL,
        rol TEXT NOT NULL,
        activo INTEGER NOT NULL,
        proveedor_auth TEXT NOT NULL,
        fecha_registro TEXT,
        plan_activo TEXT,
        vigencia_hasta TEXT,
        plan_nombre TEXT,
        plan_precio_mxn REAL
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS proyectos (
        id INTEGER PRIMARY KEY,
        nombre TEXT NOT NULL,
        direccion TEXT,
        estado TEXT NOT NULL,
        total_presupuestos INTEGER NOT NULL DEFAULT 0,
        is_synced INTEGER NOT NULL DEFAULT 1,
        latitud REAL,
        longitud REAL,
        usuario_id INTEGER,
        es_dueno INTEGER
      );
    ''');

    // Caché offline de la pestaña "Mis Cotizaciones" (GET /cotizaciones/pdfs).
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cotizaciones_pdf (
        id INTEGER PRIMARY KEY,
        numero INTEGER,
        proyecto_id INTEGER NOT NULL,
        proyecto_nombre TEXT NOT NULL,
        estado TEXT NOT NULL,
        total REAL NOT NULL DEFAULT 0,
        fecha TEXT NOT NULL,
        url_pdf TEXT NOT NULL,
        usuario_id INTEGER
      );
    ''');
  }
}
