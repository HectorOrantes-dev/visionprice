import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/project.dart';

/// Contrato del repositorio de proyectos — capa Domain
abstract interface class ProjectRepository {
  /// Lista todos los proyectos del usuario autenticado
  Future<Either<Failure, List<Project>>> getProjects();

  /// Crea un nuevo proyecto
  Future<Either<Failure, Project>> createProject({
    required String name,
    required WorkType workType,
    required String city,
  });

  /// Obtiene un proyecto por ID
  Future<Either<Failure, Project>> getProjectById(String id);

  /// Actualiza el estado y área escaneada tras el scan
  Future<Either<Failure, Project>> updateScanResult({
    required String projectId,
    required double scannedAreaM2,
    required String meshUrl,
  });

  /// Archiva un proyecto
  Future<Either<Failure, void>> archiveProject(String id);
}
