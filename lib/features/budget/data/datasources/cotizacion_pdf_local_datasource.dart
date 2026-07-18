import 'package:sqflite/sqflite.dart';

import '../../../../core/storage/local_database.dart';
import '../../domain/entities/cotizacion_pdf_entity.dart';

/// Caché local (sqflite) de la pestaña "Mis Cotizaciones": guarda el último listado de
/// cotizaciones/PDFs para poder mostrarlo sin conexión.
///
/// Todas las consultas usan parámetros ligados / mapas (sqflite los liga), nunca
/// concatenación de valores en el SQL.
class CotizacionPdfLocalDataSource {
  final LocalDatabase _localDb;
  CotizacionPdfLocalDataSource(this._localDb);

  /// Lee el listado cacheado, más reciente primero.
  Future<List<CotizacionPdfEntity>> leer() async {
    final db = await _localDb.database;
    final maps = await db.query('cotizaciones_pdf', orderBy: 'fecha DESC');
    return maps.map(CotizacionPdfEntity.fromJson).toList();
  }

  /// Reemplaza el snapshot cacheado con [items] (lo que acaba de dar el back-end).
  Future<void> guardar(List<CotizacionPdfEntity> items) async {
    final db = await _localDb.database;
    final batch = db.batch();
    batch.delete('cotizaciones_pdf');
    for (final e in items) {
      batch.insert(
        'cotizaciones_pdf',
        e.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
