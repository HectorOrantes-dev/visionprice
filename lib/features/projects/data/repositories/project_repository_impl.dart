import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/project_remote_datasource.dart';

/// Implementación concreta de [ProjectRepository] — capa Data.
@Injectable(as: ProjectRepository)
class ProjectRepositoryImpl implements ProjectRepository {
  const ProjectRepositoryImpl(this._remoteDatasource);

  final ProjectRemoteDatasource _remoteDatasource;

  @override
  Future<Either<Failure, List<Project>>> getProjects() async {
    try {
      final models = await _remoteDatasource.getProjects();
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Project>> createProject({
    required String name,
    required WorkType workType,
    required String city,
  }) async {
    try {
      final model = await _remoteDatasource.createProject(
        name: name,
        workType: workType,
        city: city,
      );
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Project>> getProjectById(String id) async {
    try {
      final model = await _remoteDatasource.getProjectById(id);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Project>> updateProject(Project project) async {
    try {
      final model = await _remoteDatasource.updateProject(project);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProject(String id) async {
    try {
      await _remoteDatasource.deleteProject(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
