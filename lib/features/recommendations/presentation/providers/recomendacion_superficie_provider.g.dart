// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recomendacion_superficie_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Recomendación de kit **por superficie** (family: proyectoId + índice).
///
/// No se pide sola: arranca en `null` y solo consulta cuando el usuario pulsa
/// "Usar recomendados" ([pedir]). Al llegar la respuesta **autollena** los
/// widgets del kit de esa superficie con los productos más cercanos que sugiere
/// el modelo (principal + pegazulejo + cruceta + emboquillado), aplica el método
/// de crucetas y guarda el `recomendacion_id` (se devuelve en
/// `POST /cotizaciones/kit` para cerrar el loop). El usuario puede cambiar
/// cualquiera después: es autocompletado, no una imposición.

@ProviderFor(RecomendacionSuperficie)
final recomendacionSuperficieProvider = RecomendacionSuperficieFamily._();

/// Recomendación de kit **por superficie** (family: proyectoId + índice).
///
/// No se pide sola: arranca en `null` y solo consulta cuando el usuario pulsa
/// "Usar recomendados" ([pedir]). Al llegar la respuesta **autollena** los
/// widgets del kit de esa superficie con los productos más cercanos que sugiere
/// el modelo (principal + pegazulejo + cruceta + emboquillado), aplica el método
/// de crucetas y guarda el `recomendacion_id` (se devuelve en
/// `POST /cotizaciones/kit` para cerrar el loop). El usuario puede cambiar
/// cualquiera después: es autocompletado, no una imposición.
final class RecomendacionSuperficieProvider extends $AsyncNotifierProvider<
    RecomendacionSuperficie, RecomendacionKitEntity?> {
  /// Recomendación de kit **por superficie** (family: proyectoId + índice).
  ///
  /// No se pide sola: arranca en `null` y solo consulta cuando el usuario pulsa
  /// "Usar recomendados" ([pedir]). Al llegar la respuesta **autollena** los
  /// widgets del kit de esa superficie con los productos más cercanos que sugiere
  /// el modelo (principal + pegazulejo + cruceta + emboquillado), aplica el método
  /// de crucetas y guarda el `recomendacion_id` (se devuelve en
  /// `POST /cotizaciones/kit` para cerrar el loop). El usuario puede cambiar
  /// cualquiera después: es autocompletado, no una imposición.
  RecomendacionSuperficieProvider._(
      {required RecomendacionSuperficieFamily super.from,
      required (
        int,
        int,
      )
          super.argument})
      : super(
          retry: null,
          name: r'recomendacionSuperficieProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$recomendacionSuperficieHash();

  @override
  String toString() {
    return r'recomendacionSuperficieProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  RecomendacionSuperficie create() => RecomendacionSuperficie();

  @override
  bool operator ==(Object other) {
    return other is RecomendacionSuperficieProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recomendacionSuperficieHash() =>
    r'a618f749fb53fdd47fe1c621bf7390de8a9cd760';

/// Recomendación de kit **por superficie** (family: proyectoId + índice).
///
/// No se pide sola: arranca en `null` y solo consulta cuando el usuario pulsa
/// "Usar recomendados" ([pedir]). Al llegar la respuesta **autollena** los
/// widgets del kit de esa superficie con los productos más cercanos que sugiere
/// el modelo (principal + pegazulejo + cruceta + emboquillado), aplica el método
/// de crucetas y guarda el `recomendacion_id` (se devuelve en
/// `POST /cotizaciones/kit` para cerrar el loop). El usuario puede cambiar
/// cualquiera después: es autocompletado, no una imposición.

final class RecomendacionSuperficieFamily extends $Family
    with
        $ClassFamilyOverride<
            RecomendacionSuperficie,
            AsyncValue<RecomendacionKitEntity?>,
            RecomendacionKitEntity?,
            FutureOr<RecomendacionKitEntity?>,
            (
              int,
              int,
            )> {
  RecomendacionSuperficieFamily._()
      : super(
          retry: null,
          name: r'recomendacionSuperficieProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Recomendación de kit **por superficie** (family: proyectoId + índice).
  ///
  /// No se pide sola: arranca en `null` y solo consulta cuando el usuario pulsa
  /// "Usar recomendados" ([pedir]). Al llegar la respuesta **autollena** los
  /// widgets del kit de esa superficie con los productos más cercanos que sugiere
  /// el modelo (principal + pegazulejo + cruceta + emboquillado), aplica el método
  /// de crucetas y guarda el `recomendacion_id` (se devuelve en
  /// `POST /cotizaciones/kit` para cerrar el loop). El usuario puede cambiar
  /// cualquiera después: es autocompletado, no una imposición.

  RecomendacionSuperficieProvider call(
    int proyectoId,
    int index,
  ) =>
      RecomendacionSuperficieProvider._(argument: (
        proyectoId,
        index,
      ), from: this);

  @override
  String toString() => r'recomendacionSuperficieProvider';
}

/// Recomendación de kit **por superficie** (family: proyectoId + índice).
///
/// No se pide sola: arranca en `null` y solo consulta cuando el usuario pulsa
/// "Usar recomendados" ([pedir]). Al llegar la respuesta **autollena** los
/// widgets del kit de esa superficie con los productos más cercanos que sugiere
/// el modelo (principal + pegazulejo + cruceta + emboquillado), aplica el método
/// de crucetas y guarda el `recomendacion_id` (se devuelve en
/// `POST /cotizaciones/kit` para cerrar el loop). El usuario puede cambiar
/// cualquiera después: es autocompletado, no una imposición.

abstract class _$RecomendacionSuperficie
    extends $AsyncNotifier<RecomendacionKitEntity?> {
  late final _$args = ref.$arg as (
    int,
    int,
  );
  int get proyectoId => _$args.$1;
  int get index => _$args.$2;

  FutureOr<RecomendacionKitEntity?> build(
    int proyectoId,
    int index,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<RecomendacionKitEntity?>, RecomendacionKitEntity?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<RecomendacionKitEntity?>,
            RecomendacionKitEntity?>,
        AsyncValue<RecomendacionKitEntity?>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args.$1,
              _$args.$2,
            ));
  }
}
