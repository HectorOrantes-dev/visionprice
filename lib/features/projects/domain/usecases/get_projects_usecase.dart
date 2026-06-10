import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/project.dart';
import '../repositories/project_repository.dart';

/// Caso de uso: Obtener lista de proyectos
final class GetProjectsUseCase {
  const GetProjectsUseCase(this._repository);

  final ProjectRepository _repository;

  Future<Either<Failure, List<Project>>> call() {
    return _repository.getProjects();
  }
}

/// Parámetros para creación de proyecto
final class CreateProjectParams {
  const CreateProjectParams({
    required this.name,
    required this.workType,
    required this.city,
  });

  final String name;
  final WorkType workType;
  final String city;
}

/// Caso de uso: Crear proyecto nuevo
final class CreateProjectUseCase {
  const CreateProjectUseCase(this._repository);

  final ProjectRepository _repository;

  Future<Either<Failure, Project>> call(CreateProjectParams params) {
    return _repository.createProject(
      name: params.name,
      workType: params.workType,
      city: params.city,
    );
  }
}
