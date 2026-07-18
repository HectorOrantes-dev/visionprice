import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/miembro_entity.dart';
import '../providers/collaboration_providers.dart';
import 'active_invitations_screen.dart';
import 'generate_invitation_screen.dart';

/// Miembros del proyecto (`GET /proyectos/{id}/miembros`). Si el usuario es
/// dueño puede invitar, ver códigos activos y quitar colaboradores.
class ProjectMembersScreen extends ConsumerWidget {
  final int proyectoId;
  const ProjectMembersScreen({super.key, required this.proyectoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final async = ref.watch(miembrosProvider(proyectoId));

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        elevation: 0,
        leading: BackButton(color: c.textPrimary),
        title: Text('Miembros del proyecto',
            style: TextStyle(
                color: c.textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _Error(
            texto: e is ApiException
                ? e.message
                : 'No se pudieron cargar los miembros.',
            onReintentar: () => ref.invalidate(miembrosProvider(proyectoId)),
          ),
          data: (result) {
            final miembros = result.miembros;
            final esDueno = result.esDueno;
            return Column(
              children: [
                if (esDueno)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GenerateInvitationScreen(
                                      proyectoId: proyectoId),
                                ),
                              ),
                              icon: const Icon(Icons.person_add_alt_1, size: 18),
                              label: const Text('Invitar'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ActiveInvitationsScreen(
                                      proyectoId: proyectoId),
                                ),
                              ),
                              icon: const Icon(Icons.qr_code_2, size: 18),
                              label: const Text('Códigos'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () =>
                        ref.read(miembrosProvider(proyectoId).notifier).recargar(),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: miembros.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final m = miembros[i];
                        return _MiembroTile(
                          miembro: m,
                          onQuitar: (esDueno && !m.esDueno)
                              ? () => _confirmarQuitar(context, ref, m)
                              : null,
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmarQuitar(
      BuildContext context, WidgetRef ref, MiembroEntity m) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: const Text('Quitar del proyecto'),
        content: Text('¿Seguro que quieres quitar a ${m.nombre} del proyecto?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(d, false),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(d, true),
            style: TextButton.styleFrom(foregroundColor: context.colors.error),
            child: const Text('Quitar'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(miembrosProvider(proyectoId).notifier).quitarMiembro(m.usuarioId);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Miembro quitado')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e is ApiException ? e.message : 'No se pudo quitar.'),
        ));
      }
    }
  }
}

class _MiembroTile extends StatelessWidget {
  final MiembroEntity miembro;
  final VoidCallback? onQuitar;
  const _MiembroTile({required this.miembro, this.onQuitar});

  String get _iniciales {
    final partes = miembro.nombre
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (partes.isEmpty) return '?';
    if (partes.length == 1) return partes.first.substring(0, 1).toUpperCase();
    return (partes.first.substring(0, 1) + partes[1].substring(0, 1))
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(color: c.primaryLight, shape: BoxShape.circle),
            child: Text(_iniciales,
                style: AppTextStyles.heading(size: 15, color: c.primary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(miembro.nombre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.heading(
                              size: 15,
                              weight: FontWeight.w700,
                              color: c.textPrimary)),
                    ),
                    if (miembro.esDueno) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: c.primaryLight,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text('Dueño',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: c.primary)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(miembro.correo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: c.textSecondary)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: c.surfaceVariant,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(miembro.rolEnProyecto.label,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: c.textSecondary)),
                ),
              ],
            ),
          ),
          if (onQuitar != null)
            IconButton(
              tooltip: 'Quitar',
              icon: Icon(Icons.person_remove_outlined, size: 20, color: c.error),
              onPressed: onQuitar,
            ),
        ],
      ),
    );
  }
}

class _Error extends StatelessWidget {
  final String texto;
  final VoidCallback onReintentar;
  const _Error({required this.texto, required this.onReintentar});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 44, color: c.error),
            const SizedBox(height: 12),
            Text(texto,
                textAlign: TextAlign.center,
                style: TextStyle(color: c.textSecondary)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onReintentar,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
