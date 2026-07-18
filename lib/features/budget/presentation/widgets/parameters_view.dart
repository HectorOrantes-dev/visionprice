import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../recording/presentation/providers/parameters_provider.dart';
import 'budget_section_label.dart';
import 'confirm_button.dart';
import 'low_confidence_banner.dart';
import 'medida_manual_card.dart';
import 'metric_item.dart';
import 'review_app_bar.dart';
import 'review_error_view.dart';
import 'review_transcription_card.dart';
import 'warning_item.dart';

/// Contenido de la pantalla de revisión de parámetros: transcripción editable,
/// medidas detectadas + medida manual, advertencias y botón de confirmar.
class ParametersView extends ConsumerWidget {
  final int grabacionId;
  const ParametersView({super.key, required this.grabacionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(parametersProvider(grabacionId));
    final calculo = vm.calculo;
    final confianza = vm.grabacion?.confianza;
    final lowConfidence = confianza != null && confianza < 0.7;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            const ReviewAppBar(),
            if (vm.loading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            // Solo se toma la pantalla completa de error cuando NO hay grabación
            // cargada (fallo de carga inicial). Si ya hay transcripción, el error
            // de recálculo se muestra inline para poder corregir sin perderla.
            else if (vm.errorMessage != null && vm.grabacion == null)
              Expanded(child: ReviewErrorView(message: vm.errorMessage!))
            else ...[
              if (lowConfidence) LowConfidenceBanner(confianza: confianza),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (vm.grabacion?.tieneTranscripcion ?? false) ...[
                      ReviewTranscriptionCard(
                        grabacionId: grabacionId,
                        textoOriginal: vm.grabacion!.transcripcion!,
                        textoEditado: vm.textoEditado,
                        recalculando: vm.recalculando,
                        errorMessage: vm.errorMessage,
                      ),
                      const SizedBox(height: 16),
                    ],
                    const BudgetSectionLabel('MEDIDAS'),
                    const SizedBox(height: 8),
                    ..._buildMetrics(context, vm),
                    const SizedBox(height: 8),
                    MedidaManualCard(grabacionId: grabacionId),
                    ...() {
                      // Si es solo una pared (sin piso), se ocultan las
                      // advertencias sobre el "piso": no aplican aquí.
                      final soloPared =
                          calculo?.pisoM2 == null && calculo?.paredesM2 != null;
                      final avisos = (calculo?.advertencias ?? const [])
                          .where((a) =>
                              !(soloPared && a.toLowerCase().contains('piso')))
                          .toList();
                      if (avisos.isEmpty) return const <Widget>[];
                      return [
                        const SizedBox(height: 16),
                        const BudgetSectionLabel('ADVERTENCIAS'),
                        const SizedBox(height: 8),
                        ...avisos.map((a) => WarningItem(text: a)),
                      ];
                    }(),
                  ],
                ),
              ),
              ConfirmButton(
                grabacionId: vm.grabacion?.id,
                proyectoId: vm.grabacion?.proyectoId,
                pisoM2: calculo?.pisoM2,
                paredesM2: calculo?.paredesM2,
                superficies: vm.grabacion?.superficies,
                areaManualM2: vm.areaManualM2,
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMetrics(BuildContext context, ParametersState vm) {
    final superficies = vm.grabacion?.superficies;
    final c = vm.calculo;
    final widgets = <Widget>[];

    // 1. Superficies detectadas por el ML.
    if (superficies != null && superficies.isNotEmpty) {
      for (final sup in superficies) {
        widgets.add(MetricItem(
          icon: sup.tipo == 'piso'
              ? Icons.layers_outlined
              : Icons.square_outlined,
          title: sup.descripcion.isNotEmpty ? sup.descripcion : sup.tipo,
          detail: '${sup.areaM2.toStringAsFixed(2)} m²',
          highlight: true,
        ));
        widgets.add(const SizedBox(height: 8));
      }
    }

    // La superficie manual (ancho×alto) se muestra aparte, en MedidaManualCard.
    if (widgets.isNotEmpty) return widgets;

    // 2. Sin superficies del ML: se muestra el cálculo del back-end.
    if (c == null) {
      // Sin ML y sin cálculo: solo queda la medida manual (su tarjeta) → nada
      // que mostrar aquí.
      return const [];
    }
    String dim(double? v) => v != null ? '${v.toStringAsFixed(2)} m' : '—';
    String area(double? v) => v != null ? '${v.toStringAsFixed(2)} m²' : '—';

    // Sin piso (no es un cuarto): la medida la lleva la tarjeta manual, no se
    // muestran aquí Piso/Paredes/Dimensiones vacíos.
    if (c.pisoM2 == null) return const [];

    return [
      MetricItem(
        icon: Icons.layers_outlined,
        title: 'Piso',
        detail: area(c.pisoM2),
        highlight: true,
      ),
      const SizedBox(height: 8),
      MetricItem(
        icon: Icons.square_outlined,
        title: 'Paredes',
        detail: area(c.paredesM2),
        highlight: true,
      ),
      const SizedBox(height: 8),
      MetricItem(
        icon: Icons.straighten,
        title: 'Dimensiones',
        detail: '${dim(c.largoM)} × ${dim(c.anchoM)} × ${dim(c.altoM)}',
      ),
    ];
  }
}
