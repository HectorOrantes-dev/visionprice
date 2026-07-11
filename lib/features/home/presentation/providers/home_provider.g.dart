// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeHash() => r'0e4da95134f652c62daa571b76aba1be69f0f208';

/// Notifier de la pantalla de inicio (Riverpod moderno). Reúne proyectos,
/// conectividad real (ping) y creación de proyectos. Reemplaza al
/// `HomeViewModel` (ChangeNotifier).
///
/// Copied from [Home].
@ProviderFor(Home)
final homeProvider = AutoDisposeNotifierProvider<Home, HomeState>.internal(
  Home.new,
  name: r'homeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$homeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Home = AutoDisposeNotifier<HomeState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
