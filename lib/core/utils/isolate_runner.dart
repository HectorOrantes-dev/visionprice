import 'dart:async';
import 'dart:isolate';

/// Ejecuta [task] en un **isolate efímero** (hilo aislado) para no bloquear el
/// hilo de UI con trabajo CPU-intensivo. El hilo principal queda libre para
/// pintar → sin jank ni "congelamientos".
///
/// Es la forma bendecida de descargar trabajo pesado en el proyecto (parseo de
/// datos grandes, generación de PDF, compresión, hashing…).
///
/// Reglas de uso:
/// - Solo para trabajo **pesado y puro** (sin plugins, `BuildContext`, ni `ref`).
/// - [task] y su resultado deben ser "sendables" entre isolates: tipos simples,
///   `List`/`Map`, `Uint8List`, u objetos **inmutables**. No captures sockets,
///   controllers, ni el `ProviderRef`.
/// - **NO** usar para I/O de red (ya es asíncrono) ni para decodificar imágenes
///   de `Image.network` (el engine de Flutter ya lo hace fuera del hilo de UI;
///   para imágenes pesadas usar `cacheWidth`/`cacheHeight`).
///
/// Internamente usa `Isolate.run` (Dart 3): crea el isolate, ejecuta, devuelve
/// el resultado y lo destruye automáticamente.
Future<R> runHeavy<R>(FutureOr<R> Function() task) => Isolate.run(task);
