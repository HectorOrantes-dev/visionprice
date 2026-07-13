// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscriptions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// AsyncNotifier de la lista de suscripciones. `build()` carga la lista y
/// Riverpod la expone como `AsyncValue<List<SubscriptionEntity>>`
/// (loading / data / error) — la UI la consume con `.when()`.

@ProviderFor(Subscriptions)
final subscriptionsProvider = SubscriptionsProvider._();

/// AsyncNotifier de la lista de suscripciones. `build()` carga la lista y
/// Riverpod la expone como `AsyncValue<List<SubscriptionEntity>>`
/// (loading / data / error) — la UI la consume con `.when()`.
final class SubscriptionsProvider
    extends $AsyncNotifierProvider<Subscriptions, List<SubscriptionEntity>> {
  /// AsyncNotifier de la lista de suscripciones. `build()` carga la lista y
  /// Riverpod la expone como `AsyncValue<List<SubscriptionEntity>>`
  /// (loading / data / error) — la UI la consume con `.when()`.
  SubscriptionsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'subscriptionsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$subscriptionsHash();

  @$internal
  @override
  Subscriptions create() => Subscriptions();
}

String _$subscriptionsHash() => r'37884101515ac6864cdf815752556fe41f365f72';

/// AsyncNotifier de la lista de suscripciones. `build()` carga la lista y
/// Riverpod la expone como `AsyncValue<List<SubscriptionEntity>>`
/// (loading / data / error) — la UI la consume con `.when()`.

abstract class _$Subscriptions
    extends $AsyncNotifier<List<SubscriptionEntity>> {
  FutureOr<List<SubscriptionEntity>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<List<SubscriptionEntity>>, List<SubscriptionEntity>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<SubscriptionEntity>>,
            List<SubscriptionEntity>>,
        AsyncValue<List<SubscriptionEntity>>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
