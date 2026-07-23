import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/fecha_relativa.dart';
import '../../../budget/domain/entities/cotizacion_pdf_entity.dart';
import '../../../budget/presentation/providers/mis_pdfs_provider.dart';
import 'activity_placeholder.dart';
import 'activity_status_badge.dart';
import 'recent_activity_item.dart';

/// Sección "ACTIVIDAD RECIENTE" del Dashboard: muestra las últimas cotizaciones
/// del usuario (reutiliza los datos de "Mis Cotizaciones", `misPdfsProvider`).
///
/// [onVerTodo] lleva a la pestaña de Mis Cotizaciones.
class RecentActivitySection extends ConsumerWidget {
  /// Cuántos items se muestran en el resumen del inicio.
  static const _maxItems = 3;

  final VoidCallback? onVerTodo;

  const RecentActivitySection({super.key, this.onVerTodo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actividadAsync = ref.watch(misPdfsProvider);
    final c = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ACTIVIDAD RECIENTE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: c.textSecondary,
                  letterSpacing: 1.0,
                ),
              ),
              if (onVerTodo != null)
                InkWell(
                  onTap: onVerTodo,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      'Ver todo',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: c.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: c.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: actividadAsync.when(
              loading: () => const ActivityPlaceholder(
                child: Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              error: (_, __) => ActivityPlaceholder(
                child: Center(
                  child: Text(
                    'No se pudo cargar la actividad reciente.',
                    style: TextStyle(fontSize: 12.5, color: c.textSecondary),
                  ),
                ),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return ActivityPlaceholder(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Aún no hay actividad. Crea tu primer presupuesto por voz.',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 12.5, color: c.textSecondary),
                        ),
                      ),
                    ),
                  );
                }
                final visibles = items.take(_maxItems).toList();
                return Column(
                  children: [
                    for (var i = 0; i < visibles.length; i++)
                      _itemDe(context, visibles[i],
                          esUltimo: i == visibles.length - 1),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Convierte una cotización en una fila de actividad.
  Widget _itemDe(
    BuildContext context,
    CotizacionPdfEntity pdf, {
    required bool esUltimo,
  }) {
    final c = context.colors;
    final confirmado = pdf.estado.toLowerCase() == 'confirmado';
    final obra = pdf.proyectoNombre.isEmpty
        ? 'Obra #${pdf.proyectoId}'
        : pdf.proyectoNombre;

    return RecentActivityItem(
      icon: confirmado
          ? Icons.receipt_long_outlined
          : Icons.edit_note_outlined,
      title: 'Cotización #${pdf.numero} · $obra',
      subtitle: fechaRelativaActividad(pdf.fecha),
      showDivider: !esUltimo,
      onTap: onVerTodo,
      trailing: ActivityStatusBadge(
        label: confirmado ? 'Confirmada' : 'Borrador',
        color: confirmado ? c.success : c.textSecondary,
        background: confirmado ? c.successLight : c.surfaceVariant,
      ),
    );
  }
}


