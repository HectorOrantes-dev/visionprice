import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/invitacion_entity.dart';
import '../providers/collaboration_providers.dart';

/// Códigos de invitación activos del proyecto (`GET /proyectos/{id}/invitaciones`).
/// El dueño puede copiar o revocar cada uno.
class ActiveInvitationsScreen extends ConsumerWidget {
  final int proyectoId;
  const ActiveInvitationsScreen({super.key, required this.proyectoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final async = ref.watch(invitacionesProvider(proyectoId));

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        elevation: 0,
        leading: BackButton(color: c.textPrimary),
        title: Text('Códigos activos',
            style: TextStyle(
                color: c.textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _Mensaje(
            texto: e is ApiException
                ? e.message
                : 'No se pudieron cargar los códigos.',
            onReintentar: () => ref.invalidate(invitacionesProvider(proyectoId)),
          ),
          data: (invitaciones) {
            if (invitaciones.isEmpty) {
              return const _Mensaje(texto: 'No hay códigos activos.');
            }
            return RefreshIndicator(
              onRefresh: () =>
                  ref.read(invitacionesProvider(proyectoId).notifier).recargar(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: invitaciones.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _InvitacionTile(
                  inv: invitaciones[i],
                  onRevocar: () => _confirmarRevocar(context, ref, invitaciones[i]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmarRevocar(
      BuildContext context, WidgetRef ref, InvitacionEntity inv) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: const Text('Revocar código'),
        content: Text('El código ${inv.codigo} dejará de funcionar. ¿Revocarlo?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(d, false),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(d, true),
            style:
                TextButton.styleFrom(foregroundColor: context.colors.error),
            child: const Text('Revocar'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(invitacionesProvider(proyectoId).notifier).revocar(inv.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Código revocado')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e is ApiException ? e.message : 'No se pudo revocar.'),
        ));
      }
    }
  }
}

class _InvitacionTile extends StatelessWidget {
  final InvitacionEntity inv;
  final VoidCallback onRevocar;
  const _InvitacionTile({required this.inv, required this.onRevocar});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  inv.codigo,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
              _Chip(text: inv.rol.label),
              IconButton(
                icon: Icon(Icons.copy, size: 18, color: c.primary),
                tooltip: 'Copiar',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: inv.codigo));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Código copiado')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.schedule, size: 14, color: c.textSecondary),
              const SizedBox(width: 4),
              Text('Expira en ${_texto(inv.expiraEn)}',
                  style: TextStyle(fontSize: 12, color: c.textSecondary)),
              const SizedBox(width: 14),
              Icon(Icons.people_outline, size: 14, color: c.textSecondary),
              const SizedBox(width: 4),
              Text('Usos: ${inv.usos}',
                  style: TextStyle(fontSize: 12, color: c.textSecondary)),
              const Spacer(),
              TextButton(
                onPressed: onRevocar,
                style: TextButton.styleFrom(
                  foregroundColor: c.error,
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

  static String _texto(Duration d) {
    if (d.isNegative || d == Duration.zero) return 'Expirado';
    final days = d.inDays, h = d.inHours % 24, m = d.inMinutes % 60;
    if (days > 0) return '${days}d ${h}h';
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }
}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.surfaceVariant,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700, color: c.textSecondary)),
    );
  }
}

class _Mensaje extends StatelessWidget {
  final String texto;
  final VoidCallback? onReintentar;
  const _Mensaje({required this.texto, this.onReintentar});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(texto,
                textAlign: TextAlign.center,
                style: TextStyle(color: c.textSecondary)),
            if (onReintentar != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onReintentar,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
