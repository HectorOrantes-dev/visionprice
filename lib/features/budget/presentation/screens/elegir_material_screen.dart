import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../providers/cotizacion_wizard_provider.dart';
import '../widgets/kit_body.dart';
import '../widgets/material_header.dart';
import '../widgets/producto_picker.dart';

/// 02/03 · Elegir material — misma pantalla para "simple" (un producto) y
/// "kit" (loseta principal + método + complementos), según lo que diga la
/// regla de esa categoría (`GET /cotizaciones/materiales`).
class ElegirMaterialScreen extends ConsumerWidget {
  final int proyectoId;
  final int index;
  const ElegirMaterialScreen(
      {super.key, required this.proyectoId, required this.index});

  static String _fmtArea(double a) =>
      a.truncateToDouble() == a ? a.toStringAsFixed(0) : a.toStringAsFixed(1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizard = ref.watch(cotizacionWizardProvider(proyectoId));
    final notifier = ref.read(cotizacionWizardProvider(proyectoId).notifier);
    final sup = wizard.superficies[index];
    final regla = wizard.reglaDe(index);
    final titulo = 'Elegir ${sup.categoria}';
    final subtitulo = '${sup.descripcion} · ${_fmtArea(sup.areaM2)} m²';

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            MaterialHeader(titulo: titulo, subtitulo: subtitulo),
            Expanded(
              child: regla.requiereKit
                  ? KitBody(proyectoId: proyectoId, index: index)
                  : ProductoPicker(
                      categoria: sup.categoria,
                      seleccionado: wizard.seleccionSimple[index],
                      onConfirm: (p) {
                        notifier.seleccionarSimple(index, p);
                        Navigator.pop(context);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
