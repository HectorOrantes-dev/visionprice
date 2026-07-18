import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../shared/widgets/field_label.dart';
import '../providers/forgot_password_provider.dart';
import 'back_step_link.dart';
import 'primary_button.dart';

/// Paso 2: verificación del código recibido. Antes el privado `_CodeStep`.
class CodeStep extends StatelessWidget {
  final TextEditingController controller;
  final ForgotPasswordState state;
  final ForgotPassword notifier;

  const CodeStep({
    super.key,
    required this.controller,
    required this.state,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('CÓDIGO'),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: notifier.onCodeChanged,
          decoration: InputDecoration(
            hintText: 'Código de verificación',
            prefixIcon: Icon(Icons.shield_outlined,
                color: context.colors.textSecondary, size: 20),
            errorText: state.codeError,
          ),
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          loading: state.isLoading,
          label: 'Verificar código',
          onPressed: () => notifier.verificarCodigo(code: controller.text),
        ),
        const SizedBox(height: 8),
        BackStepLink(label: 'Cambiar correo', onTap: notifier.volverAtras),
      ],
    );
  }
}
