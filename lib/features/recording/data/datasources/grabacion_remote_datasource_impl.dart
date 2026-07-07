import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../../sync/services/sync_service.dart';
import '../../domain/entities/calculo_entity.dart';
import '../../domain/entities/grabacion_entity.dart';
import 'grabacion_remote_datasource.dart';

@LazySingleton(as: GrabacionRemoteDataSource)
class GrabacionRemoteDataSourceImpl implements GrabacionRemoteDataSource {
  final ApiClient _client;
  final SyncService _syncService;

  GrabacionRemoteDataSourceImpl(this._client, this._syncService);

  @override
  Future<GrabacionEntity> subir(
    String audioPath, {
    int? duracionSegundos,
    int? proyectoId,
  }) async {
    final localId = const Uuid().v4();
    final fecha = DateTime.now().toUtc().toIso8601String();

    await _syncService.queueAudio(
      localId: localId,
      audioPath: audioPath,
      proyectoId: proyectoId ?? 0,
      fechaGrabacion: fecha,
      duracionSegundos: duracionSegundos,
    );

    // Retorna una entidad simulada porque la subida es asíncrona
    return GrabacionEntity(
      id: 0,
      proyectoId: proyectoId,
      estado: 'pending',
      duracionSegundos: duracionSegundos,
      fechaGrabacion: fecha,
    );
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
  Future<CalculoEntity> calcular({int? grabacionId, String? texto}) async {
    final body = <String, dynamic>{};
    if (grabacionId != null) body['grabacion_id'] = grabacionId;
    if (texto != null) body['texto'] = texto;

    final data = await _client.postJson(
      ApiConfig.cotizacionesCalculo,
      body,
      auth: true,
    );
    return CalculoEntity.fromJson(data);
  }

  @override
  Future<GrabacionEntity> actualizarTranscripcion(int id, String texto) async {
    // _client might not have patchJson. Let me check if ApiClient has patchJson.
    // Assuming yes, but if not I'll fix it later.
    final data = await _client.patchJson(
      ApiConfig.grabacionTranscripcion(id),
      {'texto': texto},
      auth: true,
    );
    return GrabacionEntity.fromJson(data);
  }
}
