import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

const _mensajes = [
  'Buscando la mejor decisión para ti…',
  'Comparando con obras similares en tu zona…',
  'Analizando precios y proveedores cercanos…',
  'Casi listo…',
];

/// Reemplaza al spinner plano mientras se pide la recomendación
/// (`POST /recomendaciones/kit`): un ícono con pulso suave + mensajes que
/// rotan cada pocos segundos, para que la espera se sienta con propósito en
/// vez de "colgada".
class BuscandoRecomendacionCard extends StatefulWidget {
  const BuscandoRecomendacionCard({super.key});

  @override
  State<BuscandoRecomendacionCard> createState() =>
      _BuscandoRecomendacionCardState();
}

class _BuscandoRecomendacionCardState extends State<BuscandoRecomendacionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulso;
  Timer? _timer;
  int _mensajeIndex = 0;

  @override
  void initState() {
    super.initState();
    _pulso = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    // Los primeros mensajes son más cortos (transmiten avance rápido); el
    // último se queda fijo si la petición tarda más de lo esperado.
    _timer = Timer.periodic(const Duration(milliseconds: 1600), (_) {
      if (_mensajeIndex < _mensajes.length - 1) {
        setState(() => _mensajeIndex++);
      }
    });
  }

  @override
  void dispose() {
    _pulso.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.primaryLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          ScaleTransition(
            scale: Tween(begin: 0.85, end: 1.15).animate(
              CurvedAnimation(parent: _pulso, curve: Curves.easeInOut),
            ),
            child: Icon(Icons.auto_awesome, size: 22, color: c.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _mensajes[_mensajeIndex],
                key: ValueKey(_mensajeIndex),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: c.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
