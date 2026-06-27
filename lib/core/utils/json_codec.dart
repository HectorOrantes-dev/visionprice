import 'dart:convert';
import 'dart:isolate';

/// Umbral (en bytes) a partir del cual conviene decodificar el JSON en otro
/// isolate. Por debajo de esto el costo de mover datos entre isolates supera
/// al del propio `jsonDecode`.
const int _kOffloadThreshold = 48 * 1024; // 48 KB

/// Decodifica una respuesta JSON sin bloquear el hilo de UI.
///
/// **Por qué importa (event loop + UI jank):** `jsonDecode` es síncrono y
/// corre hasta terminar dentro del event loop. Un cuerpo grande (listas de
/// notificaciones, catálogos) monopoliza el hilo y se "comen" frames → JANK.
///
/// - Cuerpos pequeños → se decodifican aquí mismo. Devolver vía `Future`
///   encola la continuación en la **Microtask Queue** (FIFO), que el event
///   loop drena por completo antes de tomar el siguiente evento de la UI.
/// - Cuerpos grandes → `Isolate.run` ejecuta el parseo en un isolate efímero
///   con su propio event loop; el hilo de UI queda libre para pintar.
Future<dynamic> decodeJson(String body) async {
  if (body.length < _kOffloadThreshold) {
    return jsonDecode(body);
  }
  return Isolate.run(() => jsonDecode(body));
}

/// Igual que [decodeJson] pero tipado a `Map<String, dynamic>`.
Future<Map<String, dynamic>> decodeJsonMap(String body) async {
  final decoded = await decodeJson(body);
  if (decoded is Map<String, dynamic>) return decoded;
  return <String, dynamic>{};
}
