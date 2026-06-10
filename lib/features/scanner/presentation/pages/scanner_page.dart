import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

enum _ScannerMode {
  targetingBase,
  targetingTop,
  done,
}

/// ScannerPage – Medición por Triangulación de Sensores (Inclinómetro)
class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key, this.projectId});

  final String? projectId;

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _cameraError = false;

  // ─── Sensores ───
  StreamSubscription<AccelerometerEvent>? _accelSub;
  double _zFiltered = 0.0;
  double _yFiltered = 9.8;
  double _currentAngle = 0.0; // Radianes de elevación (positivo = arriba)

  // ─── Estado de medición ───
  _ScannerMode _mode = _ScannerMode.targetingBase;
  double _userHeight = 1.70; // Metros
  
  double? _angleBase;
  double? _angleTop;
  double? _distanceToTarget; // Metros
  double? _calculatedHeight; // Metros

  late AnimationController _pulseCtrl;

  double get _cameraHeight => max(0.1, _userHeight - 0.10); // Cámara ~10cm debajo de coronilla

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _requestCameraAndInit();
    _initSensors();
  }

  void _initSensors() {
    _accelSub = accelerometerEventStream().listen((event) {
      if (!mounted) return;
      
      // Filtro Low-Pass para estabilizar la lectura
      const alpha = 0.15;
      _zFiltered = alpha * event.z + (1 - alpha) * _zFiltered;
      _yFiltered = alpha * event.y + (1 - alpha) * _yFiltered;

      // Ángulo de elevación: atan2(-z, y)
      // z es negativo cuando la pantalla mira hacia arriba / cámara hacia arriba.
      final angle = atan2(-_zFiltered, _yFiltered);
      
      setState(() {
        _currentAngle = angle;

        // Calcular en tiempo real si estamos en el paso de buscar el tope
        if (_mode == _ScannerMode.targetingTop && _distanceToTarget != null) {
          _calculatedHeight = _cameraHeight + _distanceToTarget! * tan(_currentAngle);
        }
      });
    });
  }

  Future<void> _requestCameraAndInit() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      await _initCamera();
    } else {
      if (mounted) setState(() => _cameraError = true);
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _cameraError = true);
        return;
      }
      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      _cameraController =
          CameraController(backCamera, ResolutionPreset.high, enableAudio: false);
      await _cameraController!.initialize();
      if (mounted) setState(() => _isCameraInitialized = true);
    } catch (e) {
      if (mounted) setState(() => _cameraError = true);
    }
  }

  @override
  void dispose() {
    _accelSub?.cancel();
    _cameraController?.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  // ───── Acciones de Medición ─────────────────────────

  void _actionButtonPressed() {
    if (_mode == _ScannerMode.targetingBase) {
      if (_currentAngle >= -0.05) {
        // Validación: debe apuntar hacia abajo (ángulo negativo)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Apunta hacia el piso (la base del objeto) para continuar.')),
        );
        return;
      }
      setState(() {
        _angleBase = _currentAngle;
        // Distancia en el piso = h / tan(|ángulo|)
        _distanceToTarget = _cameraHeight / tan(_angleBase!.abs());
        _mode = _ScannerMode.targetingTop;
      });
    } else if (_mode == _ScannerMode.targetingTop) {
      if (_distanceToTarget == null) return;
      setState(() {
        _angleTop = _currentAngle;
        _calculatedHeight = _cameraHeight + _distanceToTarget! * tan(_angleTop!);
        _mode = _ScannerMode.done;
      });
    }
  }

  void _reset() {
    setState(() {
      _mode = _ScannerMode.targetingBase;
      _angleBase = null;
      _angleTop = null;
      _distanceToTarget = null;
      _calculatedHeight = null;
    });
  }

  void _confirm() {
    context.go('${AppRoutes.viewer3d}?projectId=${widget.projectId ?? 'demo'}');
  }

  // ───── BUILD ──────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Cámara
          Positioned.fill(child: _buildCameraLayer()),

          // Overlay Visor Central (Crosshair)
          if (_isCameraInitialized)
            const Center(child: _Crosshair()),

          // UI superior
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),
                
                // Info en tiempo real (Distancia)
                if (_distanceToTarget != null && _mode != _ScannerMode.done)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Distancia: ${_distanceToTarget!.toStringAsFixed(2)} m',
                        style: AppTypography.textTheme.bodyMedium?.copyWith(color: AppColors.accent),
                      ),
                    ),
                  ),

                const Spacer(),
                
                if (_mode == _ScannerMode.done || (_mode == _ScannerMode.targetingTop && _calculatedHeight != null)) 
                  _buildLiveMeasurement(),
                
                _buildBottomPanel(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraLayer() {
    if (!_isCameraInitialized || _cameraController == null) {
      return Center(
        child: _cameraError
            ? _ErrorView(onRetry: _requestCameraAndInit)
            : const CircularProgressIndicator(color: AppColors.primary),
      );
    }
    return CameraPreview(_cameraController!);
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          _GlassButton(
            icon: Icons.close,
            onTap: () => context.pop(),
          ),
          const Spacer(),
          _StatusPill(
            pulseCtrl: _pulseCtrl, 
            mode: _mode,
          ),
          const Spacer(),
          _GlassButton(
            icon: Icons.refresh,
            onTap: _reset,
          ),
        ],
      ),
    );
  }

  Widget _buildLiveMeasurement() {
    final m = _calculatedHeight ?? 0.0;
    final cm = m * 100;
    final bool isDone = _mode == _ScannerMode.done;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: isDone ? 0.8 : 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDone ? AppColors.primary : AppColors.primary.withValues(alpha: 0.5),
          width: isDone ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            isDone ? 'Altura Final' : 'Altura actual',
            style: AppTypography.textTheme.labelSmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            '${cm.toStringAsFixed(1)} cm',
            style: AppTypography.textTheme.displayMedium?.copyWith(
              color: isDone ? AppColors.primary : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '≈ ${m.toStringAsFixed(2)} m',
            style: AppTypography.textTheme.titleMedium
                ?.copyWith(color: Colors.white60),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.80),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: _mode == _ScannerMode.targetingBase
                ? Colors.orangeAccent.withValues(alpha: 0.4) 
                : AppColors.primary.withValues(alpha: 0.2), 
            width: 0.5),
      ),
      child: Column(
        children: [
          // Configuración de Altura
          if (_mode == _ScannerMode.targetingBase)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.white54, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Tu altura (m)',
                      style: AppTypography.textTheme.bodySmall
                          ?.copyWith(color: Colors.white60),
                    ),
                    const Spacer(),
                    Text(
                      '${_userHeight.toStringAsFixed(2)} m',
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.border,
                    thumbColor: AppColors.primary,
                    overlayColor: AppColors.primary.withValues(alpha: 0.1),
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  ),
                  child: Slider(
                    value: _userHeight,
                    min: 1.40,
                    max: 2.10,
                    divisions: 70,
                    onChanged: (v) => setState(() => _userHeight = v),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          
          // Instrucciones detalladas
          _buildInstructionRow(),
          const SizedBox(height: 14),
          
          // Botones
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push(AppRoutes.manualMode),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white24),
                    minimumSize: const Size(0, 52),
                  ),
                  icon: const Icon(Icons.calculate_outlined, size: 18),
                  label: const Text('Manual'),
                ),
              ),
              const SizedBox(width: 10),
              
              if (_mode == _ScannerMode.done)
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _confirm,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 52),
                    ),
                    icon: const Icon(Icons.check_circle_outline, size: 20),
                    label: const Text('Usar medición'),
                  ),
                )
              else
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _actionButtonPressed,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 52),
                      backgroundColor: _mode == _ScannerMode.targetingBase ? Colors.orangeAccent.shade700 : AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    icon: Icon(
                      _mode == _ScannerMode.targetingBase ? Icons.arrow_downward : Icons.arrow_upward, 
                      size: 20
                    ),
                    label: Text(
                      _mode == _ScannerMode.targetingBase ? 'Fijar Base' : 'Fijar Tope',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionRow() {
    String title;
    String subtitle;
    IconData icon;
    Color color;

    if (_mode == _ScannerMode.targetingBase) {
      icon = Icons.expand_more;
      color = Colors.orangeAccent;
      title = 'Paso 1: La Base';
      subtitle = 'Apunta la cruz al piso (base de la puerta) y presiona "Fijar Base".';
    } else if (_mode == _ScannerMode.targetingTop) {
      icon = Icons.expand_less;
      color = AppColors.primary;
      title = 'Paso 2: El Tope';
      subtitle = 'Sube el teléfono hasta la punta de la puerta y presiona "Fijar Tope".';
    } else {
      icon = Icons.done_all;
      color = AppColors.primary;
      title = 'Medición Completada';
      subtitle = 'Esta es la altura total estimada.';
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 24, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.textTheme.titleSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTypography.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────
//  Widgets auxiliares
// ─────────────────────────────────────────────────────

class _Crosshair extends StatelessWidget {
  const _Crosshair();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withValues(alpha: 0.7), width: 2),
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Center(
        child: Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

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
          border:
              Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.pulseCtrl,
    required this.mode,
  });

  final AnimationController pulseCtrl;
  final _ScannerMode mode;

  @override
  Widget build(BuildContext context) {
    final bool isDone = mode == _ScannerMode.done;
    final Color color = mode == _ScannerMode.targetingBase ? Colors.orangeAccent : AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isDone)
            AnimatedBuilder(
              animation: pulseCtrl,
              builder: (_, __) => Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: pulseCtrl.value),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          if (!isDone) const SizedBox(width: 7),
          Text(
            mode == _ScannerMode.targetingBase 
              ? 'Paso 1/2' 
              : mode == _ScannerMode.targetingTop 
                ? 'Paso 2/2' 
                : 'Finalizado',
            style: AppTypography.textTheme.labelSmall?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.no_photography_outlined,
              color: Colors.white54, size: 48),
          const SizedBox(height: 16),
          const Text(
            'No se pudo acceder a la cámara.\nVerifica los permisos.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
