import 'package:injectable/injectable.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../domain/entities/notificacion_entity.dart';

abstract class NotificacionRemoteDataSource {
  Future<List<NotificacionEntity>> listar(bool soloNoLeidas);
  Future<void> marcarLeida(int id);
}

@LazySingleton(as: NotificacionRemoteDataSource)
class NotificacionRemoteDataSourceImpl implements NotificacionRemoteDataSource {
  final ApiClient _client;
  NotificacionRemoteDataSourceImpl(this._client);

  @override
  Future<List<NotificacionEntity>> listar(bool soloNoLeidas) async {
    final data = await _client.getJsonList(
      ApiConfig.notificaciones,
      auth: true,
      query: soloNoLeidas ? {'no_leidas': 'true'} : null,
    );
    return data
        .whereType<Map<String, dynamic>>()
        .map(NotificacionEntity.fromJson)
        .toList();
  }

  @override
  Future<void> marcarLeida(int id) async {
    await _client.postJson(ApiConfig.notificacionLeida(id), {}, auth: true);
  }
}
