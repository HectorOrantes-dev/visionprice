import 'package:flutter/material.dart';
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
  bool _isUsbDebuggingActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SecurityChecker.enableScreenProtection();
    });
    _runChecks();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _runChecks(showLoading: false);
    }
  }

  /// Verifica primero la Depuración USB (lectura nativa, INSTANTÁNEA) y hace
  /// corto-circuito: si está activa, bloquea de inmediato sin esperar el chequeo
  /// de Fake GPS, que es lento (pide una ubicación fresca, hasta 10 s).
  Future<void> _runChecks({bool showLoading = true}) async {
    if (showLoading && mounted) setState(() => _isLoading = true);

    // 1. USB primero (rápido).
    final bool usbOn = await RaspChecker.isUsbDebuggingEnabled();
    if (!mounted) return;
    if (usbOn) {
      setState(() {
        _isUsbDebuggingActive = true;
        _isLoading = false;
      });
      return;
    }

    // 2. USB ok → recién ahora el chequeo de ubicación (lento).
    final SecurityStatus status = await SecurityChecker.checkDeviceSecurity();
    if (!mounted) return;
    setState(() {
      _isUsbDebuggingActive = false;
      _securityStatus = status;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
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
        ),
      );
    }

    if (_isUsbDebuggingActive) {
      return SecurityBlockedScreen(
        status: SecurityStatus.usbDebuggingDetected,
        onRetrySuccess: () => _runChecks(),
      );
    }

    if (_securityStatus == SecurityStatus.secure) {
      return widget.child;
    }

    return SecurityBlockedScreen(
      status: _securityStatus!,
      onRetrySuccess: () => _runChecks(),
    );
  }
}
