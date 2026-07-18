import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../providers/recording_provider.dart';

/// Bottom sheet para elegir un proyecto existente. Antes el privado
/// `_ProjectSheet` + la función `showProjectSheet`.
class ProjectSheet extends ConsumerWidget {
  const ProjectSheet({super.key});

  /// Abre el bottom sheet para elegir un proyecto existente o crear uno nuevo.
  static void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const ProjectSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recordingProvider);
    final notifier = ref.read(recordingProvider.notifier);
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
                color: context.colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Elige un proyecto',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (state.loadingProyectos)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (state.proyectos.isEmpty)
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
                          size: 18, color: context.colors.textSecondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Aún no tienes proyectos.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Créalos desde la pantalla de Inicio con "Crear nuevo proyecto" y vuelve aquí para seleccionarlo.',
                    style: TextStyle(
                      fontSize: 13,
                      color: context.colors.textSecondary,
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
                children: state.proyectos.map((p) {
                  final selected = state.selectedProyecto?.id == p.id;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      selected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: selected
                          ? context.colors.primary
                          : context.colors.textHint,
                    ),
                    title: Text(p.nombre),
                    subtitle: p.direccion != null ? Text(p.direccion!) : null,
                    onTap: () {
                      notifier.selectProyecto(p);
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
