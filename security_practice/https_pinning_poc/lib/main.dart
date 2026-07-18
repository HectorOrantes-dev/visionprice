import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'config/pinning_config.dart';
import 'network/api_client.dart';

void main() => runApp(const PinningApp());

class PinningApp extends StatelessWidget {
  const PinningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTTPS Pinning PoC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1565C0),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

/// Estado del resultado de la última petición, para pintar la UI.
enum RequestOutcome { idle, loading, success, blocked, otherError }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _pinningEnabled = true;
  RequestOutcome _outcome = RequestOutcome.idle;
  String _detail = '';

  Future<void> _consultarApi() async {
    setState(() {
      _outcome = RequestOutcome.loading;
      _detail = '';
    });

    final dio = _pinningEnabled ? ApiClient.pinned() : ApiClient.unpinned();

    try {
      final res = await dio.get<dynamic>(PinningConfig.apiUrl);
      setState(() {
        _outcome = RequestOutcome.success;
        _detail = 'HTTP ${res.statusCode}\n\n${res.data}';
      });
    } on DioException catch (e) {
      // Un fallo de handshake por certificado no confiable llega como
      // HandshakeException dentro de DioException. Ese es el bloqueo por
      // pinning (o por CA no confiable): se aborta la conexión de forma segura.
      final isPinningBlock = e.error is HandshakeException ||
          e.type == DioExceptionType.badCertificate;
      setState(() {
        _outcome =
            isPinningBlock ? RequestOutcome.blocked : RequestOutcome.otherError;
        _detail = isPinningBlock
            ? 'Se abortó la conexión: el certificado del servidor NO coincide '
                'con el pin embebido.\n\n${e.error ?? e.message}'
            : 'Error de red (${e.type.name}):\n${e.message ?? e.error}';
      });
    } catch (e) {
      setState(() {
        _outcome = RequestOutcome.otherError;
        _detail = 'Error inesperado:\n$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HTTPS Pinning · PoC'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const _InfoCard(),
            const SizedBox(height: 16),
            Card(
              child: SwitchListTile(
                value: _pinningEnabled,
                onChanged: _outcome == RequestOutcome.loading
                    ? null
                    : (v) => setState(() => _pinningEnabled = v),
                title: const Text('Certificate Pinning'),
                subtitle: Text(
                  _pinningEnabled
                      ? 'ACTIVADO · solo se acepta el certificado legítimo'
                      : 'DESACTIVADO · cliente normal (interceptable)',
                ),
                secondary: Icon(
                  _pinningEnabled ? Icons.lock : Icons.lock_open,
                  color: _pinningEnabled ? Colors.green : Colors.orange,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed:
                  _outcome == RequestOutcome.loading ? null : _consultarApi,
              icon: _outcome == RequestOutcome.loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.cloud_download_outlined),
              label: const Text('Consultar API'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
            ),
            const SizedBox(height: 20),
            _ResultCard(outcome: _outcome, detail: _detail),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFE3F2FD),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Servidor de confianza',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 6),
            Text(PinningConfig.host,
                style: const TextStyle(fontFamily: 'monospace')),
            const SizedBox(height: 10),
            const Text('SHA-256 fijado (pin):',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            SelectableText(
              PinningConfig.pinnedSha256,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final RequestOutcome outcome;
  final String detail;
  const _ResultCard({required this.outcome, required this.detail});

  @override
  Widget build(BuildContext context) {
    late final Color color;
    late final IconData icon;
    late final String title;

    switch (outcome) {
      case RequestOutcome.idle:
        return const SizedBox.shrink();
      case RequestOutcome.loading:
        color = Colors.blueGrey;
        icon = Icons.hourglass_top;
        title = 'Consultando…';
      case RequestOutcome.success:
        color = Colors.green;
        icon = Icons.check_circle;
        title = 'Conexión exitosa';
      case RequestOutcome.blocked:
        color = Colors.red;
        icon = Icons.gpp_bad;
        title = 'Conexión BLOQUEADA por pinning';
      case RequestOutcome.otherError:
        color = Colors.orange;
        icon = Icons.error_outline;
        title = 'Error';
    }

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: color)),
                ),
              ],
            ),
            if (detail.isNotEmpty) ...[
              const SizedBox(height: 12),
              SelectableText(detail,
                  style:
                      const TextStyle(fontFamily: 'monospace', fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }
}
