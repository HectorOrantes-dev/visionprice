import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../recording/presentation/providers/parameters_provider.dart';
import 'budget_section_label.dart';

/// Tarjeta con la transcripción editable + botón "Recalcular" que dispara el
/// recálculo de m² sobre el texto corregido.
class ReviewTranscriptionCard extends ConsumerStatefulWidget {
  final int grabacionId;
  final String textoOriginal;
  final String? textoEditado;
  final bool recalculando;
  final String? errorMessage;

  const ReviewTranscriptionCard({
    super.key,
    required this.grabacionId,
    required this.textoOriginal,
    this.textoEditado,
    this.recalculando = false,
    this.errorMessage,
  });

  @override
  ConsumerState<ReviewTranscriptionCard> createState() =>
      _ReviewTranscriptionCardState();
}

class _ReviewTranscriptionCardState
    extends ConsumerState<ReviewTranscriptionCard> {
  late TextEditingController _controller;
  bool _showRecalcular = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.textoEditado ?? widget.textoOriginal);
    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant ReviewTranscriptionCard oldWidget) {
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
          const BudgetSectionLabel('LO QUE DIJISTE (toca para editar)'),
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
                  Icon(Icons.error_outline,
                      size: 16, color: context.colors.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.errorMessage!,
                      style:
                          TextStyle(fontSize: 12, color: context.colors.error),
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
                label:
                    Text(widget.recalculando ? 'Recalculando…' : 'Recalcular'),
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
