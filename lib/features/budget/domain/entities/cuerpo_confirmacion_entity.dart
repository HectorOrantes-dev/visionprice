import 'item_cotizacion.dart';
import 'superficie_kit_item.dart';

/// `cuerpo_confirmacion` del borrador: ya viene en el shape exacto que
/// esperan `POST /cotizaciones/kit` y `POST /cotizaciones` — el botón
/// "Confirmar" solo tiene que mandarlos tal cual (o editados, si el usuario
/// cambió algún producto).
class CuerpoConfirmacionEntity {
  final List<SuperficieKitItem> kit;
  final List<ItemCotizacion> simple;

  const CuerpoConfirmacionEntity({required this.kit, required this.simple});

  factory CuerpoConfirmacionEntity.fromJson(Map<String, dynamic> json) {
    final kitJson = json['kit'];
    final simpleJson = json['simple'];
    final kitSuperficies = kitJson is Map ? kitJson['superficies'] : null;
    final simpleItems = simpleJson is Map ? simpleJson['items'] : null;
    return CuerpoConfirmacionEntity(
      kit: kitSuperficies is List
          ? kitSuperficies
              .whereType<Map<String, dynamic>>()
              .map(SuperficieKitItem.fromJson)
              .toList()
          : const [],
      simple: simpleItems is List
          ? simpleItems
              .whereType<Map<String, dynamic>>()
              .map(ItemCotizacion.fromJson)
              .toList()
          : const [],
    );
  }

  CuerpoConfirmacionEntity copyWith({
    List<SuperficieKitItem>? kit,
    List<ItemCotizacion>? simple,
  }) {
    return CuerpoConfirmacionEntity(
      kit: kit ?? this.kit,
      simple: simple ?? this.simple,
    );
  }
}
