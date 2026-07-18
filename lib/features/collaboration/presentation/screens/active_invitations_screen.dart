import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../providers/collaboration_providers.dart';

class ActiveInvitationsScreen extends ConsumerWidget {
  final int proyectoId;

  const ActiveInvitationsScreen({super.key, required this.proyectoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final asyncValue = ref.watch(invitacionesProvider(proyectoId));

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Códigos de Invitación'),
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
      ),
      body: asyncValue.when(
        data: (invitaciones) {
          if (invitaciones.isEmpty) {
            return Center(
              child: Text('No hay invitaciones activas.', style: TextStyle(color: colors.textSecondary)),
            );
          }

          return ListView.builder(
            itemCount: invitaciones.length,
            itemBuilder: (context, index) {
              final inv = invitaciones[index];
              final expires = inv.expiraEn;
              final isExpired = expires.inSeconds <= 0;

              return Card(
                color: colors.surface,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            inv.codigo,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: colors.primary,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.copy, color: colors.primary),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: inv.codigo));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Código copiado')),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Rol: ${inv.rol.label}', style: TextStyle(color: colors.textPrimary)),
                      Text('Usos: ${inv.usos}', style: TextStyle(color: colors.textSecondary)),
                      Text(
                        isExpired
                            ? 'Expirado'
                            : 'Expira en: ${expires.inHours}h ${expires.inMinutes.remainder(60)}m',
                        style: TextStyle(
                          color: isExpired ? colors.error : colors.textSecondary,
                          fontWeight: isExpired ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(foregroundColor: colors.error),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (c) => AlertDialog(
                                title: const Text('Revocar invitación'),
                                content: const Text('El código ya no podrá usarse.'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancelar')),
                                  TextButton(
                                    onPressed: () => Navigator.pop(c, true),
                                    child: const Text('Revocar', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              try {
                                await ref.read(invitacionesProvider(proyectoId).notifier).revocar(inv.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invitación revocada')));
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: colors.error));
                                }
                              }
                            }
                          },
                          child: const Text('Revocar'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
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
