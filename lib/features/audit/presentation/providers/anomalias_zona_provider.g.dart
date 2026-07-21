// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anomalias_zona_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Escaneo de zona: solo las líneas anómalas cerca de la ubicación actual
/// (si no hay permiso/GPS, usa el mismo fallback que el resto de la app).

@ProviderFor(anomaliasZona)
final anomaliasZonaProvider = AnomaliasZonaProvider._();

/// Escaneo de zona: solo las líneas anómalas cerca de la ubicación actual
/// (si no hay permiso/GPS, usa el mismo fallback que el resto de la app).

final class AnomaliasZonaProvider extends $FunctionalProvider<
        AsyncValue<AuditoriaResultadoEntity>,
        AuditoriaResultadoEntity,
        FutureOr<AuditoriaResultadoEntity>>
    with
        $FutureModifier<AuditoriaResultadoEntity>,
        $FutureProvider<AuditoriaResultadoEntity> {
  /// Escaneo de zona: solo las líneas anómalas cerca de la ubicación actual
  /// (si no hay permiso/GPS, usa el mismo fallback que el resto de la app).
  AnomaliasZonaProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'anomaliasZonaProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$anomaliasZonaHash();

  @$internal
  @override
  $FutureProviderElement<AuditoriaResultadoEntity> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AuditoriaResultadoEntity> create(Ref ref) {
    return anomaliasZona(ref);
  }
}

String _$anomaliasZonaHash() => r'954dc07d1d2f270475095b63007bca51223fa671';
