import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../recording/domain/entities/superficie_entity.dart';
import '../../../recording/presentation/providers/parameters_provider.dart';
import 'nearby_stores_screen.dart';
import 'superficies_detectadas_screen.dart';
class ParametersReviewScreen extends StatelessWidget {
  final int grabacionId;
  const ParametersReviewScreen({super.key, required this.grabacionId});

  @override
  Widget build(BuildContext context) {
    return _ParametersView(grabacionId: grabacionId);
  }
}

class _ParametersView extends ConsumerWidget {
  final int grabacionId;
  const _ParametersView({required this.grabacionId});

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
            _ReviewAppBar(),
            if (vm.loading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            // Solo se toma la pantalla completa de error cuando NO hay grabación
            // cargada (fallo de carga inicial). Si ya hay transcripción, el error
            // de recálculo se muestra inline para poder corregir sin perderla.
            else if (vm.errorMessage != null && vm.grabacion == null)
              Expanded(child: _ErrorView(message: vm.errorMessage!))
            else ...[
              if (lowConfidence) _LowConfidenceBanner(confianza: confianza),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (vm.grabacion?.tieneTranscripcion ?? false) ...[
                      _TranscriptionCard(
                        grabacionId: grabacionId,
                        textoOriginal: vm.grabacion!.transcripcion!,
                        textoEditado: vm.textoEditado,
                        requiereAltura: vm.requiereAltura,
                        recalculando: vm.recalculando,
                        errorMessage: vm.errorMessage,
                      ),
                      const SizedBox(height: 16),
                    ],
                    _SectionLabel('MEDIDAS DETECTADAS'),
                    const SizedBox(height: 8),
                    ..._buildMetrics(context, vm),
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
                superficies: vm.grabacion?.superficies,
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

    if (superficies != null && superficies.isNotEmpty) {
      return superficies.map((sup) {
        return Column(
          children: [
            _MetricItem(
              icon: sup.tipo == 'piso' ? Icons.layers_outlined : Icons.square_outlined,
              title: sup.descripcion.isNotEmpty ? sup.descripcion : sup.tipo,
              detail: '${sup.areaM2.toStringAsFixed(2)} m²',
              highlight: true,
            ),
            const SizedBox(height: 8),
          ],
        );
      }).toList();
    }

    if (c == null) {
      return [
        Text('Sin medidas calculadas',
            style: TextStyle(color: context.colors.textSecondary)),
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
            child: Icon(Icons.edit_note,
                color: context.colors.primary, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Esto es lo que dijiste?',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
              Text(
                'Revisa antes de calcular',
                style: TextStyle(
                  fontSize: 12,
                  color: context.colors.textSecondary,
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
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: context.colors.textSecondary,
        letterSpacing: 1.0,
      ),
    );
  }
}

class _TranscriptionCard extends ConsumerStatefulWidget {
  final int grabacionId;
  final String textoOriginal;
  final String? textoEditado;
  final bool requiereAltura;
  final bool recalculando;
  final String? errorMessage;

  const _TranscriptionCard({
    required this.grabacionId,
    required this.textoOriginal,
    this.textoEditado,
    this.requiereAltura = false,
    this.recalculando = false,
    this.errorMessage,
  });

  @override
  ConsumerState<_TranscriptionCard> createState() => _TranscriptionCardState();
}

class _TranscriptionCardState extends ConsumerState<_TranscriptionCard> {
  late TextEditingController _controller;
  final _alturaController = TextEditingController();
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
    _alturaController.dispose();
    super.dispose();
  }

  void _recalcular() {
    FocusScope.of(context).unfocus();
    final alturaTxt = _alturaController.text.trim().replaceAll(',', '.');
    final altura = alturaTxt.isEmpty ? null : double.tryParse(alturaTxt);
    ref
        .read(parametersProvider(widget.grabacionId).notifier)
        .recalcular(_controller.text, altura: altura);
  }

  @override
  Widget build(BuildContext context) {
    // El botón aparece si el usuario editó el texto o si el back-end pidió la
    // altura (para poder reintentar tras capturarla).
    final mostrarBoton = _showRecalcular || widget.requiereAltura;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel('LO QUE DIJISTE (toca para editar)'),
          const SizedBox(height: 10),
          TextField(
            controller: _controller,
            maxLines: null,
            style: TextStyle(
              fontSize: 14,
              color: context.colors.textPrimary,
              height: 1.6,
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
          ),
          if (widget.errorMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: context.colors.errorLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, size: 16, color: context.colors.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.errorMessage!,
                      style: TextStyle(fontSize: 12, color: context.colors.error),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (widget.requiereAltura) ...[
            const SizedBox(height: 12),
            _SectionLabel('ALTURA DE LA PARED (m)'),
            const SizedBox(height: 8),
            TextField(
              controller: _alturaController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              onSubmitted: (_) => _recalcular(),
              style: TextStyle(
                  color: context.colors.textPrimary, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: 'Ej. 2.5',
                suffixText: 'm',
                isDense: true,
                filled: true,
                fillColor: context.colors.background,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.colors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.colors.border),
                ),
              ),
            ),
          ],
          if (mostrarBoton) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: widget.recalculando ? null : _recalcular,
                icon: widget.recalculando
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh, size: 18),
                label: Text(widget.recalculando ? 'Recalculando…' : 'Recalcular'),
                style: TextButton.styleFrom(
                  foregroundColor: context.colors.primary,
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
        color: context.colors.warningLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.colors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_outlined,
              size: 16, color: context.colors.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Confianza $pct — revisa las cantidades antes de continuar',
              style: TextStyle(
                color: context.colors.warning,
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
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.colors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: context.colors.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
          ),
          Text(
            detail,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: highlight ? context.colors.primary : context.colors.textPrimary,
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
          Icon(Icons.info_outline, size: 16, color: context.colors.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: context.colors.textSecondary),
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
            Icon(Icons.error_outline, color: context.colors.error, size: 40),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmButton extends ConsumerWidget {
  final int? grabacionId;
  final int? proyectoId;
  final double? pisoM2;
  final double? paredesM2;
  final List<SuperficieEntity>? superficies;
  const _ConfirmButton({
    required this.grabacionId,
    required this.proyectoId,
    required this.pisoM2,
    required this.paredesM2,
    this.superficies,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Necesitamos el proyecto (obligatorio para crear la cotización) y al menos
    // una superficie calculada.
    final hasNewFormat = superficies != null && superficies!.isNotEmpty;
    final hasLegacyFormat = pisoM2 != null || paredesM2 != null;
    final enabled = proyectoId != null && (hasNewFormat || hasLegacyFormat);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: enabled
              ? () async {
                  final id = grabacionId;
                  if (id != null) {
                    await ref
                        .read(parametersProvider(id).notifier)
                        .guardarEdicion(id);
                  }
                  if (context.mounted) {
                    // Con superficies detectadas por el ML: flujo nuevo,
                    // secuencial por superficie (simple o kit). Sin ellas
                    // (formato legacy plano piso_m2/paredes_m2): se mantiene
                    // el flujo anterior de ferreterías cercanas.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => hasNewFormat
                            ? SuperficiesDetectadasScreen(
                                proyectoId: proyectoId!,
                                superficies: superficies!,
                              )
                            : NearbyStoresScreen(
                                proyectoId: proyectoId!,
                                pisoM2: pisoM2,
                                paredesM2: paredesM2,
                                superficies: superficies,
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
