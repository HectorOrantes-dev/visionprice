import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import 'processing_section_label.dart';

/// Tarjeta con la transcripción del audio (o su carga). Antes `_TranscriptionCard`.
class TranscriptionCard extends StatefulWidget {
  final String? transcripcion;
  final bool loading;
  const TranscriptionCard({
    super.key,
    this.transcripcion,
    required this.loading,
  });

  @override
  State<TranscriptionCard> createState() => _TranscriptionCardState();
}

class _TranscriptionCardState extends State<TranscriptionCard> {
  Timer? _timer;
  int _progress = 10;

  @override
  void initState() {
    super.initState();
    if (widget.loading) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(TranscriptionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.loading && !oldWidget.loading) {
      _startTimer();
    } else if (!widget.loading && oldWidget.loading) {
      _timer?.cancel();
    }
  }

  void _startTimer() {
    _progress = 10;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (!mounted) return;
      setState(() {
        if (_progress < 95) {
          _progress += 10; // Aumenta 10% cada 1.5s
          if (_progress > 95) _progress = 95;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
          const ProcessingSectionLabel('TRANSCRIPCIÓN DEL AUDIO'),
          const SizedBox(height: 12),
          if (widget.loading)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transcribiendo...',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    Text(
                      '$_progress%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.colors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _progress / 100,
                    backgroundColor: context.colors.border,
                    color: context.colors.primary,
                    minHeight: 8,
                  ),
                ),
              ],
            )
          else
            Text(
              widget.transcripcion == null || widget.transcripcion!.isEmpty
                  ? 'Sin transcripción'
                  : '"${widget.transcripcion}"',
              style: TextStyle(
                fontSize: 14,
                color: context.colors.textPrimary,
                height: 1.6,
              ),
            ),
        ],
      ),
    );
  }
}
