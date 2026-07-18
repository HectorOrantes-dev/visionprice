import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/invitation_vm.dart';

/// Tarjeta con el código recién generado: el código grande + copiar/compartir
/// + "Multiuso · vigencia … · expira el …".
class InvitationCodeCard extends StatelessWidget {
  final InvitationVM invitation;
  const InvitationCodeCard({super.key, required this.invitation});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        children: [
          Text(
            'CÓDIGO DE INVITACIÓN',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: context.colors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              invitation.codigo,
              textAlign: TextAlign.center,
              style: AppTextStyles.heading(
                size: 24,
                color: context.colors.primaryDark,
              ).copyWith(fontFamily: 'monospace', letterSpacing: 2),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Multiuso · vigencia ${invitation.expiraEn.inDays} días · expira en ${invitation.expiraTexto}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: invitation.codigo));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Código copiado')),
                    );
                  },
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('Copiar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  // Solo UI (mock): la lógica de compartir se conecta después.
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Compartir (pendiente)')),
                  ),
                  icon: const Icon(Icons.share_outlined, size: 18),
                  label: const Text('Compartir'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
