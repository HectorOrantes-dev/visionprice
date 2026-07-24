import 'package:sqflite/sqflite.dart';

import '../../../../core/storage/local_database.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/cotizacion_pdf_entity.dart';

/// Caché local (sqflite) de la pestaña "Mis Cotizaciones": guarda el último listado de
/// cotizaciones/PDFs para poder mostrarlo sin conexión.
///
/// Es una caché del DISPOSITIVO, no de la cuenta — cada fila se marca con
/// `usuario_id` y se filtra por el usuario actual, para que cambiar de
/// cuenta en el mismo teléfono no mezcle cotizaciones de una con la otra.
///
/// Todas las consultas usan parámetros ligados / mapas (sqflite los liga), nunca
/// concatenación de valores en el SQL.
class CotizacionPdfLocalDataSource {
  final LocalDatabase _localDb;
  final TokenStorage _tokenStorage;
  CotizacionPdfLocalDataSource(this._localDb, this._tokenStorage);

  /// Lee el listado cacheado del usuario actual, más reciente primero.
  Future<List<CotizacionPdfEntity>> leer() async {
    final db = await _localDb.database;
    final maps = await db.query(
      'cotizaciones_pdf',
      where: 'usuario_id = ?',
      whereArgs: [_tokenStorage.userId],
      orderBy: 'fecha DESC',
    );
    return maps.map(CotizacionPdfEntity.fromJson).toList();
  }

  /// Reemplaza el snapshot cacheado del usuario actual con [items] (lo que
  /// acaba de dar el back-end) — solo borra SUS filas, no las de otra cuenta.
  Future<void> guardar(List<CotizacionPdfEntity> items) async {
    final db = await _localDb.database;
    final usuarioId = _tokenStorage.userId;
    final batch = db.batch();
    batch.delete('cotizaciones_pdf',
        where: 'usuario_id = ?', whereArgs: [usuarioId]);
    for (final e in items) {
      final map = e.toJson()..['usuario_id'] = usuarioId;
      batch.insert(
        'cotizaciones_pdf',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
