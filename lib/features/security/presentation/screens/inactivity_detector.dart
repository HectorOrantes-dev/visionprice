import 'dart:async';

import 'package:flutter/material.dart';
import '../widgets/countdown_dialog.dart';

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
    this.inactivityDuration = const Duration(minutes: 15),
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
      builder: (_) => CountdownDialog(seconds: widget.countdownSeconds),
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
