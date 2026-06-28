import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/project.dart';
import '../../domain/usecases/get_projects_usecase.dart';

part 'projects_viewmodel.g.dart';

// ────────────────────────────────────────────────────────────
// Estado — sealed class para type-safe state management
// ────────────────────────────────────────────────────────────

sealed class ProjectsState {
  const ProjectsState();
}

final class ProjectsInitial extends ProjectsState {
  const ProjectsInitial();
}

final class ProjectsLoading extends ProjectsState {
  const ProjectsLoading();
}

final class ProjectsLoaded extends ProjectsState {
  const ProjectsLoaded(this.projects);
  final List<Project> projects;
}

final class ProjectsError extends ProjectsState {
  const ProjectsError(this.message);
  final String message;
}

// ────────────────────────────────────────────────────────────
// ViewModel — MVVM: solo coordina use cases, sin lógica de UI
// ────────────────────────────────────────────────────────────

/// ViewModel de la pantalla de proyectos.
///
/// Puente entre la capa [domain] y la capa [presentation].
/// Los use cases se resuelven desde GetIt para mantener Riverpod
/// libre de conocer la infraestructura de DI.
@riverpod
class ProjectsViewModel extends _$ProjectsViewModel {
  @override
  ProjectsState build() => const ProjectsInitial();

  // Accesores lazy: GetIt resuelve las dependencias
  GetProjectsUseCase get _getProjects => getIt<GetProjectsUseCase>();
  CreateProjectUseCase get _createProject => getIt<CreateProjectUseCase>();

  /// Carga todos los proyectos del usuario.
  Future<void> loadProjects() async {
    state = const ProjectsLoading();
    final result = await _getProjects();
    state = result.fold(
      (failure) => ProjectsError(failure.message),
      (projects) => ProjectsLoaded(projects),
    );
  }

  /// Crea un nuevo proyecto y recarga la lista.
  Future<void> createProject({
    required String name,
    required WorkType workType,
    required String city,
  }) async {
    state = const ProjectsLoading();
    final result = await _createProject(
      CreateProjectParams(name: name, workType: workType, city: city),
    );
    result.fold(
      (failure) => state = ProjectsError(failure.message),
      (_) => loadProjects(), // Recarga la lista tras crear
    );
  }
}
