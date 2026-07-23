import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/pdf/pdf_saver.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/cotizacion_pdf_entity.dart';
import '../providers/budget_providers.dart';

/// Tarjeta de una cotización/PDF en "Mis Cotizaciones": muestra la obra, estado, total
/// y fecha, con acciones para descargar y compartir el PDF (bytes del back-end).
class CotizacionPdfCard extends ConsumerStatefulWidget {
  final CotizacionPdfEntity pdf;
  const CotizacionPdfCard({super.key, required this.pdf});

  @override
  ConsumerState<CotizacionPdfCard> createState() => _CotizacionPdfCardState();
}

class _CotizacionPdfCardState extends ConsumerState<CotizacionPdfCard> {
  bool _descargando = false;

  static final _money = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

  String get _fecha {
    final f = DateTime.tryParse(widget.pdf.fecha);
    if (f == null) return widget.pdf.fecha;
    // Formato manual (dd/MM/aaaa) para no depender de initializeDateFormatting.
    String dos(int n) => n.toString().padLeft(2, '0');
    return '${dos(f.day)}/${dos(f.month)}/${f.year}';
  }

  Future<Uint8List?> _bytes() async {
    try {
      return await ref.read(descargarPdfBytesUseCaseProvider)(widget.pdf.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              e is ApiException ? e.message : 'No se pudo obtener el PDF.'),
        ));
      }
      return null;
    }
  }

  Future<void> _descargar() async {
    setState(() => _descargando = true);
    final bytes = await _bytes();
    if (bytes != null) {
      final res =
          await savePdfToDevice(bytes, 'cotizacion_${widget.pdf.id}.pdf');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(res.ok
              ? (res.enDescargas
                  ? 'PDF guardado en Descargas'
                  : 'PDF guardado en: ${res.path}')
              : 'No se pudo guardar el PDF.'),
        ));
      }
    }
    if (mounted) setState(() => _descargando = false);
  }

  Future<void> _compartir() async {
    setState(() => _descargando = true);
    final bytes = await _bytes();
    if (bytes != null) {
      await Printing.sharePdf(
          bytes: bytes, filename: 'cotizacion_${widget.pdf.id}.pdf');
    }
    if (mounted) setState(() => _descargando = false);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final confirmado = widget.pdf.estado.toLowerCase() == 'confirmado';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: c.primaryLight,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(Icons.picture_as_pdf_outlined,
                    color: c.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pdf.proyectoNombre.isEmpty
                          ? 'Obra #${widget.pdf.proyectoId}'
                          : widget.pdf.proyectoNombre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text('Cotización #${widget.pdf.numero} · $_fecha',
                        style: TextStyle(fontSize: 12, color: c.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: confirmado ? c.successLight : c.surfaceVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  confirmado ? 'Confirmado' : 'Borrador',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: confirmado ? c.success : c.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                _money.format(widget.pdf.total),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: c.primary,
                ),
              ),
              const Spacer(),
              if (_descargando)
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else ...[
                IconButton(
                  onPressed: _compartir,
                  icon: Icon(Icons.ios_share_outlined, color: c.textSecondary),
                  tooltip: 'Compartir',
                ),
                IconButton(
                  onPressed: _descargar,
                  icon: Icon(Icons.download_outlined, color: c.primary),
                  tooltip: 'Descargar',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
