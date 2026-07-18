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
Future<Uint8List> buildCotizacionPdf(CotizacionEntity cot,
    {String? proyectoNombre}) {
  // La entidad es inmutable/sendable: se captura sin problemas en el isolate.
  return runHeavy(() {
    String money(double v) => '\$${v.toStringAsFixed(2)}';
    final proyecto = (proyectoNombre != null && proyectoNombre.trim().isNotEmpty)
        ? proyectoNombre.trim()
        : 'Proyecto #${cot.proyectoId}';

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Header(level: 0, text: 'Cotización #${cot.id}'),
          pw.SizedBox(height: 4),
          pw.Text('Proyecto: $proyecto',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
          pw.Text('Estado: ${cot.estado}'),
          if (cot.fecha.isNotEmpty) pw.Text('Fecha: ${cot.fecha}'),
          pw.SizedBox(height: 16),
          _tablaLineas(cot.lineas, money),
          pw.SizedBox(height: 16),
          if (cot.manoObra != null)
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text('Mano de obra: ${money(cot.manoObra!)}'),
            ),
          if (cot.manoObra != null) pw.SizedBox(height: 4),
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

/// Genera un PDF con las líneas de VARIAS cotizaciones juntas (ej. una
/// simple + una kit del mismo proyecto) y un total general combinado.
/// Mismo mecanismo en isolate que [buildCotizacionPdf].
Future<Uint8List> buildResumenCotizacionesPdf(List<CotizacionEntity> cotizaciones,
    {String? proyectoNombre}) {
  return runHeavy(() {
    String money(double v) => '\$${v.toStringAsFixed(2)}';
    final total = cotizaciones.fold<double>(0, (acc, c) => acc + c.total);
    final manoObraTotal = cotizaciones.fold<double>(
        0, (acc, c) => acc + (c.manoObra ?? 0));
    final proyecto = (proyectoNombre != null && proyectoNombre.trim().isNotEmpty)
        ? proyectoNombre.trim()
        : 'Proyecto #${cotizaciones.isNotEmpty ? cotizaciones.first.proyectoId : 0}';
    final lineas = [for (final cot in cotizaciones) ...cot.lineas];

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Header(level: 0, text: 'Presupuesto del proyecto'),
          pw.SizedBox(height: 4),
          pw.Text('Proyecto: $proyecto',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
          pw.Text('${cotizaciones.length} cotización(es)'),
          pw.SizedBox(height: 16),
          _tablaLineas(lineas, money),
          pw.SizedBox(height: 16),
          if (manoObraTotal > 0)
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text('Mano de obra: ${money(manoObraTotal)}'),
            ),
          if (manoObraTotal > 0) pw.SizedBox(height: 4),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Total general: ${money(total)}',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ],
      ),
    );
    return doc.save();
  });
}

/// Tabla de líneas de cotización con anchos de columna proporcionales al
/// contenido: la columna "Material" (texto largo) toma la mayor parte y las
/// numéricas ("Cant.", "P. unit.", "Subtotal") reservan el ancho suficiente
/// para que sus encabezados NO se recorten ni se envuelvan.
pw.Widget _tablaLineas(
    List<LineaCotizacionEntity> lineas, String Function(double) money) {
  return pw.TableHelper.fromTextArray(
    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
    cellStyle: const pw.TextStyle(fontSize: 9),
    headerCellDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
    cellPadding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 4),
    columnWidths: const {
      0: pw.FlexColumnWidth(4.2), // Material
      1: pw.FlexColumnWidth(1.1), // Cant.
      2: pw.FlexColumnWidth(1.5), // Unidad
      3: pw.FlexColumnWidth(1.7), // P. unit.
      4: pw.FlexColumnWidth(1.8), // Subtotal
    },
    headers: const ['Material', 'Cant.', 'Unidad', 'P. unit.', 'Subtotal'],
    headerAlignments: const {
      1: pw.Alignment.centerRight,
      3: pw.Alignment.centerRight,
      4: pw.Alignment.centerRight,
    },
    cellAlignments: const {
      1: pw.Alignment.centerRight,
      3: pw.Alignment.centerRight,
      4: pw.Alignment.centerRight,
    },
    data: [
      for (final l in lineas)
        [
          l.descripcion,
          l.cantidad.toStringAsFixed(2),
          l.unidad,
          money(l.precioUnitario),
          money(l.subtotal),
        ],
    ],
  );
}
