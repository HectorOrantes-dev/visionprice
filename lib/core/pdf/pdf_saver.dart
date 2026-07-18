import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Resultado de guardar un PDF en el dispositivo.
class PdfSaveResult {
  final bool ok;
  final String? path;

  /// `true` si se guardó en la carpeta pública de Descargas (visible en el
  /// gestor de archivos); `false` si cayó en el almacenamiento propio de la app.
  final bool enDescargas;

  const PdfSaveResult({required this.ok, this.path, this.enDescargas = false});
}

/// Guarda [bytes] como un archivo PDF **directamente en el teléfono**, sin abrir
/// el diálogo de impresión. En Android intenta la carpeta pública `Download`
/// (visible desde el gestor de archivos); si el sistema la bloquea (scoped
/// storage), cae al almacenamiento externo propio de la app. En otras
/// plataformas usa el directorio de documentos de la app.
Future<PdfSaveResult> savePdfToDevice(Uint8List bytes, String filename) async {
  try {
    if (Platform.isAndroid) {
      // 1. Carpeta pública de Descargas (la que ve el usuario).
      final publicDownloads = Directory('/storage/emulated/0/Download');
      if (await publicDownloads.exists()) {
        try {
          final file = File('${publicDownloads.path}/$filename');
          await file.writeAsBytes(bytes, flush: true);
          return PdfSaveResult(ok: true, path: file.path, enDescargas: true);
        } catch (_) {
          // Bloqueado por scoped storage → se usa el fallback de abajo.
        }
      }
      // 2. Fallback: almacenamiento externo propio de la app (sin permisos).
      final ext = await getExternalStorageDirectory();
      final dir = ext ?? await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(bytes, flush: true);
      return PdfSaveResult(ok: true, path: file.path);
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return PdfSaveResult(ok: true, path: file.path);
  } catch (e) {
    debugPrint('PDF: no se pudo guardar en el dispositivo -> $e');
    return const PdfSaveResult(ok: false);
  }
}
