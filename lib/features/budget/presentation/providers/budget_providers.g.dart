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

@ProviderFor(cotizacionPdfLocalDataSource)
final cotizacionPdfLocalDataSourceProvider =
    CotizacionPdfLocalDataSourceProvider._();

final class CotizacionPdfLocalDataSourceProvider extends $FunctionalProvider<
    CotizacionPdfLocalDataSource,
    CotizacionPdfLocalDataSource,
    CotizacionPdfLocalDataSource> with $Provider<CotizacionPdfLocalDataSource> {
  CotizacionPdfLocalDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'cotizacionPdfLocalDataSourceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$cotizacionPdfLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<CotizacionPdfLocalDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CotizacionPdfLocalDataSource create(Ref ref) {
    return cotizacionPdfLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CotizacionPdfLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CotizacionPdfLocalDataSource>(value),
    );
  }
}

String _$cotizacionPdfLocalDataSourceHash() =>
    r'5687b5085dd07696ac809e407debfc2baef45724';

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
    r'9b71a6785d7c975cdc2b1d5dc626a410066df2f7';

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

@ProviderFor(listarCotizacionesPdfUseCase)
final listarCotizacionesPdfUseCaseProvider =
    ListarCotizacionesPdfUseCaseProvider._();

final class ListarCotizacionesPdfUseCaseProvider extends $FunctionalProvider<
    ListarCotizacionesPdfUseCase,
    ListarCotizacionesPdfUseCase,
    ListarCotizacionesPdfUseCase> with $Provider<ListarCotizacionesPdfUseCase> {
  ListarCotizacionesPdfUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'listarCotizacionesPdfUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$listarCotizacionesPdfUseCaseHash();

  @$internal
  @override
  $ProviderElement<ListarCotizacionesPdfUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ListarCotizacionesPdfUseCase create(Ref ref) {
    return listarCotizacionesPdfUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ListarCotizacionesPdfUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ListarCotizacionesPdfUseCase>(value),
    );
  }
}

String _$listarCotizacionesPdfUseCaseHash() =>
    r'fb454d41ab4ea69de6780014e8add195fa6392aa';

@ProviderFor(listarCotizacionesPdfLocalesUseCase)
final listarCotizacionesPdfLocalesUseCaseProvider =
    ListarCotizacionesPdfLocalesUseCaseProvider._();

final class ListarCotizacionesPdfLocalesUseCaseProvider
    extends $FunctionalProvider<
        ListarCotizacionesPdfLocalesUseCase,
        ListarCotizacionesPdfLocalesUseCase,
        ListarCotizacionesPdfLocalesUseCase>
    with $Provider<ListarCotizacionesPdfLocalesUseCase> {
  ListarCotizacionesPdfLocalesUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'listarCotizacionesPdfLocalesUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() =>
      _$listarCotizacionesPdfLocalesUseCaseHash();

  @$internal
  @override
  $ProviderElement<ListarCotizacionesPdfLocalesUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ListarCotizacionesPdfLocalesUseCase create(Ref ref) {
    return listarCotizacionesPdfLocalesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ListarCotizacionesPdfLocalesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<ListarCotizacionesPdfLocalesUseCase>(value),
    );
  }
}

String _$listarCotizacionesPdfLocalesUseCaseHash() =>
    r'905101e3da188e7d39ca34fba07501af023e49ee';

@ProviderFor(descargarPdfBytesUseCase)
final descargarPdfBytesUseCaseProvider = DescargarPdfBytesUseCaseProvider._();

final class DescargarPdfBytesUseCaseProvider extends $FunctionalProvider<
    DescargarPdfBytesUseCase,
    DescargarPdfBytesUseCase,
    DescargarPdfBytesUseCase> with $Provider<DescargarPdfBytesUseCase> {
  DescargarPdfBytesUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'descargarPdfBytesUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$descargarPdfBytesUseCaseHash();

  @$internal
  @override
  $ProviderElement<DescargarPdfBytesUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DescargarPdfBytesUseCase create(Ref ref) {
    return descargarPdfBytesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DescargarPdfBytesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DescargarPdfBytesUseCase>(value),
    );
  }
}

String _$descargarPdfBytesUseCaseHash() =>
    r'8591c179ec41e2b290175c7786c417ed583fa28a';

@ProviderFor(obtenerBorradorCotizacionUseCase)
final obtenerBorradorCotizacionUseCaseProvider =
    ObtenerBorradorCotizacionUseCaseProvider._();

final class ObtenerBorradorCotizacionUseCaseProvider
    extends $FunctionalProvider<ObtenerBorradorCotizacionUseCase,
        ObtenerBorradorCotizacionUseCase, ObtenerBorradorCotizacionUseCase>
    with $Provider<ObtenerBorradorCotizacionUseCase> {
  ObtenerBorradorCotizacionUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'obtenerBorradorCotizacionUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$obtenerBorradorCotizacionUseCaseHash();

  @$internal
  @override
  $ProviderElement<ObtenerBorradorCotizacionUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ObtenerBorradorCotizacionUseCase create(Ref ref) {
    return obtenerBorradorCotizacionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ObtenerBorradorCotizacionUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<ObtenerBorradorCotizacionUseCase>(value),
    );
  }
}

String _$obtenerBorradorCotizacionUseCaseHash() =>
    r'7e3fb6575cd6725d4f3158864f7eb57876b9d3ee';
