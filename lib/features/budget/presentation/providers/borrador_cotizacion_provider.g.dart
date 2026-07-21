// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrador_cotizacion_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BorradorCotizacion)
final borradorCotizacionProvider = BorradorCotizacionFamily._();

final class BorradorCotizacionProvider extends $AsyncNotifierProvider<
    BorradorCotizacion, BorradorCotizacionEntity> {
  BorradorCotizacionProvider._(
      {required BorradorCotizacionFamily super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'borradorCotizacionProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$borradorCotizacionHash();

  @override
  String toString() {
    return r'borradorCotizacionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BorradorCotizacion create() => BorradorCotizacion();

  @override
  bool operator ==(Object other) {
    return other is BorradorCotizacionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$borradorCotizacionHash() =>
    r'8275a15ddcd19bc1a17737a31b334c111db1b78a';

final class BorradorCotizacionFamily extends $Family
    with
        $ClassFamilyOverride<
            BorradorCotizacion,
            AsyncValue<BorradorCotizacionEntity>,
            BorradorCotizacionEntity,
            FutureOr<BorradorCotizacionEntity>,
            int> {
  BorradorCotizacionFamily._()
      : super(
          retry: null,
          name: r'borradorCotizacionProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  BorradorCotizacionProvider call(
    int grabacionId,
  ) =>
      BorradorCotizacionProvider._(argument: grabacionId, from: this);

  @override
  String toString() => r'borradorCotizacionProvider';
}

abstract class _$BorradorCotizacion
    extends $AsyncNotifier<BorradorCotizacionEntity> {
  late final _$args = ref.$arg as int;
  int get grabacionId => _$args;

  FutureOr<BorradorCotizacionEntity> build(
    int grabacionId,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<BorradorCotizacionEntity>, BorradorCotizacionEntity>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<BorradorCotizacionEntity>,
            BorradorCotizacionEntity>,
        AsyncValue<BorradorCotizacionEntity>,
        Object?,
        Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
