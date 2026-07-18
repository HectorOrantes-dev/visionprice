import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../providers/collaboration_providers.dart';
import 'active_invitations_screen.dart';
import 'generate_invitation_screen.dart';

class ProjectMembersScreen extends ConsumerWidget {
  final int proyectoId;

  const ProjectMembersScreen({super.key, required this.proyectoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final asyncValue = ref.watch(miembrosProvider(proyectoId));

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Colaboradores'),
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(miembrosProvider(proyectoId).notifier).recargar(),
          ),
        ],
      ),
      body: asyncValue.when(
        data: (result) {
          final miembros = result.miembros;
          final esDueno = result.esDueno;

          return Column(
            children: [
              if (esDueno)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GenerateInvitationScreen(proyectoId: proyectoId),
                              ),
                            );
                          },
                          icon: const Icon(Icons.person_add),
                          label: const Text('Invitar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            foregroundColor: colors.textOnPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ActiveInvitationsScreen(proyectoId: proyectoId),
                              ),
                            );
                          },
                          icon: const Icon(Icons.qr_code),
                          label: const Text('Códigos'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colors.primary,
                            side: BorderSide(color: colors.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: miembros.isEmpty
                    ? Center(child: Text('No hay miembros', style: TextStyle(color: colors.textSecondary)))
                    : ListView.builder(
                        itemCount: miembros.length,
                        itemBuilder: (context, index) {
                          final miembro = miembros[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: colors.surfaceVariant,
                              child: Text(miembro.nombre.substring(0, 1).toUpperCase(),
                                  style: TextStyle(color: colors.textPrimary)),
                            ),
                            title: Text(miembro.nombre, style: TextStyle(color: colors.textPrimary)),
                            subtitle: Text('${miembro.correo}\n${miembro.rolEnProyecto.label}',
                                style: TextStyle(color: colors.textSecondary)),
                            isThreeLine: true,
                            trailing: (esDueno && !miembro.esDueno)
                                ? IconButton(
                                    icon: Icon(Icons.remove_circle_outline, color: colors.error),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (c) => AlertDialog(
                                          title: const Text('Quitar miembro'),
                                          content: Text('¿Seguro que deseas quitar a ${miembro.nombre}?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(c, false),
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(c, true),
                                              child: const Text('Quitar', style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        try {
                                          await ref.read(miembrosProvider(proyectoId).notifier).quitarMiembro(miembro.usuarioId);
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Miembro quitado')));
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: colors.error));
                                          }
                                        }
                                      }
                                    },
                                  )
                                : null,
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => Center(child: CircularProgressIndicator(color: colors.primary)),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: colors.error, size: 48),
              const SizedBox(height: 16),
              Text(err.toString(), style: TextStyle(color: colors.textPrimary), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
