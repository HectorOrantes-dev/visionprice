import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/recording_provider.dart';

/// Abre el bottom sheet para elegir un proyecto existente (el alta vive en la
/// pantalla de Inicio).
void showProjectSheet(BuildContext context, RecordingViewModel vm) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => ListenableBuilder(
      listenable: vm,
      builder: (ctx, _) => ProjectSheet(vm: vm),
    ),
  );
}

/// Contenido del bottom sheet de selección de proyecto. Antes `_ProjectSheet`.
class ProjectSheet extends StatelessWidget {
  final RecordingViewModel vm;
  const ProjectSheet({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Elige un proyecto',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (vm.loadingProyectos)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (vm.proyectos.isEmpty)
            // El alta de proyectos ahora vive en la pantalla de inicio; aquí
            // solo se selecciona uno existente.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Aún no tienes proyectos.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Créalos desde la pantalla de Inicio con "Crear nuevo proyecto" y vuelve aquí para seleccionarlo.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 320),
              child: ListView(
                shrinkWrap: true,
                children: vm.proyectos.map((p) {
                  final selected = vm.selectedProyecto?.id == p.id;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      selected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: selected
                          ? AppColors.primary
                          : AppColors.textHint,
                    ),
                    title: Text(p.nombre),
                    subtitle: p.direccion != null ? Text(p.direccion!) : null,
                    onTap: () {
                      vm.selectProyecto(p);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
