import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../models/invitation_vm.dart';
import 'role_chip.dart';

/// Ítem de la lista de códigos activos: código + rol + expira + usos + revocar.
class InvitationTile extends StatelessWidget {
  final InvitationVM invitation;
  final VoidCallback? onRevoke;

  const InvitationTile({super.key, required this.invitation, this.onRevoke});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  invitation.codigo,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
              RoleChip(rol: invitation.rol),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.schedule,
                  size: 14, color: context.colors.textSecondary),
              const SizedBox(width: 4),
              Text(
                'Expira en ${invitation.expiraTexto}',
                style: TextStyle(
                    fontSize: 12, color: context.colors.textSecondary),
              ),
              const SizedBox(width: 14),
              Icon(Icons.people_outline,
                  size: 14, color: context.colors.textSecondary),
              const SizedBox(width: 4),
              Text(
                'Usos: ${invitation.usos}',
                style: TextStyle(
                    fontSize: 12, color: context.colors.textSecondary),
              ),
              const Spacer(),
              if (onRevoke != null)
                TextButton(
                  onPressed: onRevoke,
                  style: TextButton.styleFrom(
                    foregroundColor: context.colors.error,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Revocar'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
