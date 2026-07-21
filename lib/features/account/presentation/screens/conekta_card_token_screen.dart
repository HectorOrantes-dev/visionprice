import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/network/api_config.dart';
import '../../../../core/theme/app_palette.dart';

/// Tokeniza la tarjeta con `conekta.js` dentro de un WebView: los datos de la
/// tarjeta viajan directo del WebView a Conekta (nunca pasan por Dart ni por
/// nuestro back-end, por cumplimiento PCI). Al terminar hace `pop` con el
/// `card_token` (`tok_xxxxx`), o `null` si el usuario cancela.
class ConektaCardTokenScreen extends StatefulWidget {
  const ConektaCardTokenScreen({super.key});

  @override
  State<ConektaCardTokenScreen> createState() =>
      _ConektaCardTokenScreenState();
}

class _ConektaCardTokenScreenState extends State<ConektaCardTokenScreen> {
  WebViewController? _controller;
  bool _loadingPage = true;
  String? _fatalError;

  @override
  void initState() {
    super.initState();
    if (ApiConfig.conektaPublicKey.isEmpty) {
      // Sin Public Key no se puede tokenizar; mejor avisar claro que fallar
      // en silencio dentro del WebView.
      _fatalError =
          'Falta configurar la Public Key de Conekta (CONEKTA_PUBLIC_KEY) '
          'en el build de la app.';
      return;
    }
    _initWebView();
  }

  Future<void> _initWebView() async {
    final template =
        await rootBundle.loadString('assets/pagos/conekta_card_form.html');
    final html = template.replaceAll(
        '{{CONEKTA_PUBLIC_KEY}}', ApiConfig.conektaPublicKey);

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'ConektaToken',
        onMessageReceived: _onTokenMessage,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loadingPage = false);
          },
        ),
      )
      ..loadHtmlString(html, baseUrl: 'https://app.visionprice.mx');

    if (mounted) setState(() => _controller = controller);
  }

  void _onTokenMessage(JavaScriptMessage message) {
    final data = jsonDecode(message.message) as Map<String, dynamic>;
    if (data['ok'] == true) {
      Navigator.pop(context, data['token'] as String);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(data['message']?.toString() ?? 'Tarjeta rechazada.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: BackButton(color: context.colors.textPrimary),
        title: Text('Datos de tarjeta',
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            )),
      ),
      body: SafeArea(
        child: _fatalError != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    _fatalError!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.colors.error),
                  ),
                ),
              )
            : _controller == null
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      WebViewWidget(controller: _controller!),
                      if (_loadingPage)
                        const Center(child: CircularProgressIndicator()),
                    ],
                  ),
      ),
    );
  }
}
