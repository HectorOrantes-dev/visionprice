import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/project.dart';

/// Mock de proyectos activos para demostración
final _mockProjects = [
  Project(
    id: 'p1',
    name: 'Baño Principal - Coyoacán',
    workType: WorkType.floor,
    city: 'CDMX',
    status: ProjectStatus.completed,
    scannedAreaM2: 18.5,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    estimateId: 'est_001',
  ),
  Project(
    id: 'p2',
    name: 'Cocina - Polanco',
    workType: WorkType.wall,
    city: 'CDMX',
    status: ProjectStatus.processing,
    scannedAreaM2: 32.0,
    createdAt: DateTime.now().subtract(const Duration(hours: 4)),
  ),
  Project(
    id: 'p3',
    name: 'Terraza - Guadalajara',
    workType: WorkType.ceiling,
    city: 'Guadalajara',
    status: ProjectStatus.scanning,
    createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
  ),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Buenos días,',
                              style: AppTypography.textTheme.bodyMedium,
                            ),
                            Text(
                              'Carlos Méndez',
                              style: AppTypography.textTheme.headlineLarge,
                            ),
                          ],
                        ),
                        // Avatar
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: AppColors.gradientPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: AppColors.textOnPrimary,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Stats cards
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            label: 'Proyectos',
                            value: '${_mockProjects.length}',
                            icon: Icons.folder_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            label: 'Este mes',
                            value: 124500.0.toMXNCompact,
                            icon: Icons.trending_up,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Botón crear proyecto
                    _CreateProjectButton(
                      onTap: () => context.push(AppRoutes.createProject),
                    ),
                    const SizedBox(height: 28),

                    Text(
                      'Proyectos Activos',
                      style: AppTypography.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ),

          // Lista de proyectos
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _ProjectCard(
                  project: _mockProjects[i],
                  onTap: () {
                    if (_mockProjects[i].status == ProjectStatus.completed) {
                      context.push(
                          '${AppRoutes.budget}?projectId=${_mockProjects[i].id}');
                    } else {
                      context.push(
                          '${AppRoutes.scanner}?projectId=${_mockProjects[i].id}');
                    }
                  },
                ),
                childCount: _mockProjects.length,
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomIndex,
        onTap: (i) => setState(() => _bottomIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined),
            activeIcon: Icon(Icons.folder),
            label: 'Proyectos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),

      // FAB — Escanear
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.scanner),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        icon: const Icon(Icons.view_in_ar),
        label: const Text('Escanear'),
        elevation: 0,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value,
              style: AppTypography.textTheme.headlineMedium
                  ?.copyWith(color: color)),
          Text(label, style: AppTypography.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _CreateProjectButton extends StatelessWidget {
  const _CreateProjectButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0E2018), Color(0xFF0A1510)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: AppColors.primary.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.add, color: AppColors.primary, size: 26),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nuevo Proyecto',
                    style: AppTypography.textTheme.titleLarge),
                Text(
                  'Escanea una superficie y presupuesta',
                  style: AppTypography.textTheme.bodySmall,
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.chevron_right,
                color: AppColors.primary, size: 22),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project, required this.onTap});

  final Project project;
  final VoidCallback onTap;

  Color get _statusColor {
    switch (project.status) {
      case ProjectStatus.completed:
        return AppColors.success;
      case ProjectStatus.processing:
        return AppColors.accent;
      case ProjectStatus.scanning:
        return AppColors.warning;
      case ProjectStatus.archived:
        return AppColors.textHint;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(
          children: [
            // Work type icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _workTypeIcon(project.workType),
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.name,
                      style: AppTypography.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 12, color: AppColors.textHint),
                      const SizedBox(width: 3),
                      Text(project.city,
                          style: AppTypography.textTheme.bodySmall),
                      if (project.scannedAreaM2 != null) ...[
                        const SizedBox(width: 10),
                        Text(
                          project.scannedAreaM2!.toM2,
                          style: AppTypography.textTheme.bodySmall
                              ?.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Status badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                project.status.label,
                style: AppTypography.textTheme.labelSmall
                    ?.copyWith(color: _statusColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _workTypeIcon(WorkType type) {
    switch (type) {
      case WorkType.floor:
        return Icons.view_quilt_outlined;
      case WorkType.wall:
        return Icons.vertical_distribute;
      case WorkType.ceiling:
        return Icons.roofing;
      case WorkType.mixed:
        return Icons.construction;
    }
  }
}
