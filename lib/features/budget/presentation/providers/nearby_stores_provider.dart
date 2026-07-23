import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/location_service_provider.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/services/location_service.dart';
import '../../../recording/domain/entities/superficie_entity.dart';
import '../../domain/categoria_material.dart';
import '../../domain/entities/cotizacion_entity.dart';
import '../../domain/entities/item_cotizacion.dart';
import 'budget_providers.dart';
import 'nearby_stores_state.dart';

export 'nearby_stores_state.dart';

part 'nearby_stores_provider.g.dart';

/// Notifier de "Ferreterías cercanas" (Riverpod moderno). Obtiene la ubicación,
/// lista los productos cercanos y permite elegir a qué superficie se aplica cada
/// uno para crear la cotización. Reemplaza al `NearbyStoresViewModel`.
@riverpod
class NearbyStores extends _$NearbyStores {
  int _proyectoId = 0;
  double? _pisoM2;
  double? _paredesM2;
  LatLng? _lastFetchPosition;
  StreamSubscription<LatLng>? _locationSub;

  @override
  NearbyStoresState build() {
    ref.onDispose(() => _locationSub?.cancel());
    return const NearbyStoresState();
  }

  Future<void> load({
    required int proyectoId,
    double? pisoM2,
    double? paredesM2,
    List<SuperficieEntity>? superficies,
  }) async {
    _proyectoId = proyectoId;
    _pisoM2 = pisoM2;
    _paredesM2 = paredesM2;
    state = state.copyWith(
      superficies: superficies,
      loading: true,
      errorMessage: null,
    );
    await _fetchProductos(onError: 'No se pudieron cargar las ferreterías.');
    _listenLocation();
  }

  Future<void> _fetchProductos({required String onError}) async {
    final location = ref.read(locationServiceProvider);
    try {
      final ubic = await location.current();
      _lastFetchPosition = ubic;
      final pos = ubic ?? LocationService.fallback;
      // Solo pedimos proveedores del material del item: derivamos las categorías
      // de las superficies (ej. "cambio de pintura" → "pintura") y las mandamos
      // al backend. Si no se identifica ninguna, `categoria` va null (sin filtro).
      final categorias = CategoriaMaterial.deSuperficies(state.superficies);
      final productos = await ref.read(obtenerProductosUseCaseProvider)(
          lat: pos.lat,
          lng: pos.lng,
          categoria: categorias.isEmpty ? null : categorias.join(','));
      state = state.copyWith(
        usandoUbicacionAprox: ubic == null,
        productos: productos,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        errorMessage: e is ApiException ? e.message : onError,
      );
    }
  }

  void _listenLocation() {
    _locationSub?.cancel();
    final location = ref.read(locationServiceProvider);
    final stream = location.getPositionStream();
    if (stream == null) return;
    _locationSub = stream.listen((newPos) {
      if (_lastFetchPosition != null) {
        final dist = location.distanceBetween(_lastFetchPosition!, newPos);
        if (dist > 500 && !state.showUpdatePrompt) {
          state = state.copyWith(showUpdatePrompt: true);
        }
      }
    });
  }

  Future<void> refetchLocation() async {
    state = state.copyWith(
        showUpdatePrompt: false, loading: true, errorMessage: null);
    await _fetchProductos(onError: 'No se pudo actualizar la ubicación.');
  }

  void toggleLegacy(String productoId, String aplicarA) {
    final next = Map<String, String>.from(state.seleccionLegacy);
    if (next[productoId] == aplicarA) {
      next.remove(productoId);
    } else {
      next[productoId] = aplicarA;
    }
    state = state.copyWith(seleccionLegacy: next);
  }

  void toggleNueva(String productoId, SuperficieEntity sup) {
    final next = Map<SuperficieEntity, String>.from(state.seleccionNueva);
    if (next[sup] == productoId) {
      next.remove(sup);
    } else {
      next[sup] = productoId;
    }
    state = state.copyWith(seleccionNueva: next);
  }

  Future<void> generar({
    required void Function(CotizacionEntity) onCreated,
  }) async {
    final usaNuevo = state.superficies != null && state.superficies!.isNotEmpty;
    List<ItemCotizacion> items;

    if (usaNuevo) {
      if (state.seleccionNueva.isEmpty) {
        state = state.copyWith(
            errorMessage:
                'Selecciona al menos un producto para una superficie.');
        return;
      }
      items = state.seleccionNueva.entries
          .map((e) => ItemCotizacion(
                productoId: e.value,
                areaM2: e.key.areaM2,
                descripcion: e.key.descripcion,
              ))
          .toList();
    } else {
      if (state.seleccionLegacy.isEmpty) {
        state = state.copyWith(
            errorMessage: 'Selecciona al menos un producto (piso o paredes).');
        return;
      }
      items = state.seleccionLegacy.entries
          .map((e) => ItemCotizacion(productoId: e.key, aplicarA: e.value))
          .toList();
    }

    state = state.copyWith(creating: true, errorMessage: null);
    try {
      final cotizacion = await ref.read(crearCotizacionUseCaseProvider)(
        proyectoId: _proyectoId,
        pisoM2: _pisoM2,
        paredesM2: _paredesM2,
        items: items,
      );
      onCreated(cotizacion);
    } catch (e) {
      state = state.copyWith(
        errorMessage:
            e is ApiException ? e.message : 'No se pudo crear la cotización.',
      );
    } finally {
      state = state.copyWith(creating: false);
    }
  }
}
