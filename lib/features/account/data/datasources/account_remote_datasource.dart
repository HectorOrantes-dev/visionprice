import '../../domain/entities/subscription_entity.dart';

abstract class AccountRemoteDataSource {
  Future<List<SubscriptionEntity>> subscriptions();
}
