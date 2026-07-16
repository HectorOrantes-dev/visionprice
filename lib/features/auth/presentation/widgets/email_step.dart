import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../shared/widgets/field_label.dart';
import '../providers/forgot_password_provider.dart';
import 'primary_button.dart';

/// Paso 1: captura del correo y envío del código. Antes el privado `_EmailStep`.
class EmailStep extends StatelessWidget {
  final TextEditingController controller;
  final ForgotPasswordState state;
  final ForgotPassword notifier;

  const EmailStep({
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
        const FieldLabel('CORREO'),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          onChanged: notifier.onEmailChanged,
          decoration: InputDecoration(
            hintText: 'tu@correo.mx',
            prefixIcon: Icon(Icons.person_outline,
                color: context.colors.textSecondary, size: 20),
            errorText: state.emailError,
          ),
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          loading: state.isLoading,
          label: 'Enviar código',
          onPressed: () => notifier.enviarCodigo(correo: controller.text),
        ),
      ],
    );
  }
}
