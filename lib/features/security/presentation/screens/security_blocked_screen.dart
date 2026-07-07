import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/theme/app_theme.dart';
import '../../security_checker.dart';
import '../../rasp_checker.dart';

/// Pantalla que bloquea el acceso a VisionPrice cuando se detecta Fake GPS
/// o faltan permisos de ubicación. Diseño en tema claro, coherente con la app.
class SecurityBlockedScreen extends StatefulWidget {
  final SecurityStatus status;
  final VoidCallback onRetrySuccess;

  const SecurityBlockedScreen({
    super.key,
    required this.status,
    required this.onRetrySuccess,
  });

  @override
  State<SecurityBlockedScreen> createState() => _SecurityBlockedScreenState();
}

class _SecurityBlockedScreenState extends State<SecurityBlockedScreen> {
  bool _isVerifying = false;

  Future<void> _handleRetry() async {
    if (_isVerifying) return;
    setState(() => _isVerifying = true);

    await Future.delayed(const Duration(milliseconds: 800));
    SecurityStatus newStatus = await SecurityChecker.checkDeviceSecurity();

    // Verify USB Debugging status if basic security passed
    if (newStatus == SecurityStatus.secure) {
      final bool usbOn = await RaspChecker.isUsbDebuggingEnabled();
      if (usbOn) {
        newStatus = SecurityStatus.usbDebuggingDetected;
      }
    }

    if (!mounted) return;
    setState(() => _isVerifying = false);

    if (newStatus == SecurityStatus.secure) {
      widget.onRetrySuccess();
    } else {
      String errorMessage = 'Permisos insuficientes para validar el dispositivo.';
      if (newStatus == SecurityStatus.fakeGpsDetected) {
        errorMessage = 'Sigue detectándose Fake GPS activo.';
      } else if (newStatus == SecurityStatus.usbDebuggingDetected) {
        errorMessage = '⚠️ La Depuración USB sigue activa.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Text(
            errorMessage,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFakeGps = widget.status == SecurityStatus.fakeGpsDetected;
    final bool isUsbDebugging = widget.status == SecurityStatus.usbDebuggingDetected;
    
    final Color accent = isFakeGps || isUsbDebugging ? AppColors.error : AppColors.warning;

    String title = 'Acceso restringido';
    String description = 'VisionPrice requiere permisos de ubicación precisos para validar la integridad del dispositivo.';
    IconData icon = Icons.gpp_maybe_rounded;

    if (isFakeGps) {
      title = '¡Fake GPS detectado!';
      description = 'Detectamos una app para simular tu ubicación. Por seguridad, no se permite el uso de Fake GPS en VisionPrice.';
      icon = Icons.location_off_rounded;
    } else if (isUsbDebugging) {
      title = 'Depuración USB activa';
      description = 'Por seguridad, VisionPrice no puede ejecutarse con la Depuración por USB activada.\n\nDesactívala en: Ajustes › Opciones de desarrollador › Depuración por USB.';
      icon = Icons.gpp_bad_rounded;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: accent,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isVerifying ? null : _handleRetry,
                      child: _isVerifying
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Verificar de nuevo'),
                    ),
                  ),
                  if (!isFakeGps && !isUsbDebugging) ...[
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => openAppSettings(),
                      child: const Text('Abrir Ajustes del Sistema'),
                    ),
                  ],
                  if (isUsbDebugging) ...[
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => RaspChecker.openDeveloperSettings(),
                      child: const Text('Abrir Opciones de Desarrollador'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
