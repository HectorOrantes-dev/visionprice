import '../../../recording/domain/entities/superficie_entity.dart';
import '../../domain/entities/cotizacion_entity.dart';
import '../../domain/entities/material_regla_entity.dart';
import '../../domain/entities/producto_entity.dart';

/// Selección de materiales de una superficie tipo KIT (loseta/piso/azulejo/zoclo).
class KitSeleccion {
  final ProductoEntity? principal;
  final String metodo; // 'interseccion' | 'tradicional' | 'nivelacion'
  final ProductoEntity? adhesivo;
  final ProductoEntity? cruceta;
  final ProductoEntity? boquilla;

  const KitSeleccion({
    this.principal,
    this.metodo = 'tradicional',
    this.adhesivo,
    this.cruceta,
    this.boquilla,
  });

  KitSeleccion copyWith({
    ProductoEntity? principal,
    String? metodo,
    ProductoEntity? adhesivo,
    ProductoEntity? cruceta,
    ProductoEntity? boquilla,
  }) =>
      KitSeleccion(
        principal: principal ?? this.principal,
        metodo: metodo ?? this.metodo,
        adhesivo: adhesivo ?? this.adhesivo,
        cruceta: cruceta ?? this.cruceta,
        boquilla: boquilla ?? this.boquilla,
      );
}

class CotizacionWizardState {
  final List<SuperficieEntity> superficies;
  final Map<String, MaterialReglaEntity> reglas;
  final Map<int, ProductoEntity> seleccionSimple;
  final Map<int, KitSeleccion> seleccionKit;

  /// `recomendacion_id` que devolvió el back-end por superficie (índice), cuando
  /// el usuario pidió "Usar recomendados". Se devuelve al crear el kit para
  /// cerrar el loop; si no pidió recomendación, la superficie no está aquí.
  final Map<int, int> recomendacionIds;

  /// Mano de obra (costo) que el usuario captura para la cotización de
  /// materiales SIMPLES (ej. cambio de pintura). `null` = sin capturar.
  final double? manoObraSimple;

  /// Mano de obra (costo) para la cotización tipo KIT (ej. cambio de piso).
  final double? manoObraKit;
  final bool loading;
  final bool creando;
  final String? errorMessage;
  final List<CotizacionEntity> cotizacionesCreadas;

  const CotizacionWizardState({
    this.superficies = const [],
    this.reglas = const {},
    this.seleccionSimple = const {},
    this.seleccionKit = const {},
    this.recomendacionIds = const {},
    this.manoObraSimple,
    this.manoObraKit,
    this.loading = false,
    this.creando = false,
    this.errorMessage,
    this.cotizacionesCreadas = const [],
  });

  /// Regla de la superficie en el índice [i] (asume "simple" si no se
  /// encontró la categoría en `GET /cotizaciones/materiales`).
  MaterialReglaEntity reglaDe(int i) {
    final cat = superficies[i].categoria.toLowerCase().trim();
    return reglas[cat] ??
        MaterialReglaEntity(categoria: cat, metodoCalculo: 'rendimiento', requiereKit: false);
  }

  bool superficieCompleta(int i) {
    final regla = reglaDe(i);
    if (!regla.requiereKit) return seleccionSimple.containsKey(i);
    final kit = seleccionKit[i];
    if (kit == null || kit.principal == null) return false;
    for (final comp in regla.complementos) {
      switch (comp) {
        case 'pegazulejo':
        case 'adhesivo':
          if (kit.adhesivo == null) return false;
        case 'cruceta':
          if (kit.cruceta == null) return false;
        case 'emboquillado':
          if (kit.boquilla == null) return false;
      }
    }
    return true;
  }

  bool get todasCompletas =>
      superficies.isNotEmpty &&
      List.generate(superficies.length, (i) => i).every(superficieCompleta);

  int get completadas =>
      List.generate(superficies.length, (i) => i).where(superficieCompleta).length;

  CotizacionWizardState copyWith({
    List<SuperficieEntity>? superficies,
    Map<String, MaterialReglaEntity>? reglas,
    Map<int, ProductoEntity>? seleccionSimple,
    Map<int, KitSeleccion>? seleccionKit,
    Map<int, int>? recomendacionIds,
    Object? manoObraSimple = _keep,
    Object? manoObraKit = _keep,
    bool? loading,
    bool? creando,
    String? errorMessage,
    bool clearError = false,
    List<CotizacionEntity>? cotizacionesCreadas,
  }) =>
      CotizacionWizardState(
        superficies: superficies ?? this.superficies,
        reglas: reglas ?? this.reglas,
        seleccionSimple: seleccionSimple ?? this.seleccionSimple,
        seleccionKit: seleccionKit ?? this.seleccionKit,
        recomendacionIds: recomendacionIds ?? this.recomendacionIds,
        manoObraSimple: manoObraSimple == _keep
            ? this.manoObraSimple
            : manoObraSimple as double?,
        manoObraKit:
            manoObraKit == _keep ? this.manoObraKit : manoObraKit as double?,
        loading: loading ?? this.loading,
        creando: creando ?? this.creando,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        cotizacionesCreadas: cotizacionesCreadas ?? this.cotizacionesCreadas,
      );

  static const Object _keep = Object();
}
