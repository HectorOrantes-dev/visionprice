import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/home_provider.dart';
import 'empty_projects.dart';
import 'home_project_card.dart';

/// Lista (sliver) de proyectos con sus estados de carga / error / vacío.
/// Antes el privado `_ProjectsSliver`.
class ProjectsSliver extends StatelessWidget {
  final HomeViewModel vm;
  const ProjectsSliver({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    if (vm.loading && vm.proyectos.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (vm.error != null && vm.proyectos.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                vm.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: vm.cargarProyectos,
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
        itemBuilder: (_, i) => HomeProjectCard(proyecto: vm.proyectos[i]),
      ),
    );
  }
}
