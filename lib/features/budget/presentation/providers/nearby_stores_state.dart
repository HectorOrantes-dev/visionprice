import '../../../recording/domain/entities/superficie_entity.dart';
import '../../domain/entities/producto_entity.dart';

/// Estado inmutable de "Ferreterías cercanas".
class NearbyStoresState {
  final bool loading;
  final bool creating;
  final bool usandoUbicacionAprox;
  final String? errorMessage;
  final List<ProductoEntity> productos;
  final List<SuperficieEntity>? superficies;
  final bool showUpdatePrompt;

  /// Legacy: producto_id (string) → 'piso' | 'paredes'.
  final Map<String, String> seleccionLegacy;

  /// Nuevo: SuperficieEntity → producto_id (string).
  final Map<SuperficieEntity, String> seleccionNueva;

  const NearbyStoresState({
    this.loading = true,
    this.creating = false,
    this.usandoUbicacionAprox = false,
    this.errorMessage,
    this.productos = const [],
    this.superficies,
    this.showUpdatePrompt = false,
    this.seleccionLegacy = const {},
    this.seleccionNueva = const {},
  });

  int get seleccionados => (superficies != null && superficies!.isNotEmpty)
      ? seleccionNueva.length
      : seleccionLegacy.length;

  bool isLegacySelected(String productoId, String aplicarA) =>
      seleccionLegacy[productoId] == aplicarA;

  bool isNuevaSelected(String productoId, SuperficieEntity sup) =>
      seleccionNueva[sup] == productoId;

  static const _keep = Object();

  NearbyStoresState copyWith({
    bool? loading,
    bool? creating,
    bool? usandoUbicacionAprox,
    Object? errorMessage = _keep,
    List<ProductoEntity>? productos,
    Object? superficies = _keep,
    bool? showUpdatePrompt,
    Map<String, String>? seleccionLegacy,
    Map<SuperficieEntity, String>? seleccionNueva,
  }) {
    return NearbyStoresState(
      loading: loading ?? this.loading,
      creating: creating ?? this.creating,
      usandoUbicacionAprox: usandoUbicacionAprox ?? this.usandoUbicacionAprox,
      errorMessage:
          errorMessage == _keep ? this.errorMessage : errorMessage as String?,
      productos: productos ?? this.productos,
      superficies: superficies == _keep
          ? this.superficies
          : superficies as List<SuperficieEntity>?,
      showUpdatePrompt: showUpdatePrompt ?? this.showUpdatePrompt,
      seleccionLegacy: seleccionLegacy ?? this.seleccionLegacy,
      seleccionNueva: seleccionNueva ?? this.seleccionNueva,
    );
  }
}
