import 'package:geolocator/geolocator.dart';

/// Coordenada simple.
class LatLng {
  final double lat;
  final double lng;
  const LatLng(this.lat, this.lng);
}

/// Obtiene la ubicación actual del dispositivo (para buscar ferreterías
/// cercanas). `@lazySingleton` reutilizable.
class LocationService {
  /// Centro de CDMX como respaldo si no hay permiso/ubicación disponible.
  static const LatLng fallback = LatLng(19.4326, -99.1332);

  Future<LatLng?> current() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return null;
      }
      final pos = await Geolocator.getCurrentPosition();
      return LatLng(pos.latitude, pos.longitude);
    } catch (_) {
      return null;
    }
  }

  /// Devuelve un stream de la ubicación, filtrando actualizaciones menores a
  /// `distanceFilterMeters`.
  Stream<LatLng>? getPositionStream({int distanceFilterMeters = 50}) {
    try {
      return Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: distanceFilterMeters,
        ),
      ).map((pos) => LatLng(pos.latitude, pos.longitude));
    } catch (_) {
      return null;
    }
  }

  /// Calcula la distancia en metros entre dos coordenadas.
  double distanceBetween(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
      start.lat, start.lng,
      end.lat, end.lng,
    );
  }
}
