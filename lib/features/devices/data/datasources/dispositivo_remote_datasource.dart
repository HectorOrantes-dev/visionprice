import 'package:injectable/injectable.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';

abstract class DispositivoRemoteDataSource {
  Future<void> registrar(String token, String plataforma);
  Future<void> borrar(String token);
}

@LazySingleton(as: DispositivoRemoteDataSource)
class DispositivoRemoteDataSourceImpl implements DispositivoRemoteDataSource {
  final ApiClient _client;
  DispositivoRemoteDataSourceImpl(this._client);

  @override
  Future<void> registrar(String token, String plataforma) async {
    await _client.postJson(
      ApiConfig.dispositivos,
      {'token': token, 'plataforma': plataforma},
      auth: true,
    );
  }

  @override
  Future<void> borrar(String token) async {
    await _client.deleteJson(
      ApiConfig.dispositivos,
      body: {'token': token},
      auth: true,
    );
  }
}
