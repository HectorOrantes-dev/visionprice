import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Fase 4: Visor 3D — renderizado de malla con etiquetas flotantes
/// Permite rotar, zoom y muestra etiquetas de medidas
class Viewer3dPage extends StatefulWidget {
  const Viewer3dPage({super.key, required this.projectId});

  final String projectId;

  @override
  State<Viewer3dPage> createState() => _Viewer3dPageState();
}

class _Viewer3dPageState extends State<Viewer3dPage>
    with TickerProviderStateMixin {
  double _rotationX = 0;
  double _rotationY = 0;
  double _scale = 1.0;
  double _baseScale = 1.0;
  bool _showLabels = true;

  late AnimationController _floatCtrl;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Stack(
        children: [
          // ─── Vista 3D Simulada ───
          GestureDetector(
            onScaleStart: (details) {
              _baseScale = _scale;
            },
            onScaleUpdate: (details) {
              setState(() {
                _rotationY += details.focalPointDelta.dx * 0.3;
                _rotationX += details.focalPointDelta.dy * 0.3;
                _scale = (_baseScale * details.scale).clamp(0.5, 3.0);
              });
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xFF080D10),
              child: Center(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    // ignore: deprecated_member_use
                    ..scale(_scale)
                    ..rotateX(_rotationX * 0.017453)
                    ..rotateY(_rotationY * 0.017453),
                  child: _Mesh3DWidget(
                    floatAnimation: _floatCtrl,
                    showLabels: _showLabels,
                  ),
                ),
              ),
            ),
          ),

          // ─── TopBar ───
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  _GlassButton(
                    icon: Icons.arrow_back_ios_new,
                    onTap: () => context.pop(),
                  ),
                  const Spacer(),
                  Text(
                    'Vista 3D',
                    style: AppTypography.textTheme.titleLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  const Spacer(),
                  _GlassButton(
                    icon: _showLabels
                        ? Icons.label
                        : Icons.label_outline,
                    onTap: () => setState(() => _showLabels = !_showLabels),
                  ),
                ],
              ),
            ),
          ),

          // ─── Instrucciones ───
          Positioned(
            bottom: 160,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Arrastra para rotar • Pellizca para zoom',
                  style: AppTypography.textTheme.bodySmall
                      ?.copyWith(color: Colors.white54),
                ),
              ),
            ),
          ),

          // ─── Bottom CTA ───
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton.icon(
                  onPressed: () => context.go(
                      '${AppRoutes.materials}?projectId=${widget.projectId}'),
                  icon: const Icon(Icons.inventory_2_outlined, size: 20),
                  label: const Text('Ver Materiales Calculados'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Representación visual simplificada de la malla 3D con CustomPaint
class _Mesh3DWidget extends StatelessWidget {
  const _Mesh3DWidget({
    required this.floatAnimation,
    required this.showLabels,
  });

  final Animation<double> floatAnimation;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: floatAnimation,
      builder: (context, _) {
        final offset = floatAnimation.value * 6;
        return Transform.translate(
          offset: Offset(0, -offset),
          child: SizedBox(
            width: 280,
            height: 280,
            child: Stack(
              children: [
                CustomPaint(
                  size: const Size(280, 280),
                  painter: _MeshPainter(),
                ),
                // Etiquetas flotantes de medidas
                if (showLabels) ...[
                  // Etiqueta: ancho
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: _MeasureLabel(label: 'Ancho: 4.20 m'),
                    ),
                  ),
                  // Etiqueta: alto
                  Positioned(
                    top: 100,
                    right: 0,
                    child: _MeasureLabel(label: 'Alto: 2.80 m'),
                  ),
                  // Etiqueta: área neta
                  Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: _MeasureLabel(
                        label: 'Área neta: 18.5 m²',
                        isHighlighted: true,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

/// CustomPainter para dibujar la malla 3D isométrica
class _MeshPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final meshPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.6)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Cara superior (isométrica)
    final top = Path()
      ..moveTo(cx, cy - 80)
      ..lineTo(cx + 100, cy - 30)
      ..lineTo(cx, cy + 20)
      ..lineTo(cx - 100, cy - 30)
      ..close();

    // Cara izquierda
    final left = Path()
      ..moveTo(cx - 100, cy - 30)
      ..lineTo(cx, cy + 20)
      ..lineTo(cx, cy + 120)
      ..lineTo(cx - 100, cy + 70)
      ..close();

    // Cara derecha
    final right = Path()
      ..moveTo(cx, cy + 20)
      ..lineTo(cx + 100, cy - 30)
      ..lineTo(cx + 100, cy + 70)
      ..lineTo(cx, cy + 120)
      ..close();

    final rightFillPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    canvas.drawPath(top, fillPaint);
    canvas.drawPath(left, fillPaint);
    canvas.drawPath(right, rightFillPaint);

    canvas.drawPath(top, meshPaint);
    canvas.drawPath(left, meshPaint);
    canvas.drawPath(right, meshPaint);

    // Grid interior cara superior
    final gridPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.2)
      ..strokeWidth = 0.5;

    for (int i = 1; i < 4; i++) {
      final t = i / 4;
      canvas.drawLine(
        Offset(cx - 100 + 200 * t, cy - 30 - 50 * (1 - t) + 50 * t - 50 + 50 * t),
        Offset(cx - 100 + 200 * t, cy - 30 + 50 * t),
        gridPaint,
      );
    }

    // Esquinas con puntos
    final dotPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    for (final pt in [
      Offset(cx, cy - 80),
      Offset(cx + 100, cy - 30),
      Offset(cx - 100, cy - 30),
      Offset(cx, cy + 20),
      Offset(cx, cy + 120),
      Offset(cx + 100, cy + 70),
      Offset(cx - 100, cy + 70),
    ]) {
      canvas.drawCircle(pt, 3.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Etiqueta flotante de medida
class _MeasureLabel extends StatelessWidget {
  const _MeasureLabel({required this.label, this.isHighlighted = false});

  final String label;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppColors.primary.withOpacity(0.2)
            : Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHighlighted
              ? AppColors.primary.withOpacity(0.6)
              : Colors.white24,
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.textTheme.labelMedium?.copyWith(
          color: isHighlighted ? AppColors.primary : Colors.white,
          fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }
}

/// Botón de vidrio para el overlay
class _GlassButton extends StatelessWidget {
  const _GlassButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12, width: 0.5),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
