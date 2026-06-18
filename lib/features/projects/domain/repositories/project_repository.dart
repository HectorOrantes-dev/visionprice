import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/project.dart';

/// Contrato del repositorio de proyectos — capa Domain.
abstract interface class ProjectRepository {
  Future<Either<Failure, List<Project>>> getProjects();

  Future<Either<Failure, Project>> createProject({
    required String name,
    required WorkType workType,
    required String city,
  });

  Future<Either<Failure, Project>> getProjectById(String id);

  Future<Either<Failure, Project>> updateProject(Project project);

  Future<Either<Failure, void>> deleteProject(String id);
}
