import '../entities/subscription_entity.dart';

abstract class AccountRepository {
  Future<List<SubscriptionEntity>> subscriptions();
}
