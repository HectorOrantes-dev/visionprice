import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_exception.dart';
import '../../../recording/domain/entities/superficie_entity.dart';
import '../../domain/entities/cotizacion_entity.dart';
import '../../domain/entities/item_cotizacion.dart';
import '../../domain/entities/producto_entity.dart';
import '../../domain/entities/superficie_kit_item.dart';
import 'budget_providers.dart';
import 'cotizacion_wizard_state.dart';

export 'cotizacion_wizard_state.dart';

part 'cotizacion_wizard_provider.g.dart';

/// Notifier `.family` (por `proyectoId`) del flujo "superficies detectadas →
/// elegir material (simple/kit) → resumen → cotización". Sobrevive la
/// navegación entre las pantallas del wizard porque las rutas van con
/// `Navigator.push` (las de abajo del stack siguen montadas y observando el
/// provider), igual que `Parameters` en parameters_provider.dart.
@riverpod
class CotizacionWizard extends _$CotizacionWizard {
  @override
  CotizacionWizardState build(int proyectoId) => const CotizacionWizardState();

  /// Carga las superficies detectadas y las reglas por categoría
  /// (`GET /cotizaciones/materiales`), una sola vez al entrar al flujo.
  Future<void> cargar(List<SuperficieEntity> superficies) async {
    state = state.copyWith(superficies: superficies, loading: true, clearError: true);
    try {
      final reglas = await ref.read(obtenerMaterialesUseCaseProvider)();
      state = state.copyWith(
        reglas: {for (final r in reglas) r.categoria.toLowerCase().trim(): r},
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        errorMessage: e is ApiException ? e.message : 'No se pudieron cargar las reglas de materiales.',
      );
    }
  }

  void seleccionarSimple(int i, ProductoEntity producto) {
    final next = Map<int, ProductoEntity>.from(state.seleccionSimple);
    next[i] = producto;
    state = state.copyWith(seleccionSimple: next);
  }

  KitSeleccion _kitDe(int i) => state.seleccionKit[i] ?? const KitSeleccion();

  void _setKit(int i, KitSeleccion kit) {
    final next = Map<int, KitSeleccion>.from(state.seleccionKit);
    next[i] = kit;
    state = state.copyWith(seleccionKit: next);
  }

  void seleccionarKitPrincipal(int i, ProductoEntity producto) =>
      _setKit(i, _kitDe(i).copyWith(principal: producto));

  void seleccionarKitMetodo(int i, String metodo) =>
      _setKit(i, _kitDe(i).copyWith(metodo: metodo));

  void seleccionarKitAdhesivo(int i, ProductoEntity producto) =>
      _setKit(i, _kitDe(i).copyWith(adhesivo: producto));

  void seleccionarKitCruceta(int i, ProductoEntity producto) =>
      _setKit(i, _kitDe(i).copyWith(cruceta: producto));

  void seleccionarKitBoquilla(int i, ProductoEntity producto) =>
      _setKit(i, _kitDe(i).copyWith(boquilla: producto));

  /// Captura la **tarifa de mano de obra por m²** para materiales SIMPLES
  /// (pintura). El total se calcula al crear: tarifa × área.
  void setManoObraSimple(double? valor) =>
      state = state.copyWith(manoObraSimple: valor);

  /// Captura la **tarifa de mano de obra por m²** para el KIT (piso/azulejo).
  void setManoObraKit(double? valor) =>
      state = state.copyWith(manoObraKit: valor);

  /// Crea 1 o 2 cotizaciones (simples / kit) según las superficies. Devuelve
  /// la lista de cotizaciones creadas (vacía si algo falló; ver `errorMessage`).
  Future<List<CotizacionEntity>> crearCotizaciones() async {
    final itemsSimples = <ItemCotizacion>[];
    final superficiesKit = <SuperficieKitItem>[];
    // Áreas acumuladas por tipo, para convertir la tarifa por m² en total.
    var areaSimple = 0.0;
    var areaKit = 0.0;

    for (var i = 0; i < state.superficies.length; i++) {
      final sup = state.superficies[i];
      final regla = state.reglaDe(i);
      if (!regla.requiereKit) {
        final producto = state.seleccionSimple[i];
        if (producto == null) continue;
        areaSimple += sup.areaM2;
        itemsSimples.add(ItemCotizacion(
          productoId: producto.productoId,
          areaM2: sup.areaM2,
          descripcion: sup.descripcion,
        ));
      } else {
        final kit = state.seleccionKit[i];
        if (kit?.principal == null) continue;
        areaKit += sup.areaM2;
        superficiesKit.add(SuperficieKitItem(
          areaM2: sup.areaM2,
          principalProductoId: kit!.principal!.productoId,
          descripcion: sup.descripcion,
          metodoCrucetas: kit.metodo,
          adhesivoProductoId: kit.adhesivo?.productoId,
          cruecetaProductoId: kit.cruceta?.productoId,
          boquillaProductoId: kit.boquilla?.productoId,
        ));
      }
    }

    // Tarifa por m² → total de mano de obra que espera el back-end.
    final tarifaSimple = state.manoObraSimple;
    final tarifaKit = state.manoObraKit;
    final manoObraSimpleTotal =
        tarifaSimple != null ? tarifaSimple * areaSimple : null;
    final manoObraKitTotal = tarifaKit != null ? tarifaKit * areaKit : null;

    state = state.copyWith(creando: true, clearError: true);
    final creadas = <CotizacionEntity>[];
    try {
      if (itemsSimples.isNotEmpty) {
        creadas.add(await ref.read(crearCotizacionUseCaseProvider)(
          proyectoId: proyectoId,
          manoObra: manoObraSimpleTotal,
          items: itemsSimples,
        ));
      }
      if (superficiesKit.isNotEmpty) {
        creadas.add(await ref.read(crearCotizacionKitUseCaseProvider)(
          proyectoId: proyectoId,
          manoObra: manoObraKitTotal,
          superficies: superficiesKit,
        ));
      }
      state = state.copyWith(creando: false, cotizacionesCreadas: creadas);
      return creadas;
    } catch (e) {
      state = state.copyWith(
        creando: false,
        errorMessage: e is ApiException ? e.message : 'No se pudo crear la cotización.',
      );
      return const [];
    }
  }
}
