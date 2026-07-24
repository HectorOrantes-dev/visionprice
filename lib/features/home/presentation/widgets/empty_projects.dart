import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../auth/presentation/providers/perfil_provider.dart';

/// Estado vacío de la lista de proyectos del dashboard.
///
/// El texto depende del rol: un `contratista` no graba presupuestos (ese
/// botón se le oculta), así que decirle "crea un proyecto para grabar" no
/// significaba nada para él — su razón para crear un proyecto es tener un
/// lugar donde invitar a su equipo.
class EmptyProjects extends ConsumerWidget {
  const EmptyProjects({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rol = ref.watch(perfilProvider).asData?.value.rol;
    final subtitulo = rol == 'contratista'
        ? 'Crea tu primer proyecto con el botón de abajo — ahí vas a poder invitar a tu equipo (maestro de obra) tocándolo.'
        : 'Crea tu primer proyecto con el botón de abajo para empezar a grabar presupuestos.';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          Icon(Icons.folder_open_outlined,
              size: 40, color: context.colors.textHint),
          const SizedBox(height: 12),
          Text(
            'Aún no tienes proyectos',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitulo,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: context.colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
