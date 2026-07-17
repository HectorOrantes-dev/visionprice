import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/location_service_provider.dart';
import '../../../../core/network/api_exception.dart';
import '../../../budget/presentation/providers/cotizacion_wizard_provider.dart';
import '../../domain/entities/recomendacion_kit_entity.dart';
import 'recomendacion_providers.dart';

part 'recomendacion_superficie_provider.g.dart';

/// Vecinos a considerar en el K-NN.
const int kRecomendacionVecinos = 15;

/// Recomendación de kit **por superficie** (family: proyectoId + índice).
///
/// No se pide sola: arranca en `null` y solo consulta cuando el usuario pulsa
/// "Usar recomendados" ([pedir]). Al llegar la respuesta:
///  - aplica el `metodo_crucetas_recomendado` a esa superficie, y
///  - guarda el `recomendacion_id` en el wizard, que lo devuelve en
///    `POST /cotizaciones/kit` para cerrar el loop.
@riverpod
class RecomendacionSuperficie extends _$RecomendacionSuperficie {
  @override
  FutureOr<RecomendacionKitEntity?> build(int proyectoId, int index) => null;

  Future<void> pedir({
    required String categoria,
    required double areaM2,
  }) async {
    state = const AsyncLoading<RecomendacionKitEntity?>();
    state = await AsyncValue.guard<RecomendacionKitEntity?>(() async {
      // Misma ubicación real que se usa para GET /cotizaciones/productos.
      final ubic = await ref.read(locationServiceProvider).current();
      if (ubic == null) {
        throw ApiException.network(
            'Activa la ubicación para usar la recomendación de tu zona.');
      }
      return ref.read(obtenerRecomendacionKitUseCaseProvider)(
        lat: ubic.lat,
        lng: ubic.lng,
        categoria: categoria,
        areaM2: areaM2,
        proyectoId: proyectoId,
        k: kRecomendacionVecinos,
      );
    });

    // Solo si trajo datos (si falló, el estado es AsyncError y no se aplica nada).
    final r = state.value;
    if (r == null) return;

    final wizard = ref.read(cotizacionWizardProvider(proyectoId).notifier);
    // "Usar recomendados": se aplica lo accionable (el método de crucetas). Los
    // complementos son categorías: el producto concreto lo sigue eligiendo el
    // usuario, la tarjeta solo le indica cuáles se sugieren.
    if (r.metodoCrucetasRecomendado.isNotEmpty) {
      wizard.seleccionarKitMetodo(index, r.metodoCrucetasRecomendado);
    }
    // Solo se guarda si esta superficie realmente pidió recomendación.
    if (r.recomendacionId != null) {
      wizard.setRecomendacionId(index, r.recomendacionId!);
    }
  }
}
