import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/location_service_provider.dart';
import '../../../../core/services/location_service.dart';
import '../../domain/entities/auditoria_resultado_entity.dart';
import 'auditoria_providers.dart';

part 'anomalias_zona_provider.g.dart';

/// Escaneo de zona: solo las líneas anómalas cerca de la ubicación actual
/// (si no hay permiso/GPS, usa el mismo fallback que el resto de la app).
@riverpod
Future<AuditoriaResultadoEntity> anomaliasZona(Ref ref) async {
  final location = ref.read(locationServiceProvider);
  final ubic = await location.current() ?? LocationService.fallback;
  return ref.read(obtenerAnomaliasZonaUseCaseProvider)(
    lat: ubic.lat,
    lng: ubic.lng,
  );
}
