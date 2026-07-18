import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../mock/collab_mock_data.dart';
import '../models/member_vm.dart';
import '../widgets/collab_empty_state.dart';
import '../widgets/member_tile.dart';
import 'active_invitations_screen.dart';
import 'generate_invitation_screen.dart';

/// Miembros del proyecto (mock). El dueño puede invitar, ver códigos activos y
/// quitar colaboradores. Estado local: la lista de miembros es mutable en
/// memoria para simular "quitar" (sin backend).
class ProjectMembersScreen extends StatefulWidget {
  const ProjectMembersScreen({super.key});

  @override
  State<ProjectMembersScreen> createState() => _ProjectMembersScreenState();
}

class _ProjectMembersScreenState extends State<ProjectMembersScreen> {
  final List<MemberVM> _members = List.of(CollabMock.miembros);

  Future<void> _confirmarQuitar(MemberVM member) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quitar del proyecto'),
        content: Text(
            '¿Seguro que quieres quitar a ${member.nombre} del proyecto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: context.colors.error),
            child: const Text('Quitar'),
          ),
        ],
      ),
    );
    if (ok == true) {
      setState(() => _members.remove(member));
    }
  }

  @override
  Widget build(BuildContext context) {
    final soloDueno = _members.where((m) => !m.esDueno).isEmpty;
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: BackButton(color: context.colors.textPrimary),
        title: Text('Miembros del proyecto',
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            )),
        actions: [
          IconButton(
            tooltip: 'Códigos activos',
            icon: Icon(Icons.qr_code_2, color: context.colors.primary),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const ActiveInvitationsScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  Icon(Icons.folder_outlined,
                      size: 18, color: context.colors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      CollabMock.proyectoNombre,
                      style: TextStyle(
                          fontSize: 13, color: context.colors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: soloDueno
                  ? CollabEmptyState(
                      icon: Icons.group_add_outlined,
                      title: 'Aún trabajas solo aquí',
                      message:
                          'Invita colaboradores con un código para que se unan al proyecto.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _members.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final m = _members[i];
                        return MemberTile(
                          member: m,
                          onRemove: m.esDueno ? null : () => _confirmarQuitar(m),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
              child: GradientButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const GenerateInvitationScreen()),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_add_alt_1, size: 18, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Invitar'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
