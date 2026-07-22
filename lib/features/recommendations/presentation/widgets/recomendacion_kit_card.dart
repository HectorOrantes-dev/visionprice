import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_palette.dart';
import '../providers/recomendacion_superficie_provider.dart';
import 'buscando_recomendacion_card.dart';
import 'recomendacion_aviso.dart';
import 'recomendacion_linea.dart';

/// Bloque de recomendación para una superficie de KIT.
///
/// Arranca con el botón **"Usar recomendados"**: no consulta nada hasta que el
/// usuario lo pulsa. Al pulsarlo pide `POST /recomendaciones/kit`, aplica el
/// método de crucetas sugerido y guarda el `recomendacion_id` para devolverlo al
/// crear el kit.
class RecomendacionKitCard extends ConsumerWidget {
  final int proyectoId;
  final int index;
  final String categoria;
  final double areaM2;

  const RecomendacionKitCard({
    super.key,
    required this.proyectoId,
    required this.index,
    required this.categoria,
    required this.areaM2,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(recomendacionSuperficieProvider(proyectoId, index));
    final c = context.colors;

    void pedir() => ref
        .read(recomendacionSuperficieProvider(proyectoId, index).notifier)
        .pedir(categoria: categoria, areaM2: areaM2);

    return estado.when(
      loading: () => const BuscandoRecomendacionCard(),
      error: (e, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RecomendacionAviso(
            texto: e is ApiException
                ? e.message
                : 'No se pudo obtener la recomendación.',
          ),
          const SizedBox(height: 8),
          _boton(context, onPressed: pedir, reintento: true),
        ],
      ),
      data: (r) {
        // Aún no se pidió: solo el botón.
        if (r == null) {
          return _boton(context, onPressed: pedir);
        }
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: c.primaryLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: c.primary.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, size: 16, color: c.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Recomendación aplicada',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: c.primary,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  Text(
                    '${r.nObrasSimilares} obras similares',
                    style: TextStyle(fontSize: 10, color: c.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              RecomendacionLinea(label: 'Kit', valor: r.tipoKit),
              if (r.metodoCrucetasRecomendado.isNotEmpty)
                RecomendacionLinea(
                    label: 'Crucetas', valor: r.metodoCrucetasRecomendado),
              if (r.complementosRecomendados.isNotEmpty)
                RecomendacionLinea(
                  label: 'Complementos',
                  valor: r.complementosRecomendados.join(', '),
                ),
              if (r.zonaReferencia.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Zona: ${r.zonaReferencia}',
                  style: TextStyle(fontSize: 11, color: c.textSecondary),
                ),
              ],
              const SizedBox(height: 6),
              Text(
                'Puedes cambiar cualquier opción; esto es solo una sugerencia.',
                style: TextStyle(fontSize: 11, color: c.textSecondary),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _boton(
    BuildContext context, {
    required VoidCallback? onPressed,
    bool reintento = false,
  }) {
    return SizedBox(
      height: 46,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.auto_awesome, size: 18),
        label: Text(reintento ? 'Reintentar recomendación' : 'Usar recomendados'),
      ),
    );
  }
}
