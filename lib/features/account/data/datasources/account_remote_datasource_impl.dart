import 'package:injectable/injectable.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../domain/entities/subscription_entity.dart';
import 'account_remote_datasource.dart';

@LazySingleton(as: AccountRemoteDataSource)
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
}
