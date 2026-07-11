// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recording_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recordingHash() => r'b9553a4a0dc3ed8a5cf71439b40a88e5bfc8ef25';

/// Notifier de la grabación (Riverpod moderno). Reemplaza al `RecordingViewModel`
/// (ChangeNotifier): captura audio real y lo sube como multipart, o lo encola
/// offline vía [syncServiceProvider].
///
/// Copied from [Recording].
@ProviderFor(Recording)
final recordingProvider =
    AutoDisposeNotifierProvider<Recording, RecordingState>.internal(
  Recording.new,
  name: r'recordingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$recordingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Recording = AutoDisposeNotifier<RecordingState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
