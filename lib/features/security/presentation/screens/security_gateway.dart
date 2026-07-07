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
  bool _isUsbDebuggingActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runRaspCheck();
      SecurityChecker.enableScreenProtection();
    });
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

    if (_isUsbDebuggingActive != usbOn) {
      setState(() {
        _isUsbDebuggingActive = usbOn;
      });
    }
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
        onRetrySuccess: () => _runRaspCheck(),
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
