// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recomendacion_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Cadena de dependencias de recomendaciones como providers de Riverpod.

@ProviderFor(recomendacionRemoteDataSource)
final recomendacionRemoteDataSourceProvider =
    RecomendacionRemoteDataSourceProvider._();

/// Cadena de dependencias de recomendaciones como providers de Riverpod.

final class RecomendacionRemoteDataSourceProvider extends $FunctionalProvider<
        RecomendacionRemoteDataSource,
        RecomendacionRemoteDataSource,
        RecomendacionRemoteDataSource>
    with $Provider<RecomendacionRemoteDataSource> {
  /// Cadena de dependencias de recomendaciones como providers de Riverpod.
  RecomendacionRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'recomendacionRemoteDataSourceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$recomendacionRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<RecomendacionRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RecomendacionRemoteDataSource create(Ref ref) {
    return recomendacionRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecomendacionRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<RecomendacionRemoteDataSource>(value),
    );
  }
}

String _$recomendacionRemoteDataSourceHash() =>
    r'ac3ecbd6cc0b55b55b637e551f2f9025aeacfd05';

@ProviderFor(recomendacionRepository)
final recomendacionRepositoryProvider = RecomendacionRepositoryProvider._();

final class RecomendacionRepositoryProvider extends $FunctionalProvider<
    RecomendacionRepository,
    RecomendacionRepository,
    RecomendacionRepository> with $Provider<RecomendacionRepository> {
  RecomendacionRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'recomendacionRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$recomendacionRepositoryHash();

  @$internal
  @override
  $ProviderElement<RecomendacionRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RecomendacionRepository create(Ref ref) {
    return recomendacionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecomendacionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecomendacionRepository>(value),
    );
  }
}

String _$recomendacionRepositoryHash() =>
    r'a1612481bf311fad4b5e5dead175ff72c3ab1ffa';

@ProviderFor(entrenarModelosUseCase)
final entrenarModelosUseCaseProvider = EntrenarModelosUseCaseProvider._();

final class EntrenarModelosUseCaseProvider extends $FunctionalProvider<
    EntrenarModelosUseCase,
    EntrenarModelosUseCase,
    EntrenarModelosUseCase> with $Provider<EntrenarModelosUseCase> {
  EntrenarModelosUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'entrenarModelosUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$entrenarModelosUseCaseHash();

  @$internal
  @override
  $ProviderElement<EntrenarModelosUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EntrenarModelosUseCase create(Ref ref) {
    return entrenarModelosUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EntrenarModelosUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EntrenarModelosUseCase>(value),
    );
  }
}

String _$entrenarModelosUseCaseHash() =>
    r'a4e3fc3d1bf996bc70a370c3394792cb2b9f804c';

@ProviderFor(obtenerRecomendacionKitUseCase)
final obtenerRecomendacionKitUseCaseProvider =
    ObtenerRecomendacionKitUseCaseProvider._();

final class ObtenerRecomendacionKitUseCaseProvider extends $FunctionalProvider<
        ObtenerRecomendacionKitUseCase,
        ObtenerRecomendacionKitUseCase,
        ObtenerRecomendacionKitUseCase>
    with $Provider<ObtenerRecomendacionKitUseCase> {
  ObtenerRecomendacionKitUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'obtenerRecomendacionKitUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$obtenerRecomendacionKitUseCaseHash();

  @$internal
  @override
  $ProviderElement<ObtenerRecomendacionKitUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ObtenerRecomendacionKitUseCase create(Ref ref) {
    return obtenerRecomendacionKitUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ObtenerRecomendacionKitUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<ObtenerRecomendacionKitUseCase>(value),
    );
  }
}

String _$obtenerRecomendacionKitUseCaseHash() =>
    r'2a203e740f81e1afd592a25629fb6939eefbd687';
