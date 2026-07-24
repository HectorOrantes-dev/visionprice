import 'package:flutter/material.dart';
import '../../../../core/theme/app_palette.dart';
import '../../rasp_checker.dart';
import 'usb_debugging_blocked_screen.dart';

/// Envuelve la app: si detecta Depuración USB activa, bloquea el acceso con
/// [UsbDebuggingBlockedScreen] en vez de mostrar [child]. Revalida cada vez
/// que la app vuelve a primer plano (por si la desactivan y regresan).
class UsbDebuggingGate extends StatefulWidget {
  final Widget child;
  const UsbDebuggingGate({super.key, required this.child});

  @override
  State<UsbDebuggingGate> createState() => _UsbDebuggingGateState();
}

class _UsbDebuggingGateState extends State<UsbDebuggingGate>
    with WidgetsBindingObserver {
  bool _isLoading = true;
  bool _usbDebuggingActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _runCheck();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _runCheck(showLoading: false);
    }
  }

  Future<void> _runCheck({bool showLoading = true}) async {
    if (showLoading && mounted) setState(() => _isLoading = true);
    final usbOn = await RaspChecker.isUsbDebuggingEnabled();
    if (!mounted) return;
    setState(() {
      _usbDebuggingActive = usbOn;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: context.colors.background,
        body: Center(
          child: CircularProgressIndicator(color: context.colors.primary),
        ),
      );
    }
    if (_usbDebuggingActive) {
      return UsbDebuggingBlockedScreen(onRetrySuccess: () => _runCheck());
    }
    return widget.child;
  }
}
