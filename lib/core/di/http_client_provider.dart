import 'dart:io';

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
@Riverpod(keepAlive: true)
http.Client httpClient(Ref ref) {
  final inner = HttpClient()..autoUncompress = false;
  final client = IOClient(inner);
  ref.onDispose(client.close);
  return client;
}
