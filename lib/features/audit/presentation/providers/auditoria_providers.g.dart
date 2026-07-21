// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auditoria_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(auditoriaRemoteDataSource)
final auditoriaRemoteDataSourceProvider = AuditoriaRemoteDataSourceProvider._();

final class AuditoriaRemoteDataSourceProvider extends $FunctionalProvider<
    AuditoriaRemoteDataSource,
    AuditoriaRemoteDataSource,
    AuditoriaRemoteDataSource> with $Provider<AuditoriaRemoteDataSource> {
  AuditoriaRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'auditoriaRemoteDataSourceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$auditoriaRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AuditoriaRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuditoriaRemoteDataSource create(Ref ref) {
    return auditoriaRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuditoriaRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuditoriaRemoteDataSource>(value),
    );
  }
}

String _$auditoriaRemoteDataSourceHash() =>
    r'ce479b3346b71e460b063ddf9ee4665b2fc1c40f';

@ProviderFor(auditoriaRepository)
final auditoriaRepositoryProvider = AuditoriaRepositoryProvider._();

final class AuditoriaRepositoryProvider extends $FunctionalProvider<
    AuditoriaRepository,
    AuditoriaRepository,
    AuditoriaRepository> with $Provider<AuditoriaRepository> {
  AuditoriaRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'auditoriaRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$auditoriaRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuditoriaRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuditoriaRepository create(Ref ref) {
    return auditoriaRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuditoriaRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuditoriaRepository>(value),
    );
  }
}

String _$auditoriaRepositoryHash() =>
    r'07d933067f0f865ab37c8bde8c2b73f556fa8a64';

@ProviderFor(auditarPresupuestoUseCase)
final auditarPresupuestoUseCaseProvider = AuditarPresupuestoUseCaseProvider._();

final class AuditarPresupuestoUseCaseProvider extends $FunctionalProvider<
    AuditarPresupuestoUseCase,
    AuditarPresupuestoUseCase,
    AuditarPresupuestoUseCase> with $Provider<AuditarPresupuestoUseCase> {
  AuditarPresupuestoUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'auditarPresupuestoUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$auditarPresupuestoUseCaseHash();

  @$internal
  @override
  $ProviderElement<AuditarPresupuestoUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuditarPresupuestoUseCase create(Ref ref) {
    return auditarPresupuestoUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuditarPresupuestoUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuditarPresupuestoUseCase>(value),
    );
  }
}

String _$auditarPresupuestoUseCaseHash() =>
    r'7e94a4300be6b785b841b693a7cb7506044183b5';

@ProviderFor(obtenerAnomaliasZonaUseCase)
final obtenerAnomaliasZonaUseCaseProvider =
    ObtenerAnomaliasZonaUseCaseProvider._();

final class ObtenerAnomaliasZonaUseCaseProvider extends $FunctionalProvider<
    ObtenerAnomaliasZonaUseCase,
    ObtenerAnomaliasZonaUseCase,
    ObtenerAnomaliasZonaUseCase> with $Provider<ObtenerAnomaliasZonaUseCase> {
  ObtenerAnomaliasZonaUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'obtenerAnomaliasZonaUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$obtenerAnomaliasZonaUseCaseHash();

  @$internal
  @override
  $ProviderElement<ObtenerAnomaliasZonaUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ObtenerAnomaliasZonaUseCase create(Ref ref) {
    return obtenerAnomaliasZonaUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ObtenerAnomaliasZonaUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ObtenerAnomaliasZonaUseCase>(value),
    );
  }
}

String _$obtenerAnomaliasZonaUseCaseHash() =>
    r'36a937933f4d7d0f8809526cc7188d37b6547423';
