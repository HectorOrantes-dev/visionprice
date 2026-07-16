import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../providers/recording_provider.dart';
import 'project_sheet.dart';

/// Selector de proyecto (obligatorio): muestra el proyecto elegido y abre el
/// bottom sheet para elegir/crear. Antes el privado `_ProjectSelector`.
class ProjectSelector extends StatelessWidget {
  final RecordingState state;
  const ProjectSelector({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final proyecto = state.selectedProyecto;
    final tieneProyecto = proyecto != null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: GestureDetector(
        onTap: () => ProjectSheet.show(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: tieneProyecto
                  ? context.colors.border
                  : context.colors.warning,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.folder_outlined,
                  size: 20,
                  color: tieneProyecto
                      ? context.colors.primary
                      : context.colors.warning),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PROYECTO',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      state.loadingProyectos
                          ? 'Cargando proyectos...'
                          : (proyecto?.nombre ?? 'Selecciona un proyecto'),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: tieneProyecto
                            ? context.colors.textPrimary
                            : context.colors.warning,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.unfold_more,
                  size: 18, color: context.colors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
