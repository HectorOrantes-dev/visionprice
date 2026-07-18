import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/invitacion_entity.dart';
import '../../domain/entities/miembros_result_entity.dart';
import '../../domain/entities/unirse_result_entity.dart';
import '../../domain/repositories/collaboration_repository.dart';
import '../datasources/collaboration_remote_datasource.dart';

class CollaborationRepositoryImpl implements CollaborationRepository {
  final CollaborationRemoteDataSource _remoteDataSource;

  CollaborationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, MiembrosResultEntity>> obtenerMiembros(int proyectoId) async {
    try {
      final result = await _remoteDataSource.obtenerMiembros(proyectoId);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> quitarMiembro(int proyectoId, int usuarioId) async {
    try {
      await _remoteDataSource.quitarMiembro(proyectoId, usuarioId);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, InvitacionEntity>> generarInvitacion(int proyectoId, String rol, List<String>? correos) async {
    try {
      final result = await _remoteDataSource.generarInvitacion(proyectoId, rol, correos);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InvitacionEntity>>> obtenerInvitaciones(int proyectoId) async {
    try {
      final result = await _remoteDataSource.obtenerInvitaciones(proyectoId);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> revocarInvitacion(int proyectoId, int invitacionId) async {
    try {
      await _remoteDataSource.revocarInvitacion(proyectoId, invitacionId);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UnirseResultEntity>> unirseAProyecto(String codigo) async {
    try {
      final result = await _remoteDataSource.unirseAProyecto(codigo);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message)); // El mensaje del back-end llega aquí
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
