// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectsViewModelHash() => r'9d4da2ec8033dc4f9cfbd5e06db20a84e90e6fbb';

/// ViewModel de la pantalla de proyectos.
///
/// Puente entre la capa [domain] y la capa [presentation].
/// Los use cases se resuelven desde GetIt para mantener Riverpod
/// libre de conocer la infraestructura de DI.
///
/// Copied from [ProjectsViewModel].
@ProviderFor(ProjectsViewModel)
final projectsViewModelProvider =
    AutoDisposeNotifierProvider<ProjectsViewModel, ProjectsState>.internal(
  ProjectsViewModel.new,
  name: r'projectsViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$projectsViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProjectsViewModel = AutoDisposeNotifier<ProjectsState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
