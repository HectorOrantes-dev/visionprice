import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vision_price/features/security/rasp_checker.dart';
import 'package:vision_price/features/security/security_checker.dart';
import 'package:vision_price/features/security/presentation/pages/security_blocked_page.dart';

/// Puerta de entrada de seguridad que envuelve la app completa.
/// Verifica RASP (USB Debugging) y Fake GPS antes de mostrar el contenido.
class SecurityGatewayPage extends StatefulWidget {
  final Widget child;

  const SecurityGatewayPage({super.key, required this.child});

  @override
  State<SecurityGatewayPage> createState() => _SecurityGatewayPageState();
}

class _SecurityGatewayPageState extends State<SecurityGatewayPage>
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
    final bool usbDebuggingEnabled = await RaspChecker.isUsbDebuggingEnabled();
    if (!mounted) return;

    if (usbDebuggingEnabled) {
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
                backgroundColor: const Color(0xFF1A1428),
                icon: const Icon(Icons.gpp_bad_rounded,
                    color: Color(0xFFFF4D6D), size: 48),
                title: const Text(
                  'Depuración USB activa',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Por políticas de seguridad, la aplicación no puede '
                      'ejecutarse mientras la Depuración por USB esté activada.\n\n'
                      'Desactívala en:\n'
                      'Ajustes › Opciones de desarrollador › Depuración por USB.',
                      style: TextStyle(color: Colors.white70, height: 1.4),
                    ),
                    if (stillActive) ...[
                      const SizedBox(height: 12),
                      const Text(
                        '⚠️ La Depuración USB sigue activa.',
                        style: TextStyle(
                          color: Color(0xFFFFB020),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF00E5FF),
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () => RaspChecker.openDeveloperSettings(),
                    icon: const Icon(Icons.settings),
                    label: const Text('Abrir ajustes'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final bool active =
                          await RaspChecker.isUsbDebuggingEnabled();
                      if (!active) {
                        if (dialogContext.mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                        _isRaspDialogShowing = false;
                      } else {
                        setDialogState(() => stillActive = true);
                      }
                    },
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text('Ya lo desactivé',
                        style: TextStyle(color: Colors.white)),
                  ),
                  TextButton.icon(
                    onPressed: () => SystemNavigator.pop(),
                    icon: const Icon(Icons.close, color: Color(0xFFFF4D6D)),
                    label: const Text('Cerrar aplicación',
                        style: TextStyle(color: Color(0xFFFF4D6D))),
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
        backgroundColor: Color(0xFF0F0C1B),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Color(0xFF00E5FF)),
                strokeWidth: 3.5,
              ),
              SizedBox(height: 24),
              Text(
                'Iniciando Auditoría de Seguridad...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_securityStatus == SecurityStatus.secure) {
      return widget.child;
    }

    return SecurityBlockedPage(
      status: _securityStatus!,
      onRetrySuccess: _runSecurityCheck,
    );
  }
}
