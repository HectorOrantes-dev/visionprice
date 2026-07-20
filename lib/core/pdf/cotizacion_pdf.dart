import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../features/budget/domain/entities/cotizacion_entity.dart';
import '../utils/isolate_runner.dart';

/// Paleta de colores del PDF: replica los tokens de [AppColors] (ver
/// `lib/core/theme/app_theme.dart`) para que el documento se vea consistente
/// con el resto de la app.
class _PdfPalette {
  static final primary = PdfColor.fromInt(0xFF1E3A8A);
  static final gradientEnd = PdfColor.fromInt(0xFF2F5BD9);
  static final primaryLight = PdfColor.fromInt(0xFFEFF6FF);
  static final surfaceVariant = PdfColor.fromInt(0xFFF8FAFC);
  static final textPrimary = PdfColor.fromInt(0xFF0F172A);
  static final textSecondary = PdfColor.fromInt(0xFF64748B);
  static final textOnPrimary = PdfColors.white;
  static final warning = PdfColor.fromInt(0xFFF59E0B);
  static final warningLight = PdfColor.fromInt(0xFFFEF3C7);
  static final success = PdfColor.fromInt(0xFF10B981);
  static final successLight = PdfColor.fromInt(0xFFD1FAE5);
  static final border = PdfColor.fromInt(0xFFE2E8F0);
}

const _mesesEs = [
  'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
  'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
];

/// Formatea una fecha (idealmente ISO `yyyy-MM-dd`) como "20 de julio, 2026".
/// Si no se puede interpretar, devuelve el texto original tal cual.
String _formatFecha(String fecha) {
  final parsed = DateTime.tryParse(fecha);
  if (parsed == null) return fecha;
  return '${parsed.day} de ${_mesesEs[parsed.month - 1]}, ${parsed.year}';
}

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
    final subtotalMateriales =
        cot.lineas.fold<double>(0, (acc, l) => acc + l.subtotal);

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => context.pageNumber == 1
            ? _header(
                title: 'Cotización #${cot.id}',
                fechaLabel: 'Fecha de emisión',
                fecha: cot.fecha.isNotEmpty ? _formatFecha(cot.fecha) : '—',
              )
            : pw.SizedBox(),
        build: (context) => [
          _infoRow(proyecto: proyecto, estado: cot.estado),
          pw.SizedBox(height: 20),
          _tablaLineas(cot.lineas, money),
          pw.SizedBox(height: 16),
          _totales(
            subtotalMateriales: subtotalMateriales,
            manoObra: cot.manoObra,
            total: cot.total,
            totalLabel: 'Total:',
            money: money,
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
    final subtotalMateriales = total - manoObraTotal;

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => context.pageNumber == 1
            ? _header(
                title: 'Presupuesto del proyecto',
                fechaLabel: '${cotizaciones.length} cotización(es)',
                fecha: proyecto,
              )
            : pw.SizedBox(),
        build: (context) => [
          _infoRow(proyecto: proyecto, estado: null),
          pw.SizedBox(height: 20),
          _tablaLineas(lineas, money),
          pw.SizedBox(height: 16),
          _totales(
            subtotalMateriales: subtotalMateriales,
            manoObra: manoObraTotal,
            total: total,
            totalLabel: 'Total general:',
            money: money,
          ),
        ],
      ),
    );
    return doc.save();
  });
}

/// Barra de encabezado con degradado (`primary` → `gradientEnd`), título a la
/// izquierda y un dato secundario alineado a la derecha (fecha de emisión, o
/// el conteo de cotizaciones en el resumen combinado).
pw.Widget _header({
  required String title,
  required String fechaLabel,
  required String fecha,
}) {
  return pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.all(20),
    margin: const pw.EdgeInsets.only(bottom: 20),
    decoration: pw.BoxDecoration(
      gradient: pw.LinearGradient(
        colors: [_PdfPalette.primary, _PdfPalette.gradientEnd],
        begin: pw.Alignment.topLeft,
        end: pw.Alignment.bottomRight,
      ),
      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
    ),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            color: _PdfPalette.textOnPrimary,
            fontSize: 22,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              fechaLabel,
              style: pw.TextStyle(color: _PdfPalette.primaryLight, fontSize: 10),
            ),
            pw.SizedBox(height: 3),
            pw.Text(
              fecha,
              style: pw.TextStyle(
                color: _PdfPalette.textOnPrimary,
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

/// Fila "Proyecto" / badge de "Estado", separada del resto por una línea
/// inferior. Si [estado] es `null` (resumen combinado), solo se muestra el
/// bloque de proyecto.
pw.Widget _infoRow({required String proyecto, required String? estado}) {
  return pw.Container(
    padding: const pw.EdgeInsets.only(bottom: 14),
    decoration: pw.BoxDecoration(
      border: pw.Border(bottom: pw.BorderSide(color: _PdfPalette.border, width: 1.5)),
    ),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _label('Proyecto'),
            pw.SizedBox(height: 3),
            pw.Text(proyecto,
                style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: _PdfPalette.textPrimary)),
          ],
        ),
        if (estado != null)
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              _label('Estado'),
              pw.SizedBox(height: 3),
              _estadoBadge(estado),
            ],
          ),
      ],
    ),
  );
}

pw.Widget _label(String text) => pw.Text(
      text.toUpperCase(),
      style: pw.TextStyle(
        fontSize: 9,
        fontWeight: pw.FontWeight.bold,
        color: _PdfPalette.textSecondary,
        letterSpacing: 0.5,
      ),
    );

/// Pastilla de estado: verde si está confirmada, ámbar en cualquier otro caso
/// (borrador / pendiente), igual que en la lista de PDFs de la app.
pw.Widget _estadoBadge(String estado) {
  final confirmado = estado.toLowerCase().contains('confirm');
  final bg = confirmado ? _PdfPalette.successLight : _PdfPalette.warningLight;
  final fg = confirmado ? _PdfPalette.success : _PdfPalette.warning;
  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: pw.BoxDecoration(
      color: bg,
      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(20)),
    ),
    child: pw.Text(
      estado.toUpperCase(),
      style: pw.TextStyle(
          fontSize: 9, fontWeight: pw.FontWeight.bold, color: fg, letterSpacing: 0.5),
    ),
  );
}

/// Tabla de líneas de cotización: encabezado con fondo `surfaceVariant`,
/// separadores horizontales suaves y, por celda, un título en negrita con un
/// detalle secundario debajo (si la descripción trae un " - ").
pw.Widget _tablaLineas(
    List<LineaCotizacionEntity> lineas, String Function(double) money) {
  return pw.Table(
    columnWidths: const {
      0: pw.FlexColumnWidth(4.2), // Material
      1: pw.FlexColumnWidth(1.1), // Cant.
      2: pw.FlexColumnWidth(1.5), // Unidad
      3: pw.FlexColumnWidth(1.7), // P. unit.
      4: pw.FlexColumnWidth(1.8), // Subtotal
    },
    border: pw.TableBorder(
      horizontalInside: pw.BorderSide(color: _PdfPalette.border, width: 0.75),
    ),
    children: [
      pw.TableRow(
        decoration: pw.BoxDecoration(color: _PdfPalette.surfaceVariant),
        children: [
          _th('Material'),
          _th('Cant.', alignRight: true),
          _th('Unidad'),
          _th('P. Unit.', alignRight: true),
          _th('Subtotal', alignRight: true),
        ],
      ),
      for (final l in lineas)
        pw.TableRow(
          children: [
            _tdItem(l.descripcion),
            _td(l.cantidad.toStringAsFixed(2), alignRight: true),
            _td(l.unidad),
            _td(money(l.precioUnitario), alignRight: true),
            _td(money(l.subtotal), alignRight: true),
          ],
        ),
    ],
  );
}

pw.Widget _th(String text, {bool alignRight = false}) => pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: pw.Text(
        text.toUpperCase(),
        textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.left,
        style: pw.TextStyle(
            fontSize: 8, fontWeight: pw.FontWeight.bold, color: _PdfPalette.textSecondary),
      ),
    );

pw.Widget _td(String text, {bool alignRight = false}) => pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: pw.Text(
        text,
        textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.left,
        style: pw.TextStyle(fontSize: 9, color: _PdfPalette.textPrimary),
      ),
    );

/// Celda de material: título en negrita + detalle secundario gris si la
/// descripción trae la forma "Título - detalle".
pw.Widget _tdItem(String descripcion) {
  final idx = descripcion.indexOf(' - ');
  final title = idx == -1 ? descripcion : descripcion.substring(0, idx);
  final detail = idx == -1 ? null : descripcion.substring(idx + 3);
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title,
            style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
                color: _PdfPalette.textPrimary)),
        if (detail != null) ...[
          pw.SizedBox(height: 2),
          pw.Text(detail,
              style: pw.TextStyle(fontSize: 8, color: _PdfPalette.textSecondary)),
        ],
      ],
    ),
  );
}

/// Bloque de totales alineado a la derecha: subtotal de materiales, mano de
/// obra (si aplica) y el total final destacado en `primary` con una línea
/// divisoria arriba.
pw.Widget _totales({
  required double subtotalMateriales,
  double? manoObra,
  required double total,
  required String totalLabel,
  required String Function(double) money,
}) {
  return pw.Align(
    alignment: pw.Alignment.centerRight,
    child: pw.SizedBox(
      width: 220,
      child: pw.Column(
        children: [
          _totalRow('Subtotal materiales:', money(subtotalMateriales)),
          if (manoObra != null && manoObra > 0)
            _totalRow('Mano de obra:', money(manoObra)),
          pw.Container(
            margin: const pw.EdgeInsets.only(top: 6),
            padding: const pw.EdgeInsets.only(top: 8),
            decoration: pw.BoxDecoration(
              border: pw.Border(top: pw.BorderSide(color: _PdfPalette.border, width: 1.5)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(totalLabel,
                    style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: _PdfPalette.primary)),
                pw.Text(money(total),
                    style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: _PdfPalette.primary)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

pw.Widget _totalRow(String label, String value) => pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 10, color: _PdfPalette.textSecondary)),
          pw.Text(value,
              style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: _PdfPalette.textPrimary)),
        ],
      ),
    );
