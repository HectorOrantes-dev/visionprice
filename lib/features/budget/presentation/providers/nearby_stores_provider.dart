import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/services/location_service.dart';
import '../../domain/entities/cotizacion_entity.dart';
import '../../domain/entities/producto_entity.dart';
import '../../domain/usecases/cotizacion_usecases.dart';

/// ViewModel de "Ferreterías cercanas": obtiene la ubicación, lista los
/// productos cercanos y permite elegir a qué superficie (piso/paredes) se
/// aplica cada uno para luego crear la cotización.
@injectable
class NearbyStoresViewModel extends ChangeNotifier {
  final ObtenerProductosUseCase _obtenerProductos;
  final CrearCotizacionUseCase _crearCotizacion;
  final LocationService _location;

  NearbyStoresViewModel(
    this._obtenerProductos,
    this._crearCotizacion,
    this._location,
  );

  int _proyectoId = 0;
  double? _pisoM2;
  double? _paredesM2;

  bool _loading = true;
  bool _creating = false;
  bool _usandoUbicacionAprox = false;
  String? _errorMessage;
  List<ProductoEntity> _productos = const [];

  /// producto_id → 'piso' | 'paredes'
  final Map<int, String> _seleccion = {};

  bool get loading => _loading;
  bool get creating => _creating;
  bool get usandoUbicacionAprox => _usandoUbicacionAprox;
  String? get errorMessage => _errorMessage;
  List<ProductoEntity> get productos => _productos;
  int get seleccionados => _seleccion.length;

  String? aplicarDe(int productoId) => _seleccion[productoId];

  Future<void> load({
    required int proyectoId,
    double? pisoM2,
    double? paredesM2,
  }) async {
    _proyectoId = proyectoId;
    _pisoM2 = pisoM2;
    _paredesM2 = paredesM2;
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final ubic = await _location.current();
      _usandoUbicacionAprox = ubic == null;
      final pos = ubic ?? LocationService.fallback;
      _productos = await _obtenerProductos(lat: pos.lat, lng: pos.lng);
    } catch (e) {
      _errorMessage = e is ApiException
          ? e.message
          : 'No se pudieron cargar las ferreterías.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Alterna la superficie de un producto. Pasar `null` lo quita de la
  /// selección; 'piso' o 'paredes' lo incluye con esa superficie.
  void setAplicar(int productoId, String? aplicarA) {
    if (aplicarA == null) {
      _seleccion.remove(productoId);
    } else {
      _seleccion[productoId] = aplicarA;
    }
    notifyListeners();
  }

  /// Crea la cotización con la selección actual.
  Future<void> generar({
    required void Function(CotizacionEntity) onCreated,
  }) async {
    if (_seleccion.isEmpty) {
      _errorMessage = 'Selecciona al menos un producto (piso o paredes).';
      notifyListeners();
      return;
    }
    _creating = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final items = _seleccion.entries
          .map((e) => ItemCotizacion(productoId: e.key, aplicarA: e.value))
          .toList();
      final cotizacion = await _crearCotizacion(
        proyectoId: _proyectoId,
        pisoM2: _pisoM2,
        paredesM2: _paredesM2,
        items: items,
      );
      onCreated(cotizacion);
    } catch (e) {
      _errorMessage =
          e is ApiException ? e.message : 'No se pudo crear la cotización.';
    } finally {
      _creating = false;
      notifyListeners();
    }
  }
}
