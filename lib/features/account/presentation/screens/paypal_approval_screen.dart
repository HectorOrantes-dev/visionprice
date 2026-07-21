import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/network/api_config.dart';
import '../../../../core/theme/app_palette.dart';

/// Abre la URL de aprobación de PayPal en un WebView. El usuario aprueba (o
/// cancela) el pago ahí, en la interfaz de PayPal — nunca en nuestra app.
/// Cuando PayPal redirige a `paypalReturnUrl`/`paypalCancelUrl` intercepta la
/// navegación y hace `pop(true/false)`, sin llegar a cargar esa página.
///
/// OJO: el `pop(true)` solo significa "el usuario aprobó en PayPal", NO que
/// el cobro ya esté confirmado — eso llega después por webhook. El llamador
/// debe refrescar el estado de la suscripción tras recibir `true`.
class PaypalApprovalScreen extends StatefulWidget {
  final String approvalUrl;
  const PaypalApprovalScreen({super.key, required this.approvalUrl});

  @override
  State<PaypalApprovalScreen> createState() => _PaypalApprovalScreenState();
}

class _PaypalApprovalScreenState extends State<PaypalApprovalScreen> {
  late final WebViewController _controller;
  bool _loadingPage = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _loadingPage = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _loadingPage = false);
          },
          onNavigationRequest: (request) {
            if (request.url.startsWith(ApiConfig.paypalReturnUrl)) {
              Navigator.pop(context, true);
              return NavigationDecision.prevent;
            }
            if (request.url.startsWith(ApiConfig.paypalCancelUrl)) {
              Navigator.pop(context, false);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.approvalUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: context.colors.textPrimary),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: Text('Aprobar con PayPal',
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            )),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_loadingPage) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
