import 'package:injectable/injectable.dart';

import '../entities/subscription_entity.dart';
import '../repositories/account_repository.dart';

@injectable
class ObtenerSuscripcionesUseCase {
  final AccountRepository _repo;
  ObtenerSuscripcionesUseCase(this._repo);

  Future<List<SubscriptionEntity>> call() => _repo.subscriptions();
}
