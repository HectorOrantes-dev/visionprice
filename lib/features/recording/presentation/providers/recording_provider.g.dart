// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recording_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier de la grabación (Riverpod moderno). Reemplaza al `RecordingViewModel`
/// (ChangeNotifier): captura audio real y lo sube como multipart, o lo encola
/// offline vía [syncServiceProvider].

@ProviderFor(Recording)
final recordingProvider = RecordingProvider._();

/// Notifier de la grabación (Riverpod moderno). Reemplaza al `RecordingViewModel`
/// (ChangeNotifier): captura audio real y lo sube como multipart, o lo encola
/// offline vía [syncServiceProvider].
final class RecordingProvider
    extends $NotifierProvider<Recording, RecordingState> {
  /// Notifier de la grabación (Riverpod moderno). Reemplaza al `RecordingViewModel`
  /// (ChangeNotifier): captura audio real y lo sube como multipart, o lo encola
  /// offline vía [syncServiceProvider].
  RecordingProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'recordingProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$recordingHash();

  @$internal
  @override
  Recording create() => Recording();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordingState>(value),
    );
  }
}

String _$recordingHash() => r'9b4b25a9ca815c95ba2c83d4ee53acb50a2c39b8';

/// Notifier de la grabación (Riverpod moderno). Reemplaza al `RecordingViewModel`
/// (ChangeNotifier): captura audio real y lo sube como multipart, o lo encola
/// offline vía [syncServiceProvider].

abstract class _$Recording extends $Notifier<RecordingState> {
  RecordingState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RecordingState, RecordingState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<RecordingState, RecordingState>,
        RecordingState,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
