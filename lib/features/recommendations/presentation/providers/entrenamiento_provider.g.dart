// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entrenamiento_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Estado de `POST /api/v1/recomendaciones/entrenar`.
///
/// El `build()` arranca en `null` (aún no se ha entrenado en esta sesión); el
/// entrenamiento lo dispara el usuario con [entrenar]. `AsyncValue.guard`
/// traduce el resultado o el error (p. ej. 403 si el rol no es
/// `ingeniero_civil`) al subtipo correcto, sin try/catch manual.

@ProviderFor(Entrenamiento)
final entrenamientoProvider = EntrenamientoProvider._();

/// Estado de `POST /api/v1/recomendaciones/entrenar`.
///
/// El `build()` arranca en `null` (aún no se ha entrenado en esta sesión); el
/// entrenamiento lo dispara el usuario con [entrenar]. `AsyncValue.guard`
/// traduce el resultado o el error (p. ej. 403 si el rol no es
/// `ingeniero_civil`) al subtipo correcto, sin try/catch manual.
final class EntrenamientoProvider
    extends $AsyncNotifierProvider<Entrenamiento, EntrenamientoEntity?> {
  /// Estado de `POST /api/v1/recomendaciones/entrenar`.
  ///
  /// El `build()` arranca en `null` (aún no se ha entrenado en esta sesión); el
  /// entrenamiento lo dispara el usuario con [entrenar]. `AsyncValue.guard`
  /// traduce el resultado o el error (p. ej. 403 si el rol no es
  /// `ingeniero_civil`) al subtipo correcto, sin try/catch manual.
  EntrenamientoProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'entrenamientoProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$entrenamientoHash();

  @$internal
  @override
  Entrenamiento create() => Entrenamiento();
}

String _$entrenamientoHash() => r'35f990f6969cb9f2d9de76447522660b006d27cc';

/// Estado de `POST /api/v1/recomendaciones/entrenar`.
///
/// El `build()` arranca en `null` (aún no se ha entrenado en esta sesión); el
/// entrenamiento lo dispara el usuario con [entrenar]. `AsyncValue.guard`
/// traduce el resultado o el error (p. ej. 403 si el rol no es
/// `ingeniero_civil`) al subtipo correcto, sin try/catch manual.

abstract class _$Entrenamiento extends $AsyncNotifier<EntrenamientoEntity?> {
  FutureOr<EntrenamientoEntity?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<EntrenamientoEntity?>, EntrenamientoEntity?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<EntrenamientoEntity?>, EntrenamientoEntity?>,
        AsyncValue<EntrenamientoEntity?>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
