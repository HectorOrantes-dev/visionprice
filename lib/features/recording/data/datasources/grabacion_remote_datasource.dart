import 'package:injectable/injectable.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../domain/entities/calculo_entity.dart';
import '../../domain/entities/grabacion_entity.dart';

abstract class GrabacionRemoteDataSource {
  Future<GrabacionEntity> subir(
    String audioPath, {
    int? duracionSegundos,
    int? proyectoId,
  });
  Future<GrabacionEntity> detalle(int id);
  Future<List<GrabacionEntity>> historial();
  Future<CalculoEntity> calcular(int grabacionId);
}

@LazySingleton(as: GrabacionRemoteDataSource)
class GrabacionRemoteDataSourceImpl implements GrabacionRemoteDataSource {
  final ApiClient _client;
  GrabacionRemoteDataSourceImpl(this._client);

  @override
  Future<GrabacionEntity> subir(
    String audioPath, {
    int? duracionSegundos,
    int? proyectoId,
  }) async {
    final data = await _client.postMultipart(
      ApiConfig.grabaciones,
      filePath: audioPath,
      fileField: 'audio',
      fields: {
        if (duracionSegundos != null)
          'duracion_segundos': '$duracionSegundos',
        if (proyectoId != null) 'proyecto_id': '$proyectoId',
      },
    );
    return GrabacionEntity.fromJson(data);
  }

  @override
  Future<GrabacionEntity> detalle(int id) async {
    final data = await _client.getJson(ApiConfig.grabacion(id));
    return GrabacionEntity.fromJson(data);
  }

  @override
  Future<List<GrabacionEntity>> historial() async {
    final data = await _client.getJsonList(ApiConfig.grabaciones, auth: true);
    return data
        .whereType<Map<String, dynamic>>()
        .map(GrabacionEntity.fromJson)
        .toList();
  }

  @override
  Future<CalculoEntity> calcular(int grabacionId) async {
    final data = await _client.postJson(
      ApiConfig.cotizacionesCalculo,
      {'grabacion_id': grabacionId},
      auth: true,
    );
    return CalculoEntity.fromJson(data);
  }
}
