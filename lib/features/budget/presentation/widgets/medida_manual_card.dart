import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../recording/presentation/providers/parameters_provider.dart';
import 'accion_btn.dart';
import 'num_field.dart';

/// Tarjeta de superficie MANUAL en MEDIDAS: una tarjeta unificada que "espera la
/// info necesaria" (ancho×alto). Colapsada muestra "+ Agregar medida a mano";
/// abierta pide las medidas y calcula el área (`paredes_m2`). Se auto-abre si el
/// back-end pidió medidas o si ya hay un área capturada.
class MedidaManualCard extends ConsumerStatefulWidget {
  final int grabacionId;
  const MedidaManualCard({super.key, required this.grabacionId});

  @override
  ConsumerState<MedidaManualCard> createState() => _MedidaManualCardState();
}

class _MedidaManualCardState extends ConsumerState<MedidaManualCard> {
  final _anchoController = TextEditingController();
  final _altoController = TextEditingController();
  bool _abierto = false;

  @override
  void initState() {
    super.initState();
    _abierto =
        ref.read(parametersProvider(widget.grabacionId)).areaManualM2 != null;
    _anchoController.addListener(_refresh);
    _altoController.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _anchoController.dispose();
    _altoController.dispose();
    super.dispose();
  }

  static double? _num(String v) {
    final t = v.trim().replaceAll(',', '.');
    return t.isEmpty ? null : double.tryParse(t);
  }

  void _calcular() {
    FocusScope.of(context).unfocus();
    final ancho = _num(_anchoController.text);
    final alto = _num(_altoController.text);
    if (ancho == null || alto == null || ancho <= 0 || alto <= 0) return;
    ref
        .read(parametersProvider(widget.grabacionId).notifier)
        .aplicarParedManual(ancho * alto);
  }

  void _quitar() {
    _anchoController.clear();
    _altoController.clear();
    ref
        .read(parametersProvider(widget.grabacionId).notifier)
        .quitarParedManual();
    setState(() => _abierto = false);
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(parametersProvider(widget.grabacionId));
    final area = vm.areaManualM2;
    // Se auto-abre si el back-end pide medidas (pared puntual / falta altura).
    final abierto =
        _abierto || area != null || vm.requiereParedManual || vm.requiereAltura;

    if (!abierto) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => setState(() => _abierto = true),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Agregar medida a mano'),
            style: TextButton.styleFrom(
              foregroundColor: context.colors.primary,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
      );
    }

    final ancho = _num(_anchoController.text);
    final alto = _num(_altoController.text);
    final areaViva = (ancho != null && alto != null) ? ancho * alto : null;

    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: context.colors.primary.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.square_outlined,
                  size: 18, color: context.colors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Pared (medida a mano)',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: context.colors.textPrimary)),
              ),
              InkWell(
                onTap: _quitar,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(Icons.close,
                      size: 18, color: context.colors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: NumField(
                  controller: _anchoController,
                  hint: 'Ancho',
                  onSubmit: _calcular,
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text('×',
                    style: TextStyle(
                        fontSize: 18,
                        color: context.colors.textSecondary,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: NumField(
                  controller: _altoController,
                  hint: 'Alto',
                  onSubmit: _calcular,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  area != null
                      ? '✓ Área: ${area.toStringAsFixed(2)} m²'
                      : areaViva != null
                          ? '= ${areaViva.toStringAsFixed(2)} m²'
                          : 'Ingresa ancho y alto',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: area != null
                        ? context.colors.success
                        : context.colors.textSecondary,
                  ),
                ),
              ),
              AccionBtn(
                loading: vm.recalculando,
                labelIdle: area != null ? 'Actualizar' : 'Calcular',
                labelBusy: 'Calculando…',
                icon: Icons.calculate_outlined,
                onPressed: _calcular,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
