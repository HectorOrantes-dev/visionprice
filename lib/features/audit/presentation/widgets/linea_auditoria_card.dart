import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/linea_auditoria_entity.dart';

const _severidadLabel = {
  'sin_datos': 'Sin datos',
  'normal': 'Normal',
  'revisar': 'Revisar',
  'critico': 'Crítico',
};

/// Tarjeta de una línea auditada: precio, severidad y (expandible) las
/// razones + el rango normal de la zona, cuando hay histórico suficiente.
class LineaAuditoriaCard extends StatefulWidget {
  final LineaAuditoriaEntity linea;
  const LineaAuditoriaCard({super.key, required this.linea});

  @override
  State<LineaAuditoriaCard> createState() => _LineaAuditoriaCardState();
}

class _LineaAuditoriaCardState extends State<LineaAuditoriaCard> {
  bool _expandido = false;

  Color _color(BuildContext context, String severidad) => switch (severidad) {
        'critico' => context.colors.error,
        'revisar' => context.colors.warning,
        'normal' => context.colors.success,
        _ => context.colors.textSecondary,
      };

  Color _colorClaro(BuildContext context, String severidad) =>
      switch (severidad) {
        'critico' => context.colors.errorLight,
        'revisar' => context.colors.warningLight,
        'normal' => context.colors.successLight,
        _ => context.colors.surfaceVariant,
      };

  @override
  Widget build(BuildContext context) {
    final l = widget.linea;
    final a = l.analisis;
    final color = _color(context, a.severidad);

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: a.razones.isEmpty
            ? null
            : () => setState(() => _expandido = !_expandido),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.descripcion,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: context.colors.textPrimary)),
                        const SizedBox(height: 4),
                        Text('\$${l.precioUnitario.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: context.colors.textPrimary)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _colorClaro(context, a.severidad),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _severidadLabel[a.severidad] ?? a.severidad,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: color),
                    ),
                  ),
                ],
              ),
              if (a.mediana != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Mediana de la zona: \$${a.mediana!.toStringAsFixed(2)}'
                  '${a.limiteInferior != null && a.limiteSuperior != null ? ' · rango [\$${a.limiteInferior!.toStringAsFixed(2)} – \$${a.limiteSuperior!.toStringAsFixed(2)}]' : ''}',
                  style: TextStyle(
                      fontSize: 12, color: context.colors.textSecondary),
                ),
              ],
              if (_expandido) ...[
                const SizedBox(height: 8),
                Divider(height: 1, color: context.colors.divider),
                const SizedBox(height: 8),
                for (final r in a.razones)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('• $r',
                        style: TextStyle(
                            fontSize: 12, color: context.colors.textPrimary)),
                  ),
              ] else if (a.razones.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text('Toca para ver el detalle',
                    style: TextStyle(
                        fontSize: 11, color: context.colors.textHint)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
