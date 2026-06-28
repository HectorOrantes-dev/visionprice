import 'dart:convert';
import 'dart:isolate';

/// Decodifica un [String] JSON en un objeto Dart ([Map] o [List]).
///
/// Para respuestas pequeñas se decodifica en el mismo hilo.
/// Para respuestas grandes (> 50 KB) se delega a un [Isolate] secundario
/// para no bloquear la UI.
Future<dynamic> decodeJson(String body) {
  if (body.length < 51200) {
    // Respuesta pequeña: decodificación directa, sin overhead de isolate.
    return Future.value(jsonDecode(body));
  }
  // Respuesta grande: enviar a un isolate para no congelar el hilo principal.
  return Isolate.run(() => jsonDecode(body));
}
