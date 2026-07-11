import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/cotizacion_entity.dart';
import 'export_pdf_screen.dart';

class BudgetResultScreen extends StatelessWidget {
  final CotizacionEntity cotizacion;
  const BudgetResultScreen({super.key, required this.cotizacion});

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat.currency(locale: 'es_MX', symbol: '\$');
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            _ResultAppBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _TotalCard(
                    total: money.format(cotizacion.total),
                    estado: cotizacion.estado,
                    lineas: cotizacion.lineas.length,
                  ),
                  const SizedBox(height: 20),
                  const _SectionLabel('DESGLOSE DE MATERIALES'),
                  const SizedBox(height: 8),
                  if (cotizacion.lineas.isEmpty)
                    Text('Sin líneas',
                        style: TextStyle(color: context.colors.textSecondary))
                  else
                    ...cotizacion.lineas.map(
                      (l) => _LineaCard(linea: l, money: money),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExportPdfScreen(cotizacion: cotizacion),
                    ),
                  ),
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                  label: const Text('Exportar PDF'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios,
                size: 18, color: context.colors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: context.colors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.receipt_long_outlined,
                color: context.colors.primary, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cotización',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
              Text(
                'Materiales y precios',
                style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: context.colors.textSecondary,
        letterSpacing: 1.0,
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  final String total;
  final String estado;
  final int lineas;
  const _TotalCard({
    required this.total,
    required this.estado,
    required this.lineas,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colors.info, context.colors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('TOTAL ESTIMADO',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white70,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 6),
          Text(
            total,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$lineas materiales · $estado',
            style: const TextStyle(fontSize: 13, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _LineaCard extends StatelessWidget {
  final LineaCotizacionEntity linea;
  final NumberFormat money;
  const _LineaCard({required this.linea, required this.money});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  linea.descripcion,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${linea.cantidad.toStringAsFixed(2)} ${linea.unidad} × ${money.format(linea.precioUnitario)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            money.format(linea.subtotal),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
