// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'perfil_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$perfilHash() => r'ad9f92bff1858016407ae85174cbee07a998e8b3';

/// Notifier de la pantalla "Perfil" (Riverpod moderno). Carga el perfil
/// (`GET /api/v1/me/perfil`) al observarse. Reemplaza al `PerfilViewModel`.
///
/// Copied from [Perfil].
@ProviderFor(Perfil)
final perfilProvider =
    AutoDisposeNotifierProvider<Perfil, PerfilState>.internal(
  Perfil.new,
  name: r'perfilProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$perfilHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Perfil = AutoDisposeNotifier<PerfilState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
