import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../mock/collab_mock_data.dart';
import '../models/invitation_vm.dart';
import '../widgets/collab_empty_state.dart';
import '../widgets/invitation_tile.dart';

/// Códigos de invitación activos (mock). Se pueden revocar (solo UI: se quitan
/// de la lista local en memoria).
class ActiveInvitationsScreen extends StatefulWidget {
  const ActiveInvitationsScreen({super.key});

  @override
  State<ActiveInvitationsScreen> createState() =>
      _ActiveInvitationsScreenState();
}

class _ActiveInvitationsScreenState extends State<ActiveInvitationsScreen> {
  final List<InvitationVM> _codigos = List.of(CollabMock.invitaciones);

  Future<void> _confirmarRevocar(InvitationVM inv) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Revocar código'),
        content: Text('El código ${inv.codigo} dejará de funcionar. '
            '¿Revocarlo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: context.colors.error),
            child: const Text('Revocar'),
          ),
        ],
      ),
    );
    if (ok == true) setState(() => _codigos.remove(inv));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: BackButton(color: context.colors.textPrimary),
        title: Text('Códigos activos',
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            )),
      ),
      body: SafeArea(
        child: _codigos.isEmpty
            ? CollabEmptyState(
                icon: Icons.qr_code_2,
                title: 'No hay códigos activos',
                message:
                    'Genera un código de invitación para que otros se unan al proyecto.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _codigos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => InvitationTile(
                  invitation: _codigos[i],
                  onRevoke: () => _confirmarRevocar(_codigos[i]),
                ),
              ),
      ),
    );
  }
}
