import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http_client_provider.g.dart';

/// Cliente HTTP compartido (core). `keepAlive`: singleton de sesión.
///
/// Se construye sobre un `HttpClient` con `autoUncompress = false`: algunos
/// back-ends/proxies responden con `Content-Encoding: gzip` pero un cuerpo que
/// NO es un gzip válido, y la descompresión automática de Dart reventaba con
/// `FormatException: Filter error, bad data`. Con esto Dart nunca intenta
/// descomprimir; además pedimos el cuerpo sin comprimir vía el header
/// `Accept-Encoding: identity` (ver `ApiClient._headers`).
///
/// En Flutter Web, `dart:io.HttpClient` no existe de verdad (el navegador
/// maneja la red solo) — instanciarlo revienta con un error NO clasificado
/// (no `ApiException`) en cuanto se arma la primera petición, antes de que
/// `ApiClient._send` llegue siquiera a intentar el request. Eso es lo que se
/// veía como "Ocurrió un error inesperado" sin ningún log de red de por
/// medio. En web se usa el `http.Client()` normal (respaldado por el
/// `BrowserClient` del propio navegador).
@Riverpod(keepAlive: true)
http.Client httpClient(Ref ref) {
  if (kIsWeb) {
    final client = http.Client();
    ref.onDispose(client.close);
    return client;
  }
  final inner = HttpClient()..autoUncompress = false;
  final client = IOClient(inner);
  ref.onDispose(client.close);
  return client;
}
