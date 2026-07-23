import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/location_service_provider.dart';
import '../../../../core/network/api_exception.dart';
import '../../../budget/domain/entities/producto_entity.dart';
import '../../../budget/presentation/providers/cotizacion_wizard_provider.dart';
import '../../domain/entities/recomendacion_kit_entity.dart';
import 'recomendacion_providers.dart';

part 'recomendacion_superficie_provider.g.dart';

/// Vecinos a considerar en el K-NN.
const int kRecomendacionVecinos = 15;

/// Recomendación de kit **por superficie** (family: proyectoId + índice).
///
/// No se pide sola: arranca en `null` y solo consulta cuando el usuario pulsa
/// "Usar recomendados" ([pedir]). Al llegar la respuesta **autollena** los
/// widgets del kit de esa superficie con los productos más cercanos que sugiere
/// el modelo (principal + pegazulejo + cruceta + emboquillado), aplica el método
/// de crucetas y guarda el `recomendacion_id` (se devuelve en
/// `POST /cotizaciones/kit` para cerrar el loop). El usuario puede cambiar
/// cualquiera después: es autocompletado, no una imposición.
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

    // Autollenar cada widget con el primer producto recomendado (más cercano).
    // Si una categoría vino vacía/ausente, ese widget queda para elegir a mano.
    final principal = _producto(r, categoria); // azulejo / piso / zoclo
    if (principal != null) wizard.seleccionarKitPrincipal(index, principal);

    final pegazulejo = _producto(r, 'pegazulejo');
    if (pegazulejo != null) wizard.seleccionarKitAdhesivo(index, pegazulejo);

    final cruceta = _producto(r, 'cruceta');
    if (cruceta != null) wizard.seleccionarKitCruceta(index, cruceta);

    final emboquillado = _producto(r, 'emboquillado');
    if (emboquillado != null)
      wizard.seleccionarKitBoquilla(index, emboquillado);

    if (r.metodoCrucetasRecomendado.isNotEmpty) {
      wizard.seleccionarKitMetodo(index, r.metodoCrucetasRecomendado);
    }
    // Solo se guarda si esta superficie realmente pidió recomendación.
    if (r.recomendacionId != null) {
      wizard.setRecomendacionId(index, r.recomendacionId!);
    }
  }

  /// Convierte el primer producto recomendado de [categoria] (JSON crudo) a
  /// [ProductoEntity], o `null` si no hay ninguno.
  ProductoEntity? _producto(RecomendacionKitEntity r, String categoria) {
    final json = r.primerProducto(categoria);
    return json == null ? null : ProductoEntity.fromJson(json);
  }
}
