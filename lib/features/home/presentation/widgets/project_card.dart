import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../collaboration/presentation/screens/project_members_screen.dart';
import '../../../project/domain/entities/proyecto_entity.dart';

/// Tarjeta de un proyecto real del usuario.
class ProjectCard extends StatelessWidget {
  final ProyectoEntity proyecto;
  const ProjectCard({super.key, required this.proyecto});

  @override
  Widget build(BuildContext context) {
    final estadoColor = _estadoColor(context, proyecto.estado);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      // Enganche de preview (colaboración): abre los miembros del proyecto.
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProjectMembersScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.folder_outlined,
                  size: 18, color: context.colors.textSecondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    proyecto.nombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _subtitle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: estadoColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _capitalize(proyecto.estado),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: estadoColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _subtitle() {
    final dir = proyecto.direccion;
    final presupuestos = proyecto.totalPresupuestos == 1
        ? '1 presupuesto'
        : '${proyecto.totalPresupuestos} presupuestos';
    if (dir != null && dir.isNotEmpty) return '$dir · $presupuestos';
    return presupuestos;
  }

  static Color _estadoColor(BuildContext context, String estado) {
    switch (estado.toLowerCase()) {
      case 'completado':
      case 'terminado':
        return context.colors.success;
      case 'borrador':
      case 'pausado':
        return context.colors.textSecondary;
      default:
        return context.colors.primary; // activo / en proceso
    }
  }

  static String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
