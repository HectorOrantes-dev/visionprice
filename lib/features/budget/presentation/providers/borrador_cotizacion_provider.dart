import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/borrador_cotizacion_entity.dart';
import '../../domain/entities/cotizacion_entity.dart';
import '../../domain/entities/item_cotizacion.dart';
import '../../domain/entities/producto_entity.dart';
import '../../domain/entities/superficie_borrador_entity.dart';
import '../../domain/entities/superficie_kit_item.dart';
import 'budget_providers.dart';

part 'borrador_cotizacion_provider.g.dart';

/// Índice de una línea dentro del borrador: qué superficie y qué rol
/// (`principal/adhesivo/cruceta/boquilla/material`), para poder editarla sin
/// ambigüedad.
class LineaRef {
  final int superficieIndex;
  final String rol;
  const LineaRef(this.superficieIndex, this.rol);
}

@riverpod
class BorradorCotizacion extends _$BorradorCotizacion {
  @override
  Future<BorradorCotizacionEntity> build(int grabacionId) {
    return ref.read(obtenerBorradorCotizacionUseCaseProvider)(grabacionId);
  }

  /// El usuario cambió el producto de una línea (ej. tocó "principal" de la
  /// superficie 0 y eligió otro producto en el picker). Actualiza tanto la
  /// línea que se muestra como el `cuerpo_confirmacion` que se va a mandar.
  void editarLinea(LineaRef ref_, ProductoEntity nuevo) {
    final actual = state.value;
    if (actual == null) return;

    final superficies = [...actual.superficies];
    final sup = superficies[ref_.superficieIndex];
    final lineas = [
      for (final l in sup.lineas)
        if (l.rol == ref_.rol)
          l.copyWithProducto(
            productoId: nuevo.productoId,
            nombre: nuevo.nombre,
            proveedorNombre: nuevo.proveedorNombre,
            distanciaKm: nuevo.distanciaKm,
            precioUnitario: nuevo.precioUnitario,
          )
        else
          l,
    ];
    superficies[ref_.superficieIndex] = sup.copyWithLineas(lineas);

    final cuerpo = actual.cuerpoConfirmacion;
    final nuevoCuerpo = sup.esKit
        ? cuerpo.copyWith(kit: _actualizarKit(cuerpo.kit, sup, ref_.rol, nuevo))
        : cuerpo.copyWith(
            simple: _actualizarSimple(cuerpo.simple, sup, nuevo));

    state = AsyncData(BorradorCotizacionEntity(
      proyectoId: actual.proyectoId,
      grabacionId: actual.grabacionId,
      totalEstimado: actual.totalEstimado,
      advertencias: actual.advertencias,
      superficies: superficies,
      cuerpoConfirmacion: nuevoCuerpo,
    ));
  }

  /// Empareja la superficie KIT editada con su entrada correspondiente en
  /// `cuerpo_confirmacion.kit` por posición (mismo orden en que el back-end
  /// las mandó): cuenta cuántas superficies KIT hay antes de [sup] en la
  /// lista completa para hallar su índice dentro de la lista, más chica,
  /// de solo-kits.
  List<SuperficieKitItem> _actualizarKit(
    List<SuperficieKitItem> kit,
    SuperficieBorradorEntity sup,
    String rol,
    ProductoEntity nuevo,
  ) {
    final actual = state.value!;
    final kitIndex = actual.superficies
        .where((s) => s.esKit)
        .toList()
        .indexOf(sup);
    if (kitIndex < 0 || kitIndex >= kit.length) return kit;
    return [
      for (var i = 0; i < kit.length; i++)
        if (i == kitIndex)
          switch (rol) {
            'principal' => kit[i].copyWith(principalProductoId: nuevo.productoId),
            'adhesivo' => kit[i].copyWith(adhesivoProductoId: nuevo.productoId),
            'cruceta' => kit[i].copyWith(cruecetaProductoId: nuevo.productoId),
            'boquilla' => kit[i].copyWith(boquillaProductoId: nuevo.productoId),
            _ => kit[i],
          }
        else
          kit[i],
    ];
  }

  List<ItemCotizacion> _actualizarSimple(
    List<ItemCotizacion> simple,
    SuperficieBorradorEntity sup,
    ProductoEntity nuevo,
  ) {
    final actual = state.value!;
    final simpleIndex = actual.superficies
        .where((s) => !s.esKit)
        .toList()
        .indexOf(sup);
    if (simpleIndex < 0 || simpleIndex >= simple.length) return simple;
    return [
      for (var i = 0; i < simple.length; i++)
        if (i == simpleIndex)
          simple[i].copyWithProducto(nuevo.productoId)
        else
          simple[i],
    ];
  }

  /// Manda `cuerpo_confirmacion.kit` a `POST /cotizaciones/kit` y
  /// `cuerpo_confirmacion.simple` a `POST /cotizaciones` (los que existan),
  /// reutilizando los mismos usecases ya probados del wizard manual.
  Future<List<CotizacionEntity>> confirmar() async {
    final actual = state.value;
    if (actual == null) throw StateError('Borrador no cargado.');
    final cuerpo = actual.cuerpoConfirmacion;
    final creadas = <CotizacionEntity>[];

    if (cuerpo.kit.isNotEmpty) {
      final cot = await ref.read(crearCotizacionKitUseCaseProvider)(
        proyectoId: actual.proyectoId,
        superficies: cuerpo.kit,
      );
      creadas.add(cot);
    }
    if (cuerpo.simple.isNotEmpty) {
      final cot = await ref.read(crearCotizacionUseCaseProvider)(
        proyectoId: actual.proyectoId,
        items: cuerpo.simple,
      );
      creadas.add(cot);
    }
    return creadas;
  }
}

/// Traduce el `rol` de una línea al `categoria` con el que se consulta
/// `GET /cotizaciones/productos?categoria=` al elegir otro producto — igual
/// mapeo que ya usa `KitBody` para los complementos del wizard manual.
String categoriaParaRol(String rol, String categoriaSuperficie) => switch (rol) {
      'adhesivo' => 'pegazulejo',
      'cruceta' => 'cruceta',
      'boquilla' => 'emboquillado',
      _ => categoriaSuperficie, // 'principal' o 'material'
    };
