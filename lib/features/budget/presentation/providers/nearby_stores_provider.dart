import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/services/location_service.dart';
import '../../domain/entities/cotizacion_entity.dart';
import '../../domain/entities/item_cotizacion.dart';
import '../../domain/entities/producto_entity.dart';
import '../../domain/usecases/cotizacion_usecases.dart';
import '../../../recording/domain/entities/superficie_entity.dart';

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
  List<SuperficieEntity>? _superficies;

  LatLng? _lastFetchPosition;
  StreamSubscription<LatLng>? _locationSub;
  bool _showUpdatePrompt = false;

  /// Legacy: producto_id (string) → 'piso' | 'paredes'
  final Map<String, String> _seleccionLegacy = {};

  /// Nuevo: SuperficieEntity → producto_id (string)
  final Map<SuperficieEntity, String> _seleccionNueva = {};

  bool get loading => _loading;
  bool get creating => _creating;
  bool get usandoUbicacionAprox => _usandoUbicacionAprox;
  String? get errorMessage => _errorMessage;
  List<ProductoEntity> get productos => _productos;
  List<SuperficieEntity>? get superficies => _superficies;
  bool get showUpdatePrompt => _showUpdatePrompt;
  
  int get seleccionados => _superficies != null && _superficies!.isNotEmpty 
      ? _seleccionNueva.length 
      : _seleccionLegacy.length;

  bool isLegacySelected(String productoId, String aplicarA) => _seleccionLegacy[productoId] == aplicarA;
  bool isNuevaSelected(String productoId, SuperficieEntity sup) => _seleccionNueva[sup] == productoId;

  @override
  void dispose() {
    _locationSub?.cancel();
    super.dispose();
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
    _superficies = superficies;
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final ubic = await _location.current();
      _lastFetchPosition = ubic;
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
      _listenLocation();
    }
  }

  void _listenLocation() {
    _locationSub?.cancel();
    final stream = _location.getPositionStream();
    if (stream == null) return;
    _locationSub = stream.listen((newPos) {
      if (_lastFetchPosition != null) {
        final dist = _location.distanceBetween(_lastFetchPosition!, newPos);
        if (dist > 500 && !_showUpdatePrompt) {
          _showUpdatePrompt = true;
          notifyListeners();
        }
      }
    });
  }

  Future<void> refetchLocation() async {
    _showUpdatePrompt = false;
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final ubic = await _location.current();
      _lastFetchPosition = ubic;
      _usandoUbicacionAprox = ubic == null;
      final pos = ubic ?? LocationService.fallback;
      _productos = await _obtenerProductos(lat: pos.lat, lng: pos.lng);
    } catch (e) {
      _errorMessage = e is ApiException
          ? e.message
          : 'No se pudo actualizar la ubicación.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void toggleLegacy(String productoId, String aplicarA) {
    if (_seleccionLegacy[productoId] == aplicarA) {
      _seleccionLegacy.remove(productoId);
    } else {
      _seleccionLegacy[productoId] = aplicarA;
    }
    notifyListeners();
  }

  void toggleNueva(String productoId, SuperficieEntity sup) {
    if (_seleccionNueva[sup] == productoId) {
      _seleccionNueva.remove(sup);
    } else {
      _seleccionNueva[sup] = productoId;
    }
    notifyListeners();
  }

  Future<void> generar({
    required void Function(CotizacionEntity) onCreated,
  }) async {
    List<ItemCotizacion> items;
    final usaNuevo = _superficies != null && _superficies!.isNotEmpty;

    if (usaNuevo) {
      if (_seleccionNueva.isEmpty) {
        _errorMessage = 'Selecciona al menos un producto para una superficie.';
        notifyListeners();
        return;
      }
      items = _seleccionNueva.entries
          .map((e) => ItemCotizacion(
                productoId: e.value, // ya es String
                areaM2: e.key.areaM2,
                descripcion: e.key.descripcion,
              ))
          .toList();
    } else {
      if (_seleccionLegacy.isEmpty) {
        _errorMessage = 'Selecciona al menos un producto (piso o paredes).';
        notifyListeners();
        return;
      }
      items = _seleccionLegacy.entries
          .map((e) => ItemCotizacion(productoId: e.key, aplicarA: e.value))
          .toList();
    }

    _creating = true;
    _errorMessage = null;
    notifyListeners();
    try {
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
