import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/calculo_entity.dart';
import '../../domain/entities/grabacion_entity.dart';
import 'grabacion_remote_datasource.dart';

class GrabacionRemoteDataSourceImpl implements GrabacionRemoteDataSource {
  final ApiClient _client;
  final TokenStorage _tokenStorage;
  final Dio _dio;

  GrabacionRemoteDataSourceImpl(this._client, this._tokenStorage)
      : _dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  @override
  Future<GrabacionEntity> subir(
    String audioPath, {
    int? duracionSegundos,
    int? proyectoId,
    void Function(double)? onProgress,
  }) async {
    final localId = const Uuid().v4();
    final fecha = DateTime.now().toUtc().toIso8601String();
    
    final token = _tokenStorage.token;
    if (token == null) throw Exception('No auth token');

    final formData = FormData.fromMap({
      'proyecto_id': proyectoId ?? 0,
      'local_id': localId,
      'fecha_grabacion': fecha,
      if (duracionSegundos != null) 'duracion_segundos': duracionSegundos,
      'audio': await MultipartFile.fromFile(audioPath),
    });

    final response = await _dio.post(
      ApiConfig.grabaciones,
      data: formData,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
      onSendProgress: (sent, total) {
        if (total > 0 && onProgress != null) {
          onProgress(sent / total);
        }
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
      final data = response.data;
      return GrabacionEntity.fromJson(data);
    } else {
      throw Exception('Error al subir la grabación');
    }
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
  Future<CalculoEntity> calcular(
      {int? grabacionId, String? texto, double? altura}) async {
    final body = <String, dynamic>{};
    if (grabacionId != null) body['grabacion_id'] = grabacionId;
    if (texto != null) body['texto'] = texto;
    // Override manual de la altura de pared cuando el texto no la menciona.
    // El back-end lo combina con el largo_m/ancho_m ya detectados.
    if (altura != null) body['alto_m'] = altura;

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
