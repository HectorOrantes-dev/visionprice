import '../../domain/entities/calculo_entity.dart';
import '../../domain/entities/grabacion_entity.dart';

abstract class GrabacionRemoteDataSource {
  Future<GrabacionEntity> subir(
    String audioPath, {
    int? duracionSegundos,
    int? proyectoId,
    void Function(double)? onProgress,
  });
  Future<GrabacionEntity> detalle(int id);
  Future<List<GrabacionEntity>> historial();
  Future<CalculoEntity> calcular({int? grabacionId, String? texto, double? altura});
  Future<GrabacionEntity> actualizarTranscripcion(int id, String texto);
}
