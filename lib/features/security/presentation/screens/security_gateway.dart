import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../rasp_checker.dart';
import '../../security_checker.dart';
import 'security_blocked_screen.dart';

/// Puerta de seguridad que envuelve la app. Antes de mostrar el [child]:
/// - RASP: si la Depuración USB está activa, muestra un diálogo bloqueante.
/// - Anti Fake-GPS: si detecta ubicación simulada o faltan permisos, muestra
///   la pantalla de bloqueo.
/// Revalida cada vez que la app vuelve a primer plano.
class SecurityGateway extends StatefulWidget {
  final Widget child;

  const SecurityGateway({super.key, required this.child});

  @override
  State<SecurityGateway> createState() => _SecurityGatewayState();
}

class _SecurityGatewayState extends State<SecurityGateway>
    with WidgetsBindingObserver {
  SecurityStatus? _securityStatus;
  bool _isLoading = true;
  bool _isRaspDialogShowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _runRaspCheck());
    _runSecurityCheck();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _runRaspCheck();
      _runSecurityCheck(showLoading: false);
    }
  }

  Future<void> _runRaspCheck() async {
    final bool usbOn = await RaspChecker.isUsbDebuggingEnabled();
    if (!mounted) return;

    if (usbOn) {
      if (!_isRaspDialogShowing) {
        _isRaspDialogShowing = true;
        _showRaspBlockDialog();
      }
    } else if (_isRaspDialogShowing) {
      Navigator.of(context, rootNavigator: true).pop();
      _isRaspDialogShowing = false;
    }
  }

  void _showRaspBlockDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        bool stillActive = false;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return PopScope(
              canPop: false,
              child: AlertDialog(
                backgroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                icon: const Icon(Icons.gpp_bad_rounded,
                    color: AppColors.error, size: 44),
                title: const Text(
                  'Depuración USB activa',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Por seguridad, VisionPrice no puede ejecutarse con la '
                      'Depuración por USB activada.\n\n'
                      'Desactívala en: Ajustes › Opciones de desarrollador › '
                      'Depuración por USB.',
                      style: TextStyle(
                          color: AppColors.textSecondary, height: 1.4),
                    ),
                    if (stillActive) ...[
                      const SizedBox(height: 12),
                      const Text(
                        '⚠️ La Depuración USB sigue activa.',
                        style: TextStyle(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  FilledButton.icon(
                    onPressed: () => RaspChecker.openDeveloperSettings(),
                    icon: const Icon(Icons.settings),
                    label: const Text('Abrir ajustes'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final active = await RaspChecker.isUsbDebuggingEnabled();
                      if (!active) {
                        if (dialogContext.mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                        _isRaspDialogShowing = false;
                      } else {
                        setDialogState(() => stillActive = true);
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Ya lo desactivé'),
                  ),
                  TextButton.icon(
                    onPressed: () => SystemNavigator.pop(),
                    icon: const Icon(Icons.close, color: AppColors.error),
                    label: const Text('Cerrar app',
                        style: TextStyle(color: AppColors.error)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _runSecurityCheck({bool showLoading = true}) async {
    if (showLoading) setState(() => _isLoading = true);
    final status = await SecurityChecker.checkDeviceSecurity();
    if (mounted) {
      setState(() {
        _securityStatus = status;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: 20),
              Text(
                'Verificando seguridad del dispositivo…',
                style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    }

    if (_securityStatus == SecurityStatus.secure) {
      return widget.child;
    }

    return SecurityBlockedScreen(
      status: _securityStatus!,
      onRetrySuccess: () => _runSecurityCheck(),
    );
  }
}
