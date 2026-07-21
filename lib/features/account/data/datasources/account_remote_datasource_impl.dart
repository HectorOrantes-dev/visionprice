
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../domain/entities/paypal_subscription_intento_entity.dart';
import '../../domain/entities/subscription_entity.dart';
import 'account_remote_datasource.dart';

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final ApiClient _client;
  AccountRemoteDataSourceImpl(this._client);

  @override
  Future<List<SubscriptionEntity>> subscriptions() async {
    // La respuesta puede ser una lista o un objeto (anyOf en el OpenAPI).
    final data = await _client.getRaw(ApiConfig.meSubscriptions);
    final List raw;
    if (data is List) {
      raw = data;
    } else if (data is Map) {
      final inner = data['subscriptions'] ??
          data['suscripciones'] ??
          data['items'] ??
          data['data'];
      if (inner is List) {
        raw = inner;
      } else {
        // Objeto que representa una sola suscripción.
        raw = data.isEmpty ? const [] : [data];
      }
    } else {
      raw = const [];
    }
    return raw
        .whereType<Map<String, dynamic>>()
        .map(SubscriptionEntity.fromJson)
        .toList();
  }

  @override
  Future<void> crearSuscripcionConekta({
    required String planKey,
    required String cardToken,
  }) {
    return _client.postJson(
      ApiConfig.conektaSubscriptions,
      {'plan_key': planKey, 'card_token': cardToken},
      auth: true,
    );
  }

  @override
  Future<void> cancelarSuscripcionConekta() {
    return _client.postJson(
      ApiConfig.conektaSubscriptionsCancel,
      const {},
      auth: true,
    );
  }

  @override
  Future<void> eliminarMetodoPagoConekta() {
    return _client.deleteJson(ApiConfig.conektaPaymentMethod, auth: true);
  }

  @override
  Future<PaypalSubscriptionIntentoEntity> crearSuscripcionPaypal({
    required String planKey,
  }) async {
    final data = await _client.postJson(
      ApiConfig.paypalSubscriptions,
      {'plan_key': planKey},
      auth: true,
    );
    return PaypalSubscriptionIntentoEntity.fromJson(data);
  }

  @override
  Future<void> cancelarSuscripcionPaypal({required String subscriptionId}) {
    return _client.postJson(
      ApiConfig.paypalSubscriptionCancel(subscriptionId),
      const {},
      auth: true,
    );
  }
}
