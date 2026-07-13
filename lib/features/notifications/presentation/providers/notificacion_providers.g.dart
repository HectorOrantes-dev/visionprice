// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificacion_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Cadena de dependencias de notificaciones como providers de Riverpod.

@ProviderFor(notificacionRemoteDataSource)
final notificacionRemoteDataSourceProvider =
    NotificacionRemoteDataSourceProvider._();

/// Cadena de dependencias de notificaciones como providers de Riverpod.

final class NotificacionRemoteDataSourceProvider extends $FunctionalProvider<
    NotificacionRemoteDataSource,
    NotificacionRemoteDataSource,
    NotificacionRemoteDataSource> with $Provider<NotificacionRemoteDataSource> {
  /// Cadena de dependencias de notificaciones como providers de Riverpod.
  NotificacionRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'notificacionRemoteDataSourceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notificacionRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<NotificacionRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NotificacionRemoteDataSource create(Ref ref) {
    return notificacionRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificacionRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificacionRemoteDataSource>(value),
    );
  }
}

String _$notificacionRemoteDataSourceHash() =>
    r'79233dd75c9e2feaca76e6553bb668cba8c6a001';

@ProviderFor(notificacionRepository)
final notificacionRepositoryProvider = NotificacionRepositoryProvider._();

final class NotificacionRepositoryProvider extends $FunctionalProvider<
    NotificacionRepository,
    NotificacionRepository,
    NotificacionRepository> with $Provider<NotificacionRepository> {
  NotificacionRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'notificacionRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notificacionRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotificacionRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NotificacionRepository create(Ref ref) {
    return notificacionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificacionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificacionRepository>(value),
    );
  }
}

String _$notificacionRepositoryHash() =>
    r'980e025992e8e921deb1af86e66ddcf75eb6dd17';

@ProviderFor(obtenerNotificacionesUseCase)
final obtenerNotificacionesUseCaseProvider =
    ObtenerNotificacionesUseCaseProvider._();

final class ObtenerNotificacionesUseCaseProvider extends $FunctionalProvider<
    ObtenerNotificacionesUseCase,
    ObtenerNotificacionesUseCase,
    ObtenerNotificacionesUseCase> with $Provider<ObtenerNotificacionesUseCase> {
  ObtenerNotificacionesUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'obtenerNotificacionesUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$obtenerNotificacionesUseCaseHash();

  @$internal
  @override
  $ProviderElement<ObtenerNotificacionesUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ObtenerNotificacionesUseCase create(Ref ref) {
    return obtenerNotificacionesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ObtenerNotificacionesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ObtenerNotificacionesUseCase>(value),
    );
  }
}

String _$obtenerNotificacionesUseCaseHash() =>
    r'874e3b3562380cfbbe8b0ea2e31c6aaed69d19c4';

@ProviderFor(marcarNotificacionLeidaUseCase)
final marcarNotificacionLeidaUseCaseProvider =
    MarcarNotificacionLeidaUseCaseProvider._();

final class MarcarNotificacionLeidaUseCaseProvider extends $FunctionalProvider<
        MarcarNotificacionLeidaUseCase,
        MarcarNotificacionLeidaUseCase,
        MarcarNotificacionLeidaUseCase>
    with $Provider<MarcarNotificacionLeidaUseCase> {
  MarcarNotificacionLeidaUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'marcarNotificacionLeidaUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$marcarNotificacionLeidaUseCaseHash();

  @$internal
  @override
  $ProviderElement<MarcarNotificacionLeidaUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MarcarNotificacionLeidaUseCase create(Ref ref) {
    return marcarNotificacionLeidaUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarcarNotificacionLeidaUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<MarcarNotificacionLeidaUseCase>(value),
    );
  }
}

String _$marcarNotificacionLeidaUseCaseHash() =>
    r'820bc6a22ab2403bb11d502de5912462a1bf5136';
