// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Cadena de dependencias de cotizaciones como providers de Riverpod.

@ProviderFor(cotizacionRemoteDataSource)
final cotizacionRemoteDataSourceProvider =
    CotizacionRemoteDataSourceProvider._();

/// Cadena de dependencias de cotizaciones como providers de Riverpod.

final class CotizacionRemoteDataSourceProvider extends $FunctionalProvider<
    CotizacionRemoteDataSource,
    CotizacionRemoteDataSource,
    CotizacionRemoteDataSource> with $Provider<CotizacionRemoteDataSource> {
  /// Cadena de dependencias de cotizaciones como providers de Riverpod.
  CotizacionRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'cotizacionRemoteDataSourceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$cotizacionRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<CotizacionRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CotizacionRemoteDataSource create(Ref ref) {
    return cotizacionRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CotizacionRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CotizacionRemoteDataSource>(value),
    );
  }
}

String _$cotizacionRemoteDataSourceHash() =>
    r'9a8f3d8082763ab8560c14704f29a6467e12de20';

@ProviderFor(cotizacionRepository)
final cotizacionRepositoryProvider = CotizacionRepositoryProvider._();

final class CotizacionRepositoryProvider extends $FunctionalProvider<
    CotizacionRepository,
    CotizacionRepository,
    CotizacionRepository> with $Provider<CotizacionRepository> {
  CotizacionRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'cotizacionRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$cotizacionRepositoryHash();

  @$internal
  @override
  $ProviderElement<CotizacionRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CotizacionRepository create(Ref ref) {
    return cotizacionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CotizacionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CotizacionRepository>(value),
    );
  }
}

String _$cotizacionRepositoryHash() =>
    r'f2794969767c60888eaaa2b092336aff50bea70a';

@ProviderFor(obtenerProductosUseCase)
final obtenerProductosUseCaseProvider = ObtenerProductosUseCaseProvider._();

final class ObtenerProductosUseCaseProvider extends $FunctionalProvider<
    ObtenerProductosUseCase,
    ObtenerProductosUseCase,
    ObtenerProductosUseCase> with $Provider<ObtenerProductosUseCase> {
  ObtenerProductosUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'obtenerProductosUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$obtenerProductosUseCaseHash();

  @$internal
  @override
  $ProviderElement<ObtenerProductosUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ObtenerProductosUseCase create(Ref ref) {
    return obtenerProductosUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ObtenerProductosUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ObtenerProductosUseCase>(value),
    );
  }
}

String _$obtenerProductosUseCaseHash() =>
    r'56fbdbfef80ff8a963966e31f718f747df59213b';

@ProviderFor(crearCotizacionUseCase)
final crearCotizacionUseCaseProvider = CrearCotizacionUseCaseProvider._();

final class CrearCotizacionUseCaseProvider extends $FunctionalProvider<
    CrearCotizacionUseCase,
    CrearCotizacionUseCase,
    CrearCotizacionUseCase> with $Provider<CrearCotizacionUseCase> {
  CrearCotizacionUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'crearCotizacionUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$crearCotizacionUseCaseHash();

  @$internal
  @override
  $ProviderElement<CrearCotizacionUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CrearCotizacionUseCase create(Ref ref) {
    return crearCotizacionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CrearCotizacionUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CrearCotizacionUseCase>(value),
    );
  }
}

String _$crearCotizacionUseCaseHash() =>
    r'abd4a7dcb76b6a1798cf5007625b699db37c5282';

@ProviderFor(obtenerPdfUseCase)
final obtenerPdfUseCaseProvider = ObtenerPdfUseCaseProvider._();

final class ObtenerPdfUseCaseProvider extends $FunctionalProvider<
    ObtenerPdfUseCase,
    ObtenerPdfUseCase,
    ObtenerPdfUseCase> with $Provider<ObtenerPdfUseCase> {
  ObtenerPdfUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'obtenerPdfUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$obtenerPdfUseCaseHash();

  @$internal
  @override
  $ProviderElement<ObtenerPdfUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ObtenerPdfUseCase create(Ref ref) {
    return obtenerPdfUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ObtenerPdfUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ObtenerPdfUseCase>(value),
    );
  }
}

String _$obtenerPdfUseCaseHash() => r'f8bee39021bf1606358b538f8373b5ee2414dcba';

@ProviderFor(obtenerMaterialesUseCase)
final obtenerMaterialesUseCaseProvider = ObtenerMaterialesUseCaseProvider._();

final class ObtenerMaterialesUseCaseProvider extends $FunctionalProvider<
    ObtenerMaterialesUseCase,
    ObtenerMaterialesUseCase,
    ObtenerMaterialesUseCase> with $Provider<ObtenerMaterialesUseCase> {
  ObtenerMaterialesUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'obtenerMaterialesUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$obtenerMaterialesUseCaseHash();

  @$internal
  @override
  $ProviderElement<ObtenerMaterialesUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ObtenerMaterialesUseCase create(Ref ref) {
    return obtenerMaterialesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ObtenerMaterialesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ObtenerMaterialesUseCase>(value),
    );
  }
}

String _$obtenerMaterialesUseCaseHash() =>
    r'e0ca896e6887dbf1faf6436840ef570059b6859c';

@ProviderFor(crearCotizacionKitUseCase)
final crearCotizacionKitUseCaseProvider = CrearCotizacionKitUseCaseProvider._();

final class CrearCotizacionKitUseCaseProvider extends $FunctionalProvider<
    CrearCotizacionKitUseCase,
    CrearCotizacionKitUseCase,
    CrearCotizacionKitUseCase> with $Provider<CrearCotizacionKitUseCase> {
  CrearCotizacionKitUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'crearCotizacionKitUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$crearCotizacionKitUseCaseHash();

  @$internal
  @override
  $ProviderElement<CrearCotizacionKitUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CrearCotizacionKitUseCase create(Ref ref) {
    return crearCotizacionKitUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CrearCotizacionKitUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CrearCotizacionKitUseCase>(value),
    );
  }
}

String _$crearCotizacionKitUseCaseHash() =>
    r'f644d46a51a4e97dd0361f55aba8f395d7572933';
