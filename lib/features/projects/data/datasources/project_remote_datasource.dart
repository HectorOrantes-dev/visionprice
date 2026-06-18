import 'package:injectable/injectable.dart';
import '../../domain/entities/project.dart';
import '../models/project_model.dart';

/// Contrato del datasource remoto de proyectos.
abstract interface class ProjectRemoteDatasource {
  Future<List<ProjectModel>> getProjects();
  Future<ProjectModel> createProject({
    required String name,
    required WorkType workType,
    required String city,
  });
  Future<ProjectModel> getProjectById(String id);
  Future<ProjectModel> updateProject(Project project);
  Future<void> deleteProject(String id);
}

/// Implementación del datasource — actualmente usa datos mock.
@Injectable(as: ProjectRemoteDatasource)
class ProjectRemoteDatasourceImpl implements ProjectRemoteDatasource {
  const ProjectRemoteDatasourceImpl();

  @override
  Future<List<ProjectModel>> getProjects() async {
    // TODO: reemplazar con llamada Dio/Retrofit al endpoint real
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      ProjectModel(
        id: 'proj_001',
        name: 'Baño Principal - Coyoacán',
        workType: WorkType.floor,
        city: 'Ciudad de México',
        status: ProjectStatus.active,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        estimateId: 'est_001',
      ),
      ProjectModel(
        id: 'proj_002',
        name: 'Sala Comedor - Polanco',
        workType: WorkType.wall,
        city: 'Ciudad de México',
        status: ProjectStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }

  @override
  Future<ProjectModel> createProject({
    required String name,
    required WorkType workType,
    required String city,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ProjectModel(
      id: 'proj_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      workType: workType,
      city: city,
      status: ProjectStatus.active,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<ProjectModel> getProjectById(String id) async {
    final projects = await getProjects();
    return projects.firstWhere((p) => p.id == id);
  }

  @override
  Future<ProjectModel> updateProject(Project project) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return ProjectModel.fromEntity(project);
  }

  @override
  Future<void> deleteProject(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
