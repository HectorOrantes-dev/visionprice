import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/theme/app_palette.dart';

/// Abre el checkout hospedado de Conekta (pago con OXXO/efectivo o SPEI/
/// transferencia) en un WebView. A diferencia del flujo de tarjeta, aquí NO
/// hay un token que recoger: el usuario ve su referencia/CLABE en la propia
/// página de Conekta y paga fuera de la app (en la tienda o en su banco).
/// El `pop` solo cierra la vista; la suscripción se activa después, cuando
/// Conekta confirme el pago por webhook.
class ConektaCheckoutWebviewScreen extends StatefulWidget {
  final String checkoutUrl;
  const ConektaCheckoutWebviewScreen({super.key, required this.checkoutUrl});

  @override
  State<ConektaCheckoutWebviewScreen> createState() =>
      _ConektaCheckoutWebviewScreenState();
}

class _ConektaCheckoutWebviewScreenState
    extends State<ConektaCheckoutWebviewScreen> {
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
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Pagar con Conekta',
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
