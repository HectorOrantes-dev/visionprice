import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/cotizacion_wizard_provider.dart';
import '../screens/elegir_material_screen.dart';

/// Tarjeta de una superficie detectada, con su categoría, material elegido y
/// acceso a la pantalla de elegir material. Antes el privado `_SuperficieCard`.
class SuperficieCard extends StatelessWidget {
  final int proyectoId;
  final int index;
  final CotizacionWizardState state;
  const SuperficieCard({
    super.key,
    required this.proyectoId,
    required this.index,
    required this.state,
  });

  IconData get _icon {
    switch (state.superficies[index].categoria.toLowerCase().trim()) {
      case 'piso':
        return Icons.grid_view_rounded;
      case 'azulejo':
        return Icons.window_outlined;
      case 'zoclo':
        return Icons.straighten;
      case 'pintura':
      case 'impermeabilizante':
        return Icons.format_paint_outlined;
      default:
        return Icons.construction_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sup = state.superficies[index];
    final regla = state.reglaDe(index);
    final completa = state.superficieCompleta(index);
    final nombreElegido = regla.requiereKit
        ? state.seleccionKit[index]?.principal?.nombre
        : state.seleccionSimple[index]?.nombre;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ElegirMaterialScreen(proyectoId: proyectoId, index: index),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: context.colors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_icon, color: context.colors.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          sup.descripcion,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.heading(
                              size: 15,
                              weight: FontWeight.w700,
                              color: context.colors.textPrimary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: regla.requiereKit
                              ? context.colors.primaryLight
                              : context.colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          regla.requiereKit
                              ? 'Kit de instalación'
                              : 'Material simple',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: regla.requiereKit
                                ? context.colors.primary
                                : context.colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  if (completa && nombreElegido != null)
                    Row(
                      children: [
                        Icon(Icons.check_circle,
                            size: 14, color: context.colors.success),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            nombreElegido,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: context.colors.success),
                          ),
                        ),
                      ],
                    )
                  else
                    Text('Sin material elegido',
                        style: TextStyle(
                            fontSize: 12, color: context.colors.textHint)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${sup.areaM2.toStringAsFixed(sup.areaM2.truncateToDouble() == sup.areaM2 ? 0 : 1)} m²',
              style: AppTextStyles.heading(
                  size: 14,
                  weight: FontWeight.w800,
                  color: context.colors.primary),
            ),
            Icon(Icons.chevron_right, color: context.colors.textHint),
          ],
        ),
      ),
    );
  }
}
