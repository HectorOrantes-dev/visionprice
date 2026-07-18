import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/field_label.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../models/project_role.dart';
import '../widgets/join_status.dart';

/// Unirse a un proyecto con un código (mock). Los estados idle / validando /
/// éxito / error se simulan localmente con un pequeño delay.
class JoinProjectScreen extends StatefulWidget {
  const JoinProjectScreen({super.key});

  @override
  State<JoinProjectScreen> createState() => _JoinProjectScreenState();
}

class _JoinProjectScreenState extends State<JoinProjectScreen> {
  final _codigoController = TextEditingController();
  JoinStatus _status = JoinStatus.idle;

  @override
  void dispose() {
    _codigoController.dispose();
    super.dispose();
  }

  Future<void> _unirse() async {
    final codigo = _codigoController.text.trim();
    if (codigo.isEmpty) return;
    setState(() => _status = JoinStatus.validando);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    // Mock: "VP-…" válido; cualquier otra cosa → error.
    final valido = codigo.toUpperCase().startsWith('VP-');
    setState(() =>
        _status = valido ? JoinStatus.exito : JoinStatus.error);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: BackButton(color: context.colors.textPrimary),
        title: Text('Unirme a un proyecto',
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Ingresa el código',
                style: AppTextStyles.heading(
                    size: 20, color: context.colors.textPrimary),
              ),
              const SizedBox(height: 6),
              Text(
                'Pídele al dueño del proyecto el código de invitación.',
                style: TextStyle(
                    fontSize: 13, color: context.colors.textSecondary),
              ),
              const SizedBox(height: 24),
              const FieldLabel('CÓDIGO'),
              const SizedBox(height: 8),
              TextField(
                controller: _codigoController,
                textCapitalization: TextCapitalization.characters,
                onChanged: (_) {
                  if (_status != JoinStatus.idle) {
                    setState(() => _status = JoinStatus.idle);
                  }
                },
                decoration: InputDecoration(
                  hintText: 'VP-XXXX-XXXX',
                  prefixIcon: Icon(Icons.vpn_key_outlined,
                      size: 20, color: context.colors.textSecondary),
                ),
              ),
              const SizedBox(height: 16),
              if (_status == JoinStatus.exito) _resultBanner(context, true),
              if (_status == JoinStatus.error) _resultBanner(context, false),
              const SizedBox(height: 8),
              GradientButton(
                onPressed:
                    _status == JoinStatus.validando ? null : _unirse,
                child: _status == JoinStatus.validando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Unirme'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resultBanner(BuildContext context, bool exito) {
    final color = exito ? context.colors.success : context.colors.error;
    final bg = exito ? context.colors.successLight : context.colors.errorLight;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(exito ? Icons.check_circle_outline : Icons.error_outline,
              size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              exito
                  ? 'Te uniste como ${ProjectRole.colaborador.label}.'
                  : 'Código inválido o expirado.',
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
