
import '../../domain/entities/paypal_subscription_intento_entity.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_remote_datasource.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource _remote;
  AccountRepositoryImpl(this._remote);

  @override
  Future<List<SubscriptionEntity>> subscriptions() => _remote.subscriptions();

  @override
  Future<void> crearSuscripcionConekta({
    required String planKey,
    required String cardToken,
  }) =>
      _remote.crearSuscripcionConekta(planKey: planKey, cardToken: cardToken);

  @override
  Future<void> cancelarSuscripcionConekta() =>
      _remote.cancelarSuscripcionConekta();

  @override
  Future<void> eliminarMetodoPagoConekta() =>
      _remote.eliminarMetodoPagoConekta();

  @override
  Future<PaypalSubscriptionIntentoEntity> crearSuscripcionPaypal({
    required String planKey,
  }) =>
      _remote.crearSuscripcionPaypal(planKey: planKey);

  @override
  Future<void> cancelarSuscripcionPaypal({required String subscriptionId}) =>
      _remote.cancelarSuscripcionPaypal(subscriptionId: subscriptionId);
}
