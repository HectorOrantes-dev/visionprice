import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../recording/domain/entities/calculo_entity.dart';
import '../../../recording/presentation/providers/parameters_provider.dart';
import 'nearby_stores_screen.dart';

class ParametersReviewScreen extends StatelessWidget {
  final int grabacionId;
  const ParametersReviewScreen({super.key, required this.grabacionId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<ParametersViewModel>()..load(grabacionId),
      child: const _ParametersView(),
    );
  }
}

class _ParametersView extends StatelessWidget {
  const _ParametersView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ParametersViewModel>();
    final calculo = vm.calculo;
    final confianza = vm.grabacion?.confianza;
    final lowConfidence = confianza != null && confianza < 0.7;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _ReviewAppBar(),
            if (vm.loading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (vm.errorMessage != null)
              Expanded(child: _ErrorView(message: vm.errorMessage!))
            else ...[
              if (lowConfidence) _LowConfidenceBanner(confianza: confianza),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (vm.grabacion?.tieneTranscripcion ?? false) ...[
                      _TranscriptionCard(
                        textoOriginal: vm.grabacion!.transcripcion!,
                        textoEditado: vm.textoEditado,
                      ),
                      const SizedBox(height: 16),
                    ],
                    _SectionLabel('MEDIDAS DETECTADAS'),
                    const SizedBox(height: 8),
                    ..._buildMetrics(calculo),
                    if ((calculo?.advertencias ?? const []).isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _SectionLabel('ADVERTENCIAS'),
                      const SizedBox(height: 8),
                      ...calculo!.advertencias.map((a) => _WarningItem(text: a)),
                    ],
                  ],
                ),
              ),
              _ConfirmButton(
                grabacionId: vm.grabacion?.id,
                proyectoId: vm.grabacion?.proyectoId,
                pisoM2: calculo?.pisoM2,
                paredesM2: calculo?.paredesM2,
              ),
            ],
          ],
        ),
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
      _MetricItem(
        icon: Icons.layers_outlined,
        title: 'Piso',
        detail: area(c.pisoM2),
        highlight: true,
      ),
      const SizedBox(height: 8),
      _MetricItem(
        icon: Icons.square_outlined,
        title: 'Paredes',
        detail: area(c.paredesM2),
        highlight: true,
      ),
      const SizedBox(height: 8),
      _MetricItem(
        icon: Icons.straighten,
        title: 'Dimensiones',
        detail: '${dim(c.largoM)} × ${dim(c.anchoM)} × ${dim(c.altoM)}',
      ),
    ];
  }
}

class _ReviewAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                size: 18, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.edit_note,
                color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Esto es lo que dijiste?',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Revisa antes de calcular',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
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
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 1.0,
      ),
    );
  }
}

class _TranscriptionCard extends StatefulWidget {
  final String textoOriginal;
  final String? textoEditado;

  const _TranscriptionCard({
    required this.textoOriginal,
    this.textoEditado,
  });

  @override
  State<_TranscriptionCard> createState() => _TranscriptionCardState();
}

class _TranscriptionCardState extends State<_TranscriptionCard> {
  late TextEditingController _controller;
  bool _showRecalcular = false;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: widget.textoEditado ?? widget.textoOriginal);
    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant _TranscriptionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newText = widget.textoEditado ?? widget.textoOriginal;
    if (newText != (oldWidget.textoEditado ?? oldWidget.textoOriginal)) {
      if (_controller.text != newText) {
        _controller.text = newText;
      }
    }
  }

  void _onTextChanged() {
    final currentText = widget.textoEditado ?? widget.textoOriginal;
    final changed = _controller.text.trim() != currentText.trim();
    if (_showRecalcular != changed) {
      setState(() {
        _showRecalcular = changed;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel('LO QUE DIJISTE (toca para editar)'),
          const SizedBox(height: 10),
          TextField(
            controller: _controller,
            maxLines: null,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.6,
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
          ),
          if (_showRecalcular) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  context
                      .read<ParametersViewModel>()
                      .recalcular(_controller.text);
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Recalcular'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LowConfidenceBanner extends StatelessWidget {
  final double? confianza;
  const _LowConfidenceBanner({this.confianza});

  @override
  Widget build(BuildContext context) {
    final pct = confianza != null ? '${(confianza! * 100).round()}%' : '';
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_outlined,
              size: 16, color: AppColors.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Confianza $pct — revisa las cantidades antes de continuar',
              style: const TextStyle(
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;
  final bool highlight;

  const _MetricItem({
    required this.icon,
    required this.title,
    required this.detail,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            detail,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: highlight ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningItem extends StatelessWidget {
  final String text;
  const _WarningItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 16, color: AppColors.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 40),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  final int? grabacionId;
  final int? proyectoId;
  final double? pisoM2;
  final double? paredesM2;
  const _ConfirmButton({
    required this.grabacionId,
    required this.proyectoId,
    required this.pisoM2,
    required this.paredesM2,
  });

  @override
  Widget build(BuildContext context) {
    // Necesitamos el proyecto (obligatorio para crear la cotización) y al menos
    // una superficie calculada.
    final enabled = proyectoId != null && (pisoM2 != null || paredesM2 != null);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: enabled
              ? () async {
                  final vm = context.read<ParametersViewModel>();
                  if (grabacionId != null) {
                    await vm.guardarEdicion(grabacionId!);
                  }
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NearbyStoresScreen(
                          proyectoId: proyectoId!,
                          pisoM2: pisoM2,
                          paredesM2: paredesM2,
                        ),
                      ),
                    );
                  }
                }
              : null,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_forward, size: 18),
              SizedBox(width: 8),
              Text('Confirmar y calcular materiales'),
            ],
          ),
        ),
      ),
    );
  }
}
