import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/entrenamiento_entity.dart';
import 'entrenamiento_stat_row.dart';

/// Resultado del entrenamiento. Destaca `n_obras_reales`: si es 0, ninguna obra
/// del usuario entró al dataset (les falta ubicación) y se avisa.
class EntrenamientoResultCard extends StatelessWidget {
  final EntrenamientoEntity resultado;
  const EntrenamientoResultCard({super.key, required this.resultado});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sinReales = resultado.nObrasReales == 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.border),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle, color: c.success, size: 20),
                  const SizedBox(width: 8),
                  Text('Modelos entrenados',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      )),
                ],
              ),
              const SizedBox(height: 8),
              Divider(color: c.divider, height: 1),
              const SizedBox(height: 4),
              EntrenamientoStatRow(
                label: 'Obras reales (con ubicación)',
                value: '${resultado.nObrasReales}',
                destacar: true,
              ),
              EntrenamientoStatRow(
                label: 'Obras sintéticas',
                value: '${resultado.nObrasSinteticas}',
              ),
              EntrenamientoStatRow(
                label: 'Total de obras',
                value: '${resultado.nObras}',
              ),
              EntrenamientoStatRow(
                label: 'Precisión (árbol tipo de kit)',
                value:
                    '${(resultado.accuracyArbolTipoKit * 100).toStringAsFixed(1)}%',
              ),
            ],
          ),
        ),
        if (sinReales) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: c.warningLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 16, color: c.warning),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ninguna obra real entró al entrenamiento: para que cuenten, '
                    'las obras necesitan ubicación. Agrégala desde Inicio en las '
                    'obras que digan "Sin ubicación".',
                    style: TextStyle(
                        fontSize: 12, color: c.warning, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
