import '../../domain/entities/proyecto_entity.dart';

abstract class ProyectoRemoteDataSource {
  Future<List<ProyectoEntity>> listar();

  /// Crea la obra. [latitud]/[longitud] son la ubicación de la obra: sin ellas
  /// el modelo de recomendaciones no puede usarla como obra real.
  Future<ProyectoEntity> crear(
    String nombre, {
    String? direccion,
    double? latitud,
    double? longitud,
  });

  /// Completa/actualiza la ubicación de una obra ya creada
  /// (`PATCH /api/v1/proyectos/{id}`).
  Future<ProyectoEntity> actualizarUbicacion(
    int id, {
    required double latitud,
    required double longitud,
  });
}
