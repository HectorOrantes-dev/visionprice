import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import 'lat_lng.dart';

// El value object LatLng vive en su propio archivo (SRP); se re-exporta para
// no romper los imports existentes.
export 'lat_lng.dart';

/// Obtiene la ubicación actual del dispositivo (para buscar ferreterías
/// cercanas). `@lazySingleton` reutilizable.
@lazySingleton
class LocationService {
  /// Centro de CDMX como respaldo si no hay permiso/ubicación disponible.
  static const LatLng fallback = LatLng(19.4326, -99.1332);

  /// Devuelve la ubicación actual, o `null` si no se pudo obtener (sin permiso,
  /// servicio apagado o error). El llamador decide usar [fallback].
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
}
