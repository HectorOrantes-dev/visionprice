import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/field_label.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../domain/entities/project_role.dart';
import '../providers/collaboration_providers.dart';

/// Generar un código de invitación (`POST /proyectos/{id}/invitaciones`).
/// Elige rol + correos opcionales; al generar muestra el código real.
class GenerateInvitationScreen extends ConsumerStatefulWidget {
  final int proyectoId;
  const GenerateInvitationScreen({super.key, required this.proyectoId});

  @override
  ConsumerState<GenerateInvitationScreen> createState() =>
      _GenerateInvitationScreenState();
}

class _GenerateInvitationScreenState
    extends ConsumerState<GenerateInvitationScreen> {
  ProjectRole _rol = ProjectRole.colaborador;
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _generar() async {
    List<String>? correos;
    final raw = _emailController.text.trim();
    if (raw.isNotEmpty) {
      correos = raw
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    await ref
        .read(generarInvitacionProvider.notifier)
        .generar(widget.proyectoId, _rol.apiValue, correos: correos);
    // Refresca los códigos activos para que aparezca el nuevo al volver.
    ref.read(invitacionesProvider(widget.proyectoId).notifier).recargar();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final asyncState = ref.watch(generarInvitacionProvider);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        elevation: 0,
        leading: BackButton(color: c.textPrimary),
        title: Text('Invitar al proyecto',
            style: TextStyle(
                color: c.textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const FieldLabel('ROL EN EL PROYECTO'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final rol in ProjectRole.values)
                    _RolChip(
                      label: rol.label,
                      selected: rol == _rol,
                      onTap: () => setState(() => _rol = rol),
                    ),
                ],
              ),
              const SizedBox(height: 22),
              const FieldLabel('CORREOS (OPCIONAL)'),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: c.textPrimary),
                decoration: InputDecoration(
                  hintText: 'ana@empresa.com, otro@mail.com',
                  hintStyle: TextStyle(color: c.textHint),
                  helperText: 'Se les enviará el código por correo.',
                  helperStyle: TextStyle(color: c.textHint, fontSize: 11),
                  filled: true,
                  fillColor: c.surface,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: c.border),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: c.border),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              asyncState.when(
                data: (inv) => inv == null
                    ? GradientButton(
                        height: 52,
                        onPressed: _generar,
                        child: const Text('Generar código'),
                      )
                    : _CodigoCard(codigo: inv.codigo, expiraEn: inv.expiraEn),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (e, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      e is ApiException
                          ? e.message
                          : 'No se pudo generar el código.',
                      style: TextStyle(color: c.error, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    GradientButton(
                      height: 52,
                      onPressed: _generar,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RolChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _RolChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? c.primaryLight : c.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? c.primary : c.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 18,
              color: selected ? c.primary : c.textHint,
            ),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? c.primary : c.textPrimary,
                )),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta con el código recién generado (código grande + copiar + vigencia).
class _CodigoCard extends StatelessWidget {
  final String codigo;
  final Duration expiraEn;
  const _CodigoCard({required this.codigo, required this.expiraEn});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.border),
      ),
      child: Column(
        children: [
          Text('CÓDIGO DE INVITACIÓN',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: c.textSecondary,
              )),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: c.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              codigo,
              textAlign: TextAlign.center,
              style: AppTextStyles.heading(size: 24, color: c.primaryDark)
                  .copyWith(fontFamily: 'monospace', letterSpacing: 2),
            ),
          ),
          const SizedBox(height: 12),
          Text('Multiuso · expira en ${_texto(expiraEn)}',
              style: TextStyle(fontSize: 12, color: c.textSecondary)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: codigo));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Código copiado')),
                );
              },
              icon: const Icon(Icons.copy, size: 18),
              label: const Text('Copiar'),
            ),
          ),
        ],
      ),
    );
  }

  static String _texto(Duration d) {
    if (d.isNegative || d == Duration.zero) return 'Expirado';
    final days = d.inDays, h = d.inHours % 24, m = d.inMinutes % 60;
    if (days > 0) return '${days}d ${h}h';
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }
}
