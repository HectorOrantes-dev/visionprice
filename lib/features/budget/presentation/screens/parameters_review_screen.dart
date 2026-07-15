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
                        recalculando: vm.recalculando,
                        errorMessage: vm.errorMessage,
                      ),
                      const SizedBox(height: 16),
                    ],
                    _SectionLabel('MEDIDAS'),
                    const SizedBox(height: 8),
                    ..._buildMetrics(context, vm),
                    const SizedBox(height: 8),
                    _MedidaManualCard(grabacionId: grabacionId),
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
                        _SectionLabel('ADVERTENCIAS'),
                        const SizedBox(height: 8),
                        ...avisos.map((a) => _WarningItem(text: a)),
                      ];
                    }(),
                  ],
                ),
              ),
              _ConfirmButton(
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
        widgets.add(_MetricItem(
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

    // La superficie manual (ancho×alto) se muestra aparte, en _MedidaManualCard.
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
  final bool recalculando;
  final String? errorMessage;

  const _TranscriptionCard({
    required this.grabacionId,
    required this.textoOriginal,
    this.textoEditado,
    this.recalculando = false,
    this.errorMessage,
  });

  @override
  ConsumerState<_TranscriptionCard> createState() => _TranscriptionCardState();
}

class _TranscriptionCardState extends ConsumerState<_TranscriptionCard> {
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

  void _recalcular() {
    FocusScope.of(context).unfocus();
    ref
        .read(parametersProvider(widget.grabacionId).notifier)
        .recalcular(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
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
          if (_showRecalcular) ...[
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

/// Tarjeta de superficie MANUAL en MEDIDAS: una tarjeta unificada que "espera la
/// info necesaria" (ancho×alto). Colapsada muestra "+ Agregar medida a mano";
/// abierta pide las medidas y calcula el área (`paredes_m2`). Se auto-abre si el
/// back-end pidió medidas o si ya hay un área capturada.
class _MedidaManualCard extends ConsumerStatefulWidget {
  final int grabacionId;
  const _MedidaManualCard({required this.grabacionId});

  @override
  ConsumerState<_MedidaManualCard> createState() => _MedidaManualCardState();
}

class _MedidaManualCardState extends ConsumerState<_MedidaManualCard> {
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
        border: Border.all(color: context.colors.primary.withValues(alpha: 0.4)),
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
                child: _NumField(
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
                child: _NumField(
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
              _AccionBtn(
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

/// Botón de acción a la derecha (Recalcular / Calcular pared) con spinner.
class _AccionBtn extends StatelessWidget {
  final bool loading;
  final String labelIdle;
  final String labelBusy;
  final IconData icon;
  final VoidCallback onPressed;
  const _AccionBtn({
    required this.loading,
    required this.labelIdle,
    required this.labelBusy,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: loading ? null : onPressed,
        icon: loading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(icon, size: 18),
        label: Text(loading ? labelBusy : labelIdle),
        style: TextButton.styleFrom(
          foregroundColor: context.colors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}

/// Campo numérico compacto (decimal) reutilizado para altura y medidas de pared.
class _NumField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final VoidCallback onSubmit;
  const _NumField({
    required this.controller,
    required this.hint,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
      ],
      onSubmitted: (_) => onSubmit(),
      style: TextStyle(
          color: context.colors.textPrimary, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hint,
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
  final double? areaManualM2;
  const _ConfirmButton({
    required this.grabacionId,
    required this.proyectoId,
    required this.pisoM2,
    required this.paredesM2,
    this.superficies,
    this.areaManualM2,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Se cotizan LOS DOS: las superficies del ML + la pared calculada a mano
    // (como una superficie de pintura extra), así ninguna se pierde.
    final superficiesCombinadas = <SuperficieEntity>[
      ...?superficies,
      if (areaManualM2 != null && areaManualM2! > 0)
        SuperficieEntity(
          tipo: 'pared',
          descripcion: 'Pared (medida a mano)',
          areaM2: areaManualM2!,
          categoria: 'pintura',
        ),
    ];
    // Necesitamos el proyecto (obligatorio para crear la cotización) y al menos
    // una superficie calculada.
    final hasNewFormat = superficiesCombinadas.isNotEmpty;
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
                                superficies: superficiesCombinadas,
                              )
                            : NearbyStoresScreen(
                                proyectoId: proyectoId!,
                                pisoM2: pisoM2,
                                paredesM2: paredesM2,
                                superficies: superficiesCombinadas,
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
