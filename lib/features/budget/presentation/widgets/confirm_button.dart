import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../recording/domain/entities/superficie_entity.dart';
import '../../../recording/presentation/providers/parameters_provider.dart';
import '../screens/borrador_cotizacion_screen.dart';
import '../screens/nearby_stores_screen.dart';
import '../screens/superficies_detectadas_screen.dart';

/// Botón "Confirmar y calcular materiales": guarda la edición y navega al flujo
/// de selección de materiales (nuevo por superficie) o al legacy de ferreterías.
class ConfirmButton extends ConsumerWidget {
  final int? grabacionId;
  final int? proyectoId;
  final double? pisoM2;
  final double? paredesM2;
  final List<SuperficieEntity>? superficies;
  final double? areaManualM2;
  const ConfirmButton({
    super.key,
    required this.grabacionId,
    required this.proyectoId,
    required this.pisoM2,
    required this.paredesM2,
    this.superficies,
    this.areaManualM2,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Se cotizan LOS DOS: las superficies del ML + la pared calculada a mano
    // (como una superficie de pintura extra), así ninguna se pierde.
    final superficiesCombinadas = <SuperficieEntity>[
      ...?superficies,
      if (areaManualM2 != null && areaManualM2! > 0)
        SuperficieEntity(
          tipo: 'pared',
          descripcion: 'Pared (medida a mano)',
          areaM2: areaManualM2!,
          categoria: 'pintura',
        ),
    ];
    // Necesitamos el proyecto (obligatorio para crear la cotización) y al menos
    // una superficie calculada.
    final hasNewFormat = superficiesCombinadas.isNotEmpty;
    final hasLegacyFormat = pisoM2 != null || paredesM2 != null;
    final enabled = proyectoId != null && (hasNewFormat || hasLegacyFormat);
    // El borrador automático (`POST /cotizaciones/borrador`) solo conoce lo
    // que el ML extrajo de ESA grabación: si el usuario además midió una
    // pared a mano (`areaManualM2`), esa superficie extra se perdería, así
    // que en ese caso se usa el flujo manual de siempre (que sí la combina).
    final tieneAreaManual = areaManualM2 != null && areaManualM2! > 0;
    final usarBorradorAutomatico =
        grabacionId != null && (superficies?.isNotEmpty ?? false) && !tieneAreaManual;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: enabled
              ? () async {
                  final id = grabacionId;
                  if (id != null) {
                    await ref
                        .read(parametersProvider(id).notifier)
                        .guardarEdicion(id);
                  }
                  if (context.mounted) {
                    // 1) Grabación con superficies del ML (sin mezcla manual):
                    //    borrador automático (producto+proveedor ya elegidos).
                    // 2) Con superficies pero mezcladas con área manual, o sin
                    //    grabacionId: flujo manual de siempre, por superficie.
                    // 3) Formato legacy plano piso_m2/paredes_m2: ferreterías
                    //    cercanas.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => usarBorradorAutomatico
                            ? BorradorCotizacionScreen(grabacionId: id!)
                            : hasNewFormat
                                ? SuperficiesDetectadasScreen(
                                    proyectoId: proyectoId!,
                                    superficies: superficiesCombinadas,
                                  )
                                : NearbyStoresScreen(
                                    proyectoId: proyectoId!,
                                    pisoM2: pisoM2,
                                    paredesM2: paredesM2,
                                    superficies: superficiesCombinadas,
                                  ),
                      ),
                    );
                  }
                }
              : null,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_forward, size: 18),
              SizedBox(width: 8),
              Text('Confirmar y calcular materiales'),
            ],
          ),
        ),
      ),
    );
  }
}
