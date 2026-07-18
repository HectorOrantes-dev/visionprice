// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'perfil_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// AsyncNotifier de la pantalla "Perfil". `build()` carga el perfil
/// (`GET /api/v1/me/perfil`) y Riverpod expone el resultado como
/// `AsyncValue<PerfilEntity>` (loading / data / error) automáticamente.
/// Tras la primera vez el perfil viene de la caché del repositorio.

@ProviderFor(Perfil)
final perfilProvider = PerfilProvider._();

/// AsyncNotifier de la pantalla "Perfil". `build()` carga el perfil
/// (`GET /api/v1/me/perfil`) y Riverpod expone el resultado como
/// `AsyncValue<PerfilEntity>` (loading / data / error) automáticamente.
/// Tras la primera vez el perfil viene de la caché del repositorio.
final class PerfilProvider
    extends $AsyncNotifierProvider<Perfil, PerfilEntity> {
  /// AsyncNotifier de la pantalla "Perfil". `build()` carga el perfil
  /// (`GET /api/v1/me/perfil`) y Riverpod expone el resultado como
  /// `AsyncValue<PerfilEntity>` (loading / data / error) automáticamente.
  /// Tras la primera vez el perfil viene de la caché del repositorio.
  PerfilProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'perfilProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$perfilHash();

  @$internal
  @override
  Perfil create() => Perfil();
}

String _$perfilHash() => r'20b82f6a31ba4b7fd994357c33265b74a276c553';

/// AsyncNotifier de la pantalla "Perfil". `build()` carga el perfil
/// (`GET /api/v1/me/perfil`) y Riverpod expone el resultado como
/// `AsyncValue<PerfilEntity>` (loading / data / error) automáticamente.
/// Tras la primera vez el perfil viene de la caché del repositorio.

abstract class _$Perfil extends $AsyncNotifier<PerfilEntity> {
  FutureOr<PerfilEntity> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PerfilEntity>, PerfilEntity>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<PerfilEntity>, PerfilEntity>,
        AsyncValue<PerfilEntity>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
