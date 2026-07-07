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
  Future<CalculoEntity> calcular({int? grabacionId, String? texto}) =>
      _remote.calcular(grabacionId: grabacionId, texto: texto);

  @override
  Future<GrabacionEntity> actualizarTranscripcion(int id, String texto) =>
      _remote.actualizarTranscripcion(id, texto);
}
