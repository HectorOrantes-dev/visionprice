import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../features/budget/domain/entities/cotizacion_entity.dart';
import '../utils/isolate_runner.dart';

/// Genera el PDF de una cotización **en un isolate** (hilo aislado).
///
/// El armado y render del documento (`doc.save()`) es CPU-intensivo: con
/// cotizaciones largas (muchas líneas de materiales) hacerlo en el hilo de UI
/// causaría jank. Aquí corre en un isolate efímero vía [runHeavy] y devuelve los
/// bytes listos para compartir/guardar/imprimir.
///
/// Usa las fuentes estándar embebidas del paquete `pdf` (Helvetica), por lo que
/// NO necesita cargar assets desde el hilo principal → es seguro en el isolate.
Future<Uint8List> buildCotizacionPdf(CotizacionEntity cot) {
  // La entidad es inmutable/sendable: se captura sin problemas en el isolate.
  return runHeavy(() {
    String money(double v) => '\$${v.toStringAsFixed(2)}';

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Header(level: 0, text: 'Cotización #${cot.id}'),
          pw.SizedBox(height: 4),
          pw.Text('Proyecto: ${cot.proyectoId}   ·   Estado: ${cot.estado}'),
          if (cot.fecha.isNotEmpty) pw.Text('Fecha: ${cot.fecha}'),
          pw.SizedBox(height: 16),
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headers: const [
              'Material',
              'Cant.',
              'Unidad',
              'P. unit.',
              'Subtotal',
            ],
            cellAlignments: const {
              1: pw.Alignment.centerRight,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
            },
            data: [
              for (final l in cot.lineas)
                [
                  l.descripcion,
                  l.cantidad.toStringAsFixed(2),
                  l.unidad,
                  money(l.precioUnitario),
                  money(l.subtotal),
                ],
            ],
          ),
          pw.SizedBox(height: 16),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Total: ${money(cot.total)}',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ],
      ),
    );
    return doc.save();
  });
}
