import '../../domain/entities/entrenamiento_entity.dart';
import '../../domain/entities/recomendacion_kit_entity.dart';
import '../../domain/repositories/recomendacion_repository.dart';
import '../datasources/recomendacion_remote_datasource.dart';

class RecomendacionRepositoryImpl implements RecomendacionRepository {
  final RecomendacionRemoteDataSource _remote;
  RecomendacionRepositoryImpl(this._remote);

  @override
  Future<EntrenamientoEntity> entrenar() => _remote.entrenar();

  @override
  Future<RecomendacionKitEntity> recomendarKit({
    required double lat,
    required double lng,
    required String categoria,
    required double areaM2,
    int? proyectoId,
    int? k,
  }) =>
      _remote.recomendarKit(
        lat: lat,
        lng: lng,
        categoria: categoria,
        areaM2: areaM2,
        proyectoId: proyectoId,
        k: k,
      );
}
