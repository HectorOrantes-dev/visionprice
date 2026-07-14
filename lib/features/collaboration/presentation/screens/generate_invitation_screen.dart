import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../shared/widgets/field_label.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../mock/collab_mock_data.dart';
import '../models/invitation_vm.dart';
import '../models/project_role.dart';
import '../widgets/emails_field.dart';
import '../widgets/invitation_code_card.dart';
import '../widgets/role_selector.dart';

/// Generar código de invitación (mock). Elige rol + correos opcionales y
/// "genera" un código de ejemplo. Estado 100% local.
class GenerateInvitationScreen extends StatefulWidget {
  const GenerateInvitationScreen({super.key});

  @override
  State<GenerateInvitationScreen> createState() =>
      _GenerateInvitationScreenState();
}

class _GenerateInvitationScreenState extends State<GenerateInvitationScreen> {
  ProjectRole _rol = ProjectRole.colaborador;
  List<String> _emails = [];
  bool _generado = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: BackButton(color: context.colors.textPrimary),
        title: Text('Invitar al proyecto',
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
              const FieldLabel('ROL EN EL PROYECTO'),
              const SizedBox(height: 10),
              RoleSelector(
                selected: _rol,
                onChanged: (r) => setState(() => _rol = r),
              ),
              const SizedBox(height: 22),
              const FieldLabel('CORREOS (OPCIONAL)'),
              const SizedBox(height: 10),
              EmailsField(
                emails: _emails,
                onChanged: (list) => setState(() => _emails = list),
              ),
              const SizedBox(height: 24),
              GradientButton(
                onPressed: () => setState(() => _generado = true),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.vpn_key_outlined, size: 18, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Generar código'),
                  ],
                ),
              ),
              if (_generado) ...[
                const SizedBox(height: 24),
                InvitationCodeCard(
                  invitation: InvitationVM(
                    codigo: CollabMock.codigoGenerado.codigo,
                    rol: _rol,
                    expiraEn: CollabMock.codigoGenerado.expiraEn,
                  ),
                ),
                if (_emails.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.colors.successLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.mark_email_read_outlined,
                            size: 16, color: context.colors.success),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Se enviará por correo a ${_emails.length} destinatario(s).',
                            style: TextStyle(
                                fontSize: 12, color: context.colors.success),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
