import 'package:injectable/injectable.dart';

import '../../domain/repositories/dispositivo_repository.dart';
import '../datasources/dispositivo_remote_datasource.dart';

@LazySingleton(as: DispositivoRepository)
class DispositivoRepositoryImpl implements DispositivoRepository {
  final DispositivoRemoteDataSource _remote;
  DispositivoRepositoryImpl(this._remote);

  @override
  Future<void> registrar({
    required String token,
    required String plataforma,
  }) =>
      _remote.registrar(token, plataforma);

  @override
  Future<void> borrar({required String token}) => _remote.borrar(token);
}
