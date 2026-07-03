import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../project/domain/entities/proyecto_entity.dart';

/// Tarjeta de un proyecto del usuario en la home. Antes el privado `_ProjectCard`.
class HomeProjectCard extends StatelessWidget {
  final ProyectoEntity proyecto;
  const HomeProjectCard({super.key, required this.proyecto});

  @override
  Widget build(BuildContext context) {
    final estadoColor = _estadoColor(proyecto.estado);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.folder_outlined,
                size: 18, color: AppColors.textSecondary),
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _subtitle(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
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

  static Color _estadoColor(String estado) {
    // Estados que devuelve el back-end: activo | finalizado | cancelado
    // (más algunos alias tolerados por compatibilidad).
    switch (estado.toLowerCase()) {
      case 'finalizado':
      case 'completado':
      case 'terminado':
        return AppColors.success;
      case 'cancelado':
        return AppColors.error;
      case 'borrador':
      case 'pausado':
        return AppColors.textSecondary;
      default:
        return AppColors.primary; // activo / en proceso
    }
  }

  static String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
