import 'package:injectable/injectable.dart';

import '../../domain/entities/subscription_entity.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_remote_datasource.dart';

@LazySingleton(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource _remote;
  AccountRepositoryImpl(this._remote);

  @override
  Future<List<SubscriptionEntity>> subscriptions() => _remote.subscriptions();
}
