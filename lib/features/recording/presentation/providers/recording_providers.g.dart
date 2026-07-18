// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recording_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Cadena de dependencias de grabaciones como providers de Riverpod
/// (composición declarativa). Reemplaza el registro get_it de esta feature.

@ProviderFor(grabacionRemoteDataSource)
final grabacionRemoteDataSourceProvider = GrabacionRemoteDataSourceProvider._();

/// Cadena de dependencias de grabaciones como providers de Riverpod
/// (composición declarativa). Reemplaza el registro get_it de esta feature.

final class GrabacionRemoteDataSourceProvider extends $FunctionalProvider<
    GrabacionRemoteDataSource,
    GrabacionRemoteDataSource,
    GrabacionRemoteDataSource> with $Provider<GrabacionRemoteDataSource> {
  /// Cadena de dependencias de grabaciones como providers de Riverpod
  /// (composición declarativa). Reemplaza el registro get_it de esta feature.
  GrabacionRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'grabacionRemoteDataSourceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$grabacionRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<GrabacionRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GrabacionRemoteDataSource create(Ref ref) {
    return grabacionRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GrabacionRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GrabacionRemoteDataSource>(value),
    );
  }
}

String _$grabacionRemoteDataSourceHash() =>
    r'85a21b58120b574df5ad12489cb18b627419b438';

@ProviderFor(grabacionRepository)
final grabacionRepositoryProvider = GrabacionRepositoryProvider._();

final class GrabacionRepositoryProvider extends $FunctionalProvider<
    GrabacionRepository,
    GrabacionRepository,
    GrabacionRepository> with $Provider<GrabacionRepository> {
  GrabacionRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'grabacionRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$grabacionRepositoryHash();

  @$internal
  @override
  $ProviderElement<GrabacionRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GrabacionRepository create(Ref ref) {
    return grabacionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GrabacionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GrabacionRepository>(value),
    );
  }
}

String _$grabacionRepositoryHash() =>
    r'4c8850c4b1cccf9ae0f2d37307492e539eb0d0bc';

@ProviderFor(obtenerGrabacionUseCase)
final obtenerGrabacionUseCaseProvider = ObtenerGrabacionUseCaseProvider._();

final class ObtenerGrabacionUseCaseProvider extends $FunctionalProvider<
    ObtenerGrabacionUseCase,
    ObtenerGrabacionUseCase,
    ObtenerGrabacionUseCase> with $Provider<ObtenerGrabacionUseCase> {
  ObtenerGrabacionUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'obtenerGrabacionUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$obtenerGrabacionUseCaseHash();

  @$internal
  @override
  $ProviderElement<ObtenerGrabacionUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ObtenerGrabacionUseCase create(Ref ref) {
    return obtenerGrabacionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ObtenerGrabacionUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ObtenerGrabacionUseCase>(value),
    );
  }
}

String _$obtenerGrabacionUseCaseHash() =>
    r'01fb2309e3caa70e208504d539504e8723d3adf1';

@ProviderFor(calcularMetrosUseCase)
final calcularMetrosUseCaseProvider = CalcularMetrosUseCaseProvider._();

final class CalcularMetrosUseCaseProvider extends $FunctionalProvider<
    CalcularMetrosUseCase,
    CalcularMetrosUseCase,
    CalcularMetrosUseCase> with $Provider<CalcularMetrosUseCase> {
  CalcularMetrosUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'calcularMetrosUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$calcularMetrosUseCaseHash();

  @$internal
  @override
  $ProviderElement<CalcularMetrosUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CalcularMetrosUseCase create(Ref ref) {
    return calcularMetrosUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CalcularMetrosUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CalcularMetrosUseCase>(value),
    );
  }
}

String _$calcularMetrosUseCaseHash() =>
    r'54c8c21f7c2c91a8f31c8b3e90b43f1f0a4ed2a8';

@ProviderFor(actualizarTranscripcionUseCase)
final actualizarTranscripcionUseCaseProvider =
    ActualizarTranscripcionUseCaseProvider._();

final class ActualizarTranscripcionUseCaseProvider extends $FunctionalProvider<
        ActualizarTranscripcionUseCase,
        ActualizarTranscripcionUseCase,
        ActualizarTranscripcionUseCase>
    with $Provider<ActualizarTranscripcionUseCase> {
  ActualizarTranscripcionUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'actualizarTranscripcionUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$actualizarTranscripcionUseCaseHash();

  @$internal
  @override
  $ProviderElement<ActualizarTranscripcionUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ActualizarTranscripcionUseCase create(Ref ref) {
    return actualizarTranscripcionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActualizarTranscripcionUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<ActualizarTranscripcionUseCase>(value),
    );
  }
}

String _$actualizarTranscripcionUseCaseHash() =>
    r'bb899d88eccd0ecbf34e86e75a6c56ba586209f6';

@ProviderFor(subirGrabacionUseCase)
final subirGrabacionUseCaseProvider = SubirGrabacionUseCaseProvider._();

final class SubirGrabacionUseCaseProvider extends $FunctionalProvider<
    SubirGrabacionUseCase,
    SubirGrabacionUseCase,
    SubirGrabacionUseCase> with $Provider<SubirGrabacionUseCase> {
  SubirGrabacionUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'subirGrabacionUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$subirGrabacionUseCaseHash();

  @$internal
  @override
  $ProviderElement<SubirGrabacionUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SubirGrabacionUseCase create(Ref ref) {
    return subirGrabacionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubirGrabacionUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubirGrabacionUseCase>(value),
    );
  }
}

String _$subirGrabacionUseCaseHash() =>
    r'6a0aac53a3f77273e078803753b18b42f44e9dbb';

@ProviderFor(audioRecorderService)
final audioRecorderServiceProvider = AudioRecorderServiceProvider._();

final class AudioRecorderServiceProvider extends $FunctionalProvider<
    AudioRecorderService,
    AudioRecorderService,
    AudioRecorderService> with $Provider<AudioRecorderService> {
  AudioRecorderServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'audioRecorderServiceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$audioRecorderServiceHash();

  @$internal
  @override
  $ProviderElement<AudioRecorderService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AudioRecorderService create(Ref ref) {
    return audioRecorderService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AudioRecorderService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AudioRecorderService>(value),
    );
  }
}

String _$audioRecorderServiceHash() =>
    r'08e7b66d8f78c8040e58b3f57f491e96b86f0bbe';

@ProviderFor(syncLocalDataSource)
final syncLocalDataSourceProvider = SyncLocalDataSourceProvider._();

final class SyncLocalDataSourceProvider extends $FunctionalProvider<
    SyncLocalDataSource,
    SyncLocalDataSource,
    SyncLocalDataSource> with $Provider<SyncLocalDataSource> {
  SyncLocalDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'syncLocalDataSourceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$syncLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<SyncLocalDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncLocalDataSource create(Ref ref) {
    return syncLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncLocalDataSource>(value),
    );
  }
}

String _$syncLocalDataSourceHash() =>
    r'35e3b50352ca791056a6f39d853922c6a26e2387';

@ProviderFor(syncService)
final syncServiceProvider = SyncServiceProvider._();

final class SyncServiceProvider
    extends $FunctionalProvider<SyncService, SyncService, SyncService>
    with $Provider<SyncService> {
  SyncServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'syncServiceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$syncServiceHash();

  @$internal
  @override
  $ProviderElement<SyncService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncService create(Ref ref) {
    return syncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncService>(value),
    );
  }
}

String _$syncServiceHash() => r'43fde735a87eee44abcbab47451eeb834409c602';
