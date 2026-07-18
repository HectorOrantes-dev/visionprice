import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../providers/home_provider.dart';
import 'empty_projects.dart';
import 'project_card.dart';

/// Lista de proyectos del usuario (desde el back-end) con sus estados de
/// carga / error / vacío.
class ProjectsSliver extends StatelessWidget {
  final HomeState state;
  final Home notifier;
  const ProjectsSliver({super.key, required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final vm = state;
    if (vm.error != null && vm.proyectos.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                vm.error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13, color: context.colors.textSecondary),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: notifier.cargarProyectos,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (vm.proyectos.isEmpty) {
      return const SliverToBoxAdapter(child: EmptyProjects());
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList.separated(
        itemCount: vm.proyectos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => ProjectCard(proyecto: vm.proyectos[i]),
      ),
    );
  }
}
