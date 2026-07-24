import 'package:flutter/material.dart';
import '../../../../core/theme/app_palette.dart';
import '../../rasp_checker.dart';

/// Pantalla que bloquea el acceso a VisionPrice mientras la Depuración por
/// USB (ADB) esté activa en el dispositivo.
class UsbDebuggingBlockedScreen extends StatefulWidget {
  final VoidCallback onRetrySuccess;

  const UsbDebuggingBlockedScreen({super.key, required this.onRetrySuccess});

  @override
  State<UsbDebuggingBlockedScreen> createState() =>
      _UsbDebuggingBlockedScreenState();
}

class _UsbDebuggingBlockedScreenState extends State<UsbDebuggingBlockedScreen> {
  bool _isVerifying = false;

  Future<void> _handleRetry() async {
    if (_isVerifying) return;
    setState(() => _isVerifying = true);
    await Future.delayed(const Duration(milliseconds: 300));

    final stillOn = await RaspChecker.isUsbDebuggingEnabled();
    if (!mounted) return;
    setState(() => _isVerifying = false);

    if (!stillOn) {
      widget.onRetrySuccess();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: context.colors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: const Text(
          '⚠️ La Depuración USB sigue activa.',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = context.colors.error;
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: context.colors.border),
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
                    child: Icon(Icons.gpp_bad_rounded, color: accent, size: 40),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Depuración USB activa',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Por seguridad, VisionPrice no puede ejecutarse con la '
                    'Depuración por USB activada.\n\nDesactívala en: '
                    'Ajustes › Opciones de desarrollador › Depuración por USB.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.colors.textSecondary,
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
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => RaspChecker.openDeveloperSettings(),
                    child: const Text('Abrir Opciones de Desarrollador'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
