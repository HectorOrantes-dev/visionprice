// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier de la pantalla de inicio (Riverpod moderno). Reúne proyectos,
/// conectividad real (ping) y creación de proyectos. Reemplaza al
/// `HomeViewModel` (ChangeNotifier).

@ProviderFor(Home)
final homeProvider = HomeProvider._();

/// Notifier de la pantalla de inicio (Riverpod moderno). Reúne proyectos,
/// conectividad real (ping) y creación de proyectos. Reemplaza al
/// `HomeViewModel` (ChangeNotifier).
final class HomeProvider extends $NotifierProvider<Home, HomeState> {
  /// Notifier de la pantalla de inicio (Riverpod moderno). Reúne proyectos,
  /// conectividad real (ping) y creación de proyectos. Reemplaza al
  /// `HomeViewModel` (ChangeNotifier).
  HomeProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'homeProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$homeHash();

  @$internal
  @override
  Home create() => Home();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeState>(value),
    );
  }
}

String _$homeHash() => r'34a2913f9f7117fd9d9086b28c370b233f68798c';

/// Notifier de la pantalla de inicio (Riverpod moderno). Reúne proyectos,
/// conectividad real (ping) y creación de proyectos. Reemplaza al
/// `HomeViewModel` (ChangeNotifier).

abstract class _$Home extends $Notifier<HomeState> {
  HomeState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<HomeState, HomeState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<HomeState, HomeState>, HomeState, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
