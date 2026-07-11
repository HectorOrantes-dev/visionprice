
import 'api_client.dart';

/// Verifica conectividad **real** (no solo si hay red): hace ping al back-end.
/// `@lazySingleton` reutilizable por cualquier feature.
class ConnectivityService {
  final ApiClient _client;
  ConnectivityService(this._client);

  Future<bool> isOnline() => _client.ping();
}
