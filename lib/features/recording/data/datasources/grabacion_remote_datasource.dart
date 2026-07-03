import '../../domain/entities/calculo_entity.dart';
import '../../domain/entities/grabacion_entity.dart';

// La implementación vive en su propio archivo (una clase por archivo, SRP);
// se re-exporta para no romper imports existentes ni la DI generada.
export 'grabacion_remote_datasource_impl.dart';

abstract class GrabacionRemoteDataSource {
  Future<GrabacionEntity> subir(
    String audioPath, {
    int? duracionSegundos,
    int? proyectoId,
  });
  Future<GrabacionEntity> detalle(int id);
  Future<List<GrabacionEntity>> historial();
  Future<CalculoEntity> calcular(int grabacionId);
}
