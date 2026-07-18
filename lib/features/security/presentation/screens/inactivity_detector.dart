import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Envuelve la parte autenticada de la app y detecta la inactividad del usuario.
///
/// 1. Cada interacción (toque/arrastre) reinicia el temporizador de inactividad.
/// 2. Tras [inactivityDuration] sin actividad, abre un diálogo con cuenta
///    regresiva de [countdownSeconds] segundos.
/// 3. "Seguir conectado" continúa la sesión; si la cuenta llega a 0 se invoca
///    [onTimeout] (cerrar sesión).
class InactivityDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback onTimeout;
  final Duration inactivityDuration;
  final int countdownSeconds;

  const InactivityDetector({
    super.key,
    required this.child,
    required this.onTimeout,
    this.inactivityDuration = const Duration(minutes: 2),
    this.countdownSeconds = 30,
  });

  @override
  State<InactivityDetector> createState() => _InactivityDetectorState();
}

class _InactivityDetectorState extends State<InactivityDetector> {
  Timer? _inactivityTimer;
  bool _dialogOpen = false;

  @override
  void initState() {
    super.initState();
    _restartInactivityTimer();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  void _restartInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(widget.inactivityDuration, _onInactive);
  }

  void _handleUserInteraction([_]) {
    if (_dialogOpen) return;
    _restartInactivityTimer();
  }

  Future<void> _onInactive() async {
    if (_dialogOpen || !mounted) return;
    _dialogOpen = true;

    final bool? continued = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _CountdownDialog(seconds: widget.countdownSeconds),
    );

    _dialogOpen = false;
    if (!mounted) return;

    if (continued == true) {
      _restartInactivityTimer();
    } else {
      widget.onTimeout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _handleUserInteraction,
      onPointerMove: _handleUserInteraction,
      child: widget.child,
    );
  }
}

/// Diálogo modal con cuenta regresiva (tema claro).
class _CountdownDialog extends StatefulWidget {
  final int seconds;

  const _CountdownDialog({required this.seconds});

  @override
  State<_CountdownDialog> createState() => _CountdownDialogState();
}

class _CountdownDialogState extends State<_CountdownDialog> {
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
        progress > 0.33 ? AppColors.primary : AppColors.error;

    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Row(
        children: [
          Icon(Icons.timer_outlined, color: AppColors.primary),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              '¿Sigues ahí?',
              style: TextStyle(
                color: AppColors.textPrimary,
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
          const Text(
            'Tu sesión se cerrará por inactividad en:',
            style: TextStyle(color: AppColors.textSecondary, height: 1.4),
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
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(ringColor),
                  ),
                ),
                Text(
                  '$_remaining',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
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
