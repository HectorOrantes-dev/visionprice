import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/subscription_entity.dart';
import 'account_providers.dart';

part 'subscriptions_provider.g.dart';

/// Estado inmutable de la lista de suscripciones.
class SubscriptionsState {
  final bool loading;
  final String? errorMessage;
  final List<SubscriptionEntity> items;

  const SubscriptionsState({
    this.loading = true,
    this.errorMessage,
    this.items = const [],
  });

  static const _keep = Object();

  SubscriptionsState copyWith({
    bool? loading,
    Object? errorMessage = _keep,
    List<SubscriptionEntity>? items,
  }) {
    return SubscriptionsState(
      loading: loading ?? this.loading,
      errorMessage:
          errorMessage == _keep ? this.errorMessage : errorMessage as String?,
      items: items ?? this.items,
    );
  }
}

/// Notifier de suscripciones. Reemplaza al `SubscriptionsViewModel`.
@riverpod
class Subscriptions extends _$Subscriptions {
  @override
  SubscriptionsState build() {
    // `load` muta `state` en su primera línea síncrona → se difiere para no
    // mutar el estado mientras el propio build() se construye.
    Future.microtask(load);
    return const SubscriptionsState();
  }

  Future<void> load() async {
    state = state.copyWith(loading: true, errorMessage: null);
    try {
      final items = await ref.read(obtenerSuscripcionesUseCaseProvider)();
      state = state.copyWith(items: items, loading: false);
    } catch (e) {
      state = state.copyWith(
        loading: false,
        errorMessage: e is ApiException
            ? e.message
            : 'No se pudieron cargar las suscripciones.',
      );
    }
  }
}
