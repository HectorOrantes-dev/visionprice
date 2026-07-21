import 'cuerpo_confirmacion_entity.dart';
import 'superficie_borrador_entity.dart';

/// Respuesta completa de `POST /cotizaciones/borrador`: superficies detectadas
/// con producto/proveedor ya auto-elegido (el más barato cercano) por línea,
/// el total estimado, advertencias no bloqueantes (ej. sin proveedor cercano
/// para un complemento) y el `cuerpo_confirmacion` listo para postear tal
/// cual a `/cotizaciones` y/o `/cotizaciones/kit`.
///
/// OJO: si el usuario cambia un producto antes de confirmar, no hay
/// recálculo aquí — `crear`/`crear_kit` recalculan cantidad/precio en el
/// servidor al confirmar.
class BorradorCotizacionEntity {
  final int proyectoId;
  final int grabacionId;
  final double totalEstimado;
  final List<String> advertencias;
  final List<SuperficieBorradorEntity> superficies;
  final CuerpoConfirmacionEntity cuerpoConfirmacion;

  const BorradorCotizacionEntity({
    required this.proyectoId,
    required this.grabacionId,
    required this.totalEstimado,
    required this.advertencias,
    required this.superficies,
    required this.cuerpoConfirmacion,
  });

  factory BorradorCotizacionEntity.fromJson(Map<String, dynamic> json) {
    final superficiesJson = json['superficies'];
    final advertenciasJson = json['advertencias'];
    return BorradorCotizacionEntity(
      proyectoId: (json['proyecto_id'] as num?)?.toInt() ?? 0,
      grabacionId: (json['grabacion_id'] as num?)?.toInt() ?? 0,
      totalEstimado: (json['total_estimado'] as num?)?.toDouble() ?? 0,
      advertencias: advertenciasJson is List
          ? advertenciasJson.map((e) => e.toString()).toList()
          : const [],
      superficies: superficiesJson is List
          ? superficiesJson
              .whereType<Map<String, dynamic>>()
              .map(SuperficieBorradorEntity.fromJson)
              .toList()
          : const [],
      cuerpoConfirmacion: CuerpoConfirmacionEntity.fromJson(
        (json['cuerpo_confirmacion'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
    );
  }
}
