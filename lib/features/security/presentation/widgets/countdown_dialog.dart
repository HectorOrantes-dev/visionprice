import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../core/theme/app_palette.dart';

/// Diálogo modal con cuenta regresiva (tema claro). Devuelve `true` si el
/// usuario elige "Seguir conectado"; `false` al agotarse el tiempo.
/// Antes el privado `_CountdownDialog` de `inactivity_detector.dart`.
class CountdownDialog extends StatefulWidget {
  final int seconds;

  const CountdownDialog({super.key, required this.seconds});

  @override
  State<CountdownDialog> createState() => _CountdownDialogState();
}

class _CountdownDialogState extends State<CountdownDialog> {
  late int _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remaining <= 1) {
        timer.cancel();
        Navigator.of(context).pop(false);
      } else {
        setState(() => _remaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = _remaining / widget.seconds;
    final Color ringColor =
        progress > 0.33 ? context.colors.primary : context.colors.error;

    return AlertDialog(
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Row(
        children: [
          Icon(Icons.timer_outlined, color: context.colors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '¿Sigues ahí?',
              style: TextStyle(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Tu sesión se cerrará por inactividad en:',
            style: TextStyle(color: context.colors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 96,
            height: 96,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 96,
                  height: 96,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 6,
                    backgroundColor: context.colors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(ringColor),
                  ),
                ),
                Text(
                  '$_remaining',
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Seguir conectado'),
          ),
        ),
      ],
    );
  }
}
