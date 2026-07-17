import '../entities/proyecto_entity.dart';

abstract class ProyectoRepository {
  Future<List<ProyectoEntity>> listar();

  /// Crea la obra con su ubicación ([latitud]/[longitud]). La ubicación es lo
  /// que permite que la obra entre al dataset real de recomendaciones.
  Future<ProyectoEntity> crear({
    required String nombre,
    String? direccion,
    double? latitud,
    double? longitud,
  });

  /// Completa la ubicación de una obra creada sin coordenadas.
  Future<ProyectoEntity> actualizarUbicacion({
    required int id,
    required double latitud,
    required double longitud,
  });
}
