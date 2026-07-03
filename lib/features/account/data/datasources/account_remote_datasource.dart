import '../../domain/entities/subscription_entity.dart';

// La implementación vive en su propio archivo (una clase por archivo, SRP);
// se re-exporta para no romper imports existentes ni la DI generada.
export 'account_remote_datasource_impl.dart';

abstract class AccountRemoteDataSource {
  Future<List<SubscriptionEntity>> subscriptions();
}
