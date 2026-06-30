import 'package:injectable/injectable.dart';

import '../../domain/entities/proyecto_entity.dart';
import '../../domain/repositories/proyecto_repository.dart';
import '../datasources/proyecto_remote_datasource.dart';

@LazySingleton(as: ProyectoRepository)
class ProyectoRepositoryImpl implements ProyectoRepository {
  final ProyectoRemoteDataSource _remote;
  ProyectoRepositoryImpl(this._remote);

  @override
  Future<List<ProyectoEntity>> listar() => _remote.listar();

  @override
  Future<ProyectoEntity> crear({required String nombre, String? direccion}) =>
      _remote.crear(nombre, direccion: direccion);
}
