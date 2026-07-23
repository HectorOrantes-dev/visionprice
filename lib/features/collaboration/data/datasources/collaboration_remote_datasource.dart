import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../domain/entities/invitacion_entity.dart';
import '../../domain/entities/miembros_result_entity.dart';
import '../../domain/entities/unirse_result_entity.dart';

abstract class CollaborationRemoteDataSource {
  Future<MiembrosResultEntity> obtenerMiembros(int proyectoId);
  Future<void> quitarMiembro(int proyectoId, int usuarioId);
  Future<InvitacionEntity> generarInvitacion(
      int proyectoId, String rol, List<String>? correos);
  Future<List<InvitacionEntity>> obtenerInvitaciones(int proyectoId);
  Future<void> revocarInvitacion(int proyectoId, int invitacionId);
  Future<UnirseResultEntity> unirseAProyecto(String codigo);
}

class CollaborationRemoteDataSourceImpl
    implements CollaborationRemoteDataSource {
  final ApiClient _client;

  CollaborationRemoteDataSourceImpl(this._client);

  @override
  Future<MiembrosResultEntity> obtenerMiembros(int proyectoId) async {
    final data = await _client.getJson(ApiConfig.proyectoMiembros(proyectoId),
        auth: true);
    return MiembrosResultEntity.fromJson(data);
  }

  @override
  Future<void> quitarMiembro(int proyectoId, int usuarioId) async {
    await _client.deleteJson(ApiConfig.proyectoMiembro(proyectoId, usuarioId),
        auth: true);
  }

  @override
  Future<InvitacionEntity> generarInvitacion(
      int proyectoId, String rol, List<String>? correos) async {
    final body = <String, dynamic>{
      'rol_en_proyecto': rol,
      if (correos != null && correos.isNotEmpty) 'correos': correos,
    };
    final data = await _client.postJson(
      ApiConfig.proyectoInvitaciones(proyectoId),
      body,
      auth: true,
    );
    return InvitacionEntity.fromJson(data);
  }

  @override
  Future<List<InvitacionEntity>> obtenerInvitaciones(int proyectoId) async {
    final data = await _client
        .getJsonList(ApiConfig.proyectoInvitaciones(proyectoId), auth: true);
    return data
        .whereType<Map<String, dynamic>>()
        .map(InvitacionEntity.fromJson)
        .toList();
  }

  @override
  Future<void> revocarInvitacion(int proyectoId, int invitacionId) async {
    // El back-end expone esto como POST .../revocar, NO como DELETE.
    await _client.postJson(
      ApiConfig.proyectoInvitacionRevocar(proyectoId, invitacionId),
      const {},
      auth: true,
    );
  }

  @override
  Future<UnirseResultEntity> unirseAProyecto(String codigo) async {
    final body = <String, dynamic>{'codigo': codigo};
    final data =
        await _client.postJson(ApiConfig.proyectosUnirse, body, auth: true);
    return UnirseResultEntity.fromJson(data);
  }
}
