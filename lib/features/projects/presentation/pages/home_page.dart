import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

import '../../../recording/presentation/screens/recording_screen.dart';
import '../../../sync/presentation/screens/sync_queue_screen.dart';
import '../../../budget/presentation/screens/budget_result_screen.dart';

import '../../domain/entities/project.dart';

import 'package:provider/provider.dart';
import '../../../auth/presentation/providers/login_provider.dart';

/// Mock de proyectos activos para demostración
final _mockProjectsMaestro = [
  Project(
    id: 'p1',
    name: 'Baño Principal - Coyoacán',
    workType: WorkType.floor,
    city: 'CDMX',
    status: ProjectStatus.completed,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    estimateId: 'est_001',
  ),
  Project(
    id: 'p2',
    name: 'Cocina - Polanco',
    workType: WorkType.wall,
    city: 'CDMX',
    status: ProjectStatus.active,
    createdAt: DateTime.now().subtract(const Duration(hours: 4)),
  ),
];

final _mockProjectsContratista = [
  Project(
    id: 'p1',
    name: 'Oficinas Torre Reforma',
    workType: WorkType.floor,
    city: 'CDMX',
    status: ProjectStatus.active,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Project(
    id: 'p2',
    name: 'Residencia Lomas',
    workType: WorkType.wall,
    city: 'CDMX',
    status: ProjectStatus.active,
    createdAt: DateTime.now().subtract(const Duration(hours: 4)),
  ),
  Project(
    id: 'p3',
    name: 'Bodega Industrial Vallejo',
    workType: WorkType.ceiling,
    city: 'CDMX',
    status: ProjectStatus.completed,
    createdAt: DateTime.now().subtract(const Duration(days: 4)),
  ),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.onProjectsTap, this.onReportsTap});

  final VoidCallback? onProjectsTap;
  final VoidCallback? onReportsTap;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final role = context.watch<LoginViewModel>().currentUserRole;
    final isContratista = role == 'contratista' || role == 'arquitecto';
    final name = isContratista ? 'Ing. Martinez 👷' : 'Carlos Méndez';
    final activeCount = isContratista ? '7' : '2';
    final totalBudget = isContratista ? '\$1.24M' : '\$45,000';
    final pendingReports = isContratista ? '3 reportes de cuadrilla pendientes' : '1 reporte pendiente';
    final projectsList = isContratista ? _mockProjectsContratista : _mockProjectsMaestro;

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
                              'Hola,',
                              style: AppTypography.textTheme.bodyMedium,
                            ),
                            Text(
                              name,
                              style: AppTypography.textTheme.headlineLarge,
                            ),
                          ],
                        ),
                        // Avatar
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
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
                            child: GestureDetector(
                              onTap: () {
                                if (widget.onProjectsTap != null) {
                                  widget.onProjectsTap!();
                                }
                              },
                              child: _StatCard(
                                label: 'Proyectos activos',
                                value: activeCount,
                                icon: Icons.folder_open,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (widget.onReportsTap != null) {
                                  widget.onReportsTap!();
                                }
                              },
                              child: _StatCard(
                                label: 'Presupuestado total',
                                value: totalBudget,
                                icon: Icons.attach_money,
                                color: AppColors.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (widget.onReportsTap != null) ...[
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: widget.onReportsTap,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.bar_chart_outlined, color: AppColors.primary, size: 18),
                              const SizedBox(width: 10),
                              Text(
                                'Ver reportes y presupuestos',
                                style: AppTypography.textTheme.labelMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Icon(Icons.chevron_right, color: AppColors.primary, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),

                    // Botón crear presupuesto por voz
                    _VoiceRecordButton(
                      title: isContratista ? 'Nueva cotización por voz' : 'Nuevo presupuesto por voz',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RecordingScreen())),
                    ),
                    const SizedBox(height: 16),
                    
                    // Indicador de audios pendientes
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SyncQueueScreen())),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.warningLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.group, size: 16, color: AppColors.warning),
                              const SizedBox(width: 8),
                              Text(
                                pendingReports,
                                style: AppTypography.textTheme.labelMedium?.copyWith(
                                  color: AppColors.warning,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                  project: projectsList[i],
                  onTap: () {
                    if (projectsList[i].status == ProjectStatus.completed) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const BudgetResultScreen()));
                    } else {
                      // Simula ir al detalle o crear presupuesto
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const BudgetResultScreen()));
                    }
                  },
                ),
                childCount: projectsList.length,
              ),
            ),
          ),
        ],
      ),
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

class _VoiceRecordButton extends StatelessWidget {
  const _VoiceRecordButton({required this.title, required this.onTap});
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.mic, size: 24),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
      case ProjectStatus.active:
        return AppColors.accent;
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
                color: AppColors.primary.withValues(alpha: 0.1),
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
                color: _statusColor.withValues(alpha: 0.12),
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
