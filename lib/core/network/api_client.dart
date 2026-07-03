import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../storage/token_storage.dart';
import '../utils/json_codec.dart';
import 'api_config.dart';
import 'api_exception.dart';

/// Cliente HTTP central de la app.
///
/// `@lazySingleton`: se comparte en toda la app y mantiene colaboradores
/// pesados ([http.Client]). Inyecta [http.Client] (provisto por
/// `RegisterModule`) y [TokenStorage] para adjuntar el `Bearer` token.
@lazySingleton
class ApiClient {
  final http.Client _client;
  final TokenStorage _tokenStorage;

  ApiClient(this._client, this._tokenStorage);

  static const Duration _timeout = Duration(seconds: 20);

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final base = Uri.parse('${ApiConfig.baseUrl}$path');
    if (query == null || query.isEmpty) return base;
    return base.replace(
      queryParameters: {
        ...base.queryParameters,
        for (final e in query.entries)
          if (e.value != null) e.key: '${e.value}',
      },
    );
  }

  Map<String, String> _headers({bool auth = false}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (auth && _tokenStorage.hasToken) {
      headers['Authorization'] = 'Bearer ${_tokenStorage.token}';
    }
    return headers;
  }

  Future<Map<String, dynamic>> postJson(
    String path,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    final data = await _send(() => _client.post(
          _uri(path),
          headers: _headers(auth: auth),
          body: jsonEncode(body),
        ));
    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, dynamic>? query,
    bool auth = true,
  }) async {
    final data = await _send(
        () => _client.get(_uri(path, query), headers: _headers(auth: auth)));
    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }

  /// DELETE con cuerpo JSON opcional (p. ej. borrar un device token).
  Future<Map<String, dynamic>> deleteJson(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final data = await _send(() => _client.delete(
          _uri(path),
          headers: _headers(auth: auth),
          body: body != null ? jsonEncode(body) : null,
        ));
    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }

  /// Sube un archivo con `multipart/form-data` (p. ej. el audio de una
  /// grabación). [fields] son campos de texto adicionales del formulario.
  /// Usa un timeout mayor porque subir audio puede tardar más.
  Future<Map<String, dynamic>> postMultipart(
    String path, {
    required String filePath,
    String fileField = 'audio',
    Map<String, String>? fields,
    bool auth = true,
  }) async {
    final data = await _send(
      () async {
        final req = http.MultipartRequest('POST', _uri(path));
        // El propio MultipartRequest fija el Content-Type con su boundary.
        req.headers.addAll(_headers(auth: auth)..remove('Content-Type'));
        if (fields != null) req.fields.addAll(fields);
        req.files.add(await http.MultipartFile.fromPath(fileField, filePath));
        final streamed = await req.send();
        return http.Response.fromStream(streamed);
      },
      timeout: const Duration(seconds: 60),
    );
    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }

  /// GET que devuelve el JSON crudo decodificado (`Map` o `List`), para
  /// endpoints cuyo esquema es variable (p. ej. `/me/subscriptions`).
  Future<dynamic> getRaw(String path, {bool auth = true}) {
    return _send(
        () => _client.get(_uri(path), headers: _headers(auth: auth)));
  }

  /// Para endpoints que devuelven un arreglo JSON (p. ej. `GET /roles`).
  Future<List<dynamic>> getJsonList(
    String path, {
    Map<String, dynamic>? query,
    bool auth = false,
  }) async {
    final data = await _send(
        () => _client.get(_uri(path, query), headers: _headers(auth: auth)));
    return data is List ? data : const [];
  }

  /// Verificación rápida de conectividad real: intenta `GET /health` con un
  /// timeout corto. Devuelve `true` solo si el back-end respondió.
  Future<bool> ping() async {
    try {
      final res = await _client
          .get(_uri(ApiConfig.health))
          .timeout(const Duration(seconds: 6));
      return res.statusCode >= 200 && res.statusCode < 500;
    } catch (_) {
      return false;
    }
  }

  /// Ejecuta la petición, normaliza errores de red y descarga el parseo del
  /// cuerpo a un isolate cuando es grande (ver [decodeJson]). Devuelve el JSON
  /// decodificado (`Map` o `List`) o lanza [ApiException] en error.
  Future<dynamic> _send(
    Future<http.Response> Function() request, {
    Duration? timeout,
    bool allowRefresh = true,
  }) async {
    http.Response res;
    try {
      res = await request().timeout(timeout ?? _timeout);
    } on TimeoutException {
      throw ApiException.network('La solicitud tardó demasiado.');
    } catch (_) {
      throw ApiException.network();
    }

    // Access token vencido: intenta renovarlo con el refresh token UNA vez y
    // reintenta la petición original (las closures reconstruyen el header
    // Authorization con el token nuevo). Si no se puede renovar, cae al 401.
    if (res.statusCode == 401 &&
        allowRefresh &&
        _tokenStorage.hasRefreshToken) {
      final renovado = await _refreshSession();
      if (renovado) {
        return _send(request, timeout: timeout, allowRefresh: false);
      }
    }

    final decoded = res.body.isNotEmpty ? await decodeJson(res.body) : null;

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return decoded;
    }
    // Sesión no recuperable: borra los tokens para que el próximo arranque
    // pida login en vez de auto-entrar con una sesión muerta.
    if (res.statusCode == 401) {
      unawaited(_tokenStorage.clear());
    }
    throw ApiException(res.statusCode, _extractError(decoded));
  }

  /// Renovación de sesión con *single-flight*: si varias peticiones reciben 401
  /// a la vez, comparten UNA sola llamada a `/auth/refresh`.
  Future<bool>? _refreshing;

  Future<bool> _refreshSession() {
    return _refreshing ??= _doRefresh().whenComplete(() => _refreshing = null);
  }

  Future<bool> _doRefresh() async {
    final refreshToken = _tokenStorage.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) return false;
    try {
      // Llamada directa (no pasa por _send) para evitar recursión/limpieza.
      final res = await _client
          .post(
            _uri(ApiConfig.refresh),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'refresh_token': refreshToken}),
          )
          .timeout(_timeout);
      if (res.statusCode < 200 || res.statusCode >= 300) return false;
      final data = res.body.isNotEmpty ? await decodeJson(res.body) : null;
      if (data is Map<String, dynamic>) {
        final access = (data['access_token'] ?? '').toString();
        final newRefresh = data['refresh_token']?.toString();
        if (access.isNotEmpty) {
          await _tokenStorage.saveSession(access, newRefresh);
          return true;
        }
      }
    } catch (_) {
      // Sin red o error transitorio: no renovamos ahora (no borramos tokens).
    }
    return false;
  }

  /// Extrae un mensaje legible de los distintos formatos de error del back-end:
  /// - `{ "error": { "code": ..., "message": ... } }` (formato propio)
  /// - `{ "detail": [ { "msg": ... } ] }` (validación 422 de FastAPI)
  /// - `{ "message": ... }` / `{ "detail": "..." }`
  String _extractError(dynamic data) {
    if (data is Map) {
      final error = data['error'];
      if (error is Map && error['message'] != null) {
        return error['message'].toString();
      }
      if (error is String && error.isNotEmpty) return error;

      final detail = data['detail'];
      if (detail is List && detail.isNotEmpty) {
        final msgs = detail
            .map((e) => e is Map ? (e['msg'] ?? '').toString() : e.toString())
            .where((s) => s.isNotEmpty);
        if (msgs.isNotEmpty) return msgs.join('\n');
      }
      return (data['message'] ?? data['detail'] ?? 'Error inesperado')
          .toString();
    }
    return 'Error inesperado';
  }
}
