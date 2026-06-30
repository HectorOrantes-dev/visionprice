import 'package:injectable/injectable.dart';

import '../../domain/entities/calculo_entity.dart';
import '../../domain/entities/grabacion_entity.dart';
import '../../domain/repositories/grabacion_repository.dart';
import '../datasources/grabacion_remote_datasource.dart';

@LazySingleton(as: GrabacionRepository)
class GrabacionRepositoryImpl implements GrabacionRepository {
  final GrabacionRemoteDataSource _remote;
  GrabacionRepositoryImpl(this._remote);

  @override
  Future<GrabacionEntity> subir({
    required String audioPath,
    int? duracionSegundos,
    int? proyectoId,
  }) =>
      _remote.subir(
        audioPath,
        duracionSegundos: duracionSegundos,
        proyectoId: proyectoId,
      );

  @override
  Future<GrabacionEntity> detalle(int id) => _remote.detalle(id);

  @override
  Future<List<GrabacionEntity>> historial() => _remote.historial();

  @override
  Future<CalculoEntity> calcular({required int grabacionId}) =>
      _remote.calcular(grabacionId);
}
