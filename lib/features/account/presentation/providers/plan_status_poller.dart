import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/perfil_provider.dart';
import '../../../budget/presentation/providers/budget_providers.dart';
import 'subscriptions_provider.dart';

part 'plan_status_poller.g.dart';

const _intervaloPoll = Duration(seconds: 20);

/// Mientras alguna pantalla lo observe (Perfil, Mis suscripciones, Método de
/// pago), refresca periódicamente el estado real del plan.
///
/// La activación (webhook de Conekta/PayPal tras pagar) o la confirmación de
/// un pago OXXO/SPEI pueden llegar segundos o minutos después de que el
/// usuario ya está mirando la pantalla, sin que él dispare ninguna acción —
/// sin este sondeo, tendría que cerrar y reabrir la app (o hacer
/// pull-to-refresh) para enterarse. Es `autoDispose`: en cuanto ninguna
/// pantalla lo observa, el temporizador se cancela solo.
@riverpod
class PlanStatusPoller extends _$PlanStatusPoller {
  Timer? _timer;

  @override
  void build() {
    _timer = Timer.periodic(_intervaloPoll, (_) => _tick());
    ref.onDispose(() => _timer?.cancel());
  }

  void _tick() {
    ref.read(perfilProvider.notifier).refresh();
    ref.invalidate(subscriptionsProvider);
    ref.invalidate(usoCotizacionesProvider);
  }
}
