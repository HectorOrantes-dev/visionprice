import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../recording/domain/entities/calculo_entity.dart';
import '../../../recording/presentation/providers/parameters_provider.dart';
import '../widgets/budget_section_label.dart';
import '../widgets/confirm_button.dart';
import '../widgets/low_confidence_banner.dart';
import '../widgets/metric_item.dart';
import '../widgets/review_app_bar.dart';
import '../widgets/review_error_view.dart';
import '../widgets/review_transcription_card.dart';
import '../widgets/warning_item.dart';

class ParametersReviewScreen extends StatelessWidget {
  final int grabacionId;
  const ParametersReviewScreen({super.key, required this.grabacionId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<ParametersViewModel>()..load(grabacionId),
      child: Consumer<ParametersViewModel>(
        builder: (context, vm, _) {
          final calculo = vm.calculo;
          final confianza = vm.grabacion?.confianza;
          final lowConfidence = confianza != null && confianza < 0.7;

          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
                children: [
                  const ReviewAppBar(),
                  if (vm.loading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (vm.errorMessage != null)
                    Expanded(child: ReviewErrorView(message: vm.errorMessage!))
                  else ...[
                    if (lowConfidence)
                      LowConfidenceBanner(confianza: confianza),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          if (vm.grabacion?.tieneTranscripcion ?? false) ...[
                            ReviewTranscriptionCard(
                                texto: vm.grabacion!.transcripcion!),
                            const SizedBox(height: 16),
                          ],
                          const BudgetSectionLabel('MEDIDAS DETECTADAS'),
                          const SizedBox(height: 8),
                          ..._buildMetrics(calculo),
                          if ((calculo?.advertencias ?? const []).isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const BudgetSectionLabel('ADVERTENCIAS'),
                            const SizedBox(height: 8),
                            ...calculo!.advertencias
                                .map((a) => WarningItem(text: a)),
                          ],
                        ],
                      ),
                    ),
                    ConfirmButton(
                      proyectoId: vm.grabacion?.proyectoId,
                      pisoM2: calculo?.pisoM2,
                      paredesM2: calculo?.paredesM2,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildMetrics(CalculoEntity? c) {
    if (c == null) {
      return [
        const Text('Sin medidas calculadas',
            style: TextStyle(color: AppColors.textSecondary)),
      ];
    }
    String dim(double? v) => v != null ? '${v.toStringAsFixed(2)} m' : '—';
    String area(double? v) => v != null ? '${v.toStringAsFixed(2)} m²' : '—';
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
