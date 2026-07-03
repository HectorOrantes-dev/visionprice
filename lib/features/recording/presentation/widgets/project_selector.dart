import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/recording_provider.dart';
import 'project_sheet.dart';

/// Selector de proyecto (obligatorio): muestra el elegido y abre el sheet.
/// Antes el privado `_ProjectSelector`.
class ProjectSelector extends StatelessWidget {
  final RecordingViewModel vm;
  const ProjectSelector({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final proyecto = vm.selectedProyecto;
    final tieneProyecto = proyecto != null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: GestureDetector(
        onTap: () => showProjectSheet(context, vm),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: tieneProyecto ? AppColors.border : AppColors.warning,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.folder_outlined,
                  size: 20,
                  color: tieneProyecto
                      ? AppColors.primary
                      : AppColors.warning),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PROYECTO',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      vm.loadingProyectos
                          ? 'Cargando proyectos...'
                          : (proyecto?.nombre ?? 'Selecciona un proyecto'),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: tieneProyecto
                            ? AppColors.textPrimary
                            : AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.unfold_more,
                  size: 18, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
