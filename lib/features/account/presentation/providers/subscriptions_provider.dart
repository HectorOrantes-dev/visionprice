import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/subscription_entity.dart';
import 'account_providers.dart';

part 'subscriptions_provider.g.dart';

/// AsyncNotifier de la lista de suscripciones. `build()` carga la lista y
/// Riverpod la expone como `AsyncValue<List<SubscriptionEntity>>`
/// (loading / data / error) — la UI la consume con `.when()`.
@riverpod
class Subscriptions extends _$Subscriptions {
  @override
  Future<List<SubscriptionEntity>> build() =>
      ref.read(obtenerSuscripcionesUseCaseProvider)();
}
