// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensitive_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// AsyncNotifier de los datos sensibles guardados en local (SharedPreferences).
/// `build()` los lee y Riverpod los expone como `AsyncValue<Map<label,valor>>`.
/// La señal remota WIPE_DATA se refleja invalidando este provider (la pantalla
/// lo hace en su callback `onWipe`).

@ProviderFor(SensitiveData)
final sensitiveDataProvider = SensitiveDataProvider._();

/// AsyncNotifier de los datos sensibles guardados en local (SharedPreferences).
/// `build()` los lee y Riverpod los expone como `AsyncValue<Map<label,valor>>`.
/// La señal remota WIPE_DATA se refleja invalidando este provider (la pantalla
/// lo hace en su callback `onWipe`).
final class SensitiveDataProvider
    extends $AsyncNotifierProvider<SensitiveData, Map<String, String>> {
  /// AsyncNotifier de los datos sensibles guardados en local (SharedPreferences).
  /// `build()` los lee y Riverpod los expone como `AsyncValue<Map<label,valor>>`.
  /// La señal remota WIPE_DATA se refleja invalidando este provider (la pantalla
  /// lo hace en su callback `onWipe`).
  SensitiveDataProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'sensitiveDataProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$sensitiveDataHash();

  @$internal
  @override
  SensitiveData create() => SensitiveData();
}

String _$sensitiveDataHash() => r'5e5200bdf1add245d6c71a05ecc90f93aaca2648';

/// AsyncNotifier de los datos sensibles guardados en local (SharedPreferences).
/// `build()` los lee y Riverpod los expone como `AsyncValue<Map<label,valor>>`.
/// La señal remota WIPE_DATA se refleja invalidando este provider (la pantalla
/// lo hace en su callback `onWipe`).

abstract class _$SensitiveData extends $AsyncNotifier<Map<String, String>> {
  FutureOr<Map<String, String>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<Map<String, String>>, Map<String, String>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Map<String, String>>, Map<String, String>>,
        AsyncValue<Map<String, String>>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
