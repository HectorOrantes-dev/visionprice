import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/member_vm.dart';
import 'owner_badge.dart';
import 'role_chip.dart';

/// Ítem de la lista de miembros: avatar de iniciales + nombre + correo +
/// chip de rol (o badge "Dueño"), y acción "Quitar" opcional.
class MemberTile extends StatelessWidget {
  final MemberVM member;

  /// Si no es null, se muestra el botón "Quitar" (solo lo ve el dueño sobre
  /// los demás miembros).
  final VoidCallback? onRemove;

  const MemberTile({super.key, required this.member, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.colors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Text(
              member.iniciales,
              style: AppTextStyles.heading(
                  size: 15, color: context.colors.primary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        member.nombre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.heading(
                            size: 15,
                            weight: FontWeight.w700,
                            color: context.colors.textPrimary),
                      ),
                    ),
                    if (member.esDueno) ...[
                      const SizedBox(width: 8),
                      const OwnerBadge(),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  member.correo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12, color: context.colors.textSecondary),
                ),
                const SizedBox(height: 8),
                if (!member.esDueno) RoleChip(rol: member.rol),
              ],
            ),
          ),
          if (onRemove != null && !member.esDueno)
            IconButton(
              tooltip: 'Quitar',
              icon: Icon(Icons.person_remove_outlined,
                  size: 20, color: context.colors.error),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}
