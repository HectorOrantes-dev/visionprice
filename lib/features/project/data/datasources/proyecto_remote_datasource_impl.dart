
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../domain/entities/proyecto_entity.dart';
import 'proyecto_remote_datasource.dart';

class ProyectoRemoteDataSourceImpl implements ProyectoRemoteDataSource {
  final ApiClient _client;
  ProyectoRemoteDataSourceImpl(this._client);

  @override
  Future<List<ProyectoEntity>> listar() async {
    final data = await _client.getJsonList(ApiConfig.proyectos, auth: true);
    return data
        .whereType<Map<String, dynamic>>()
        .map(ProyectoEntity.fromJson)
        .toList();
  }

  @override
  Future<ProyectoEntity> crear(String nombre, {String? direccion}) async {
    final data = await _client.postJson(
      ApiConfig.proyectos,
      {
        'nombre': nombre,
        if (direccion != null && direccion.isNotEmpty) 'direccion': direccion,
      },
      auth: true,
    );
    return ProyectoEntity.fromJson(data);
  }
}
