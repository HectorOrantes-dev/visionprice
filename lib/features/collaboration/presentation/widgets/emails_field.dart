import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Input de correos opcionales: se escribe un correo y con Enter/coma se
/// convierte en un chip. Estado local (mock), sin validación de backend.
class EmailsField extends StatefulWidget {
  final List<String> emails;
  final ValueChanged<List<String>> onChanged;

  const EmailsField({super.key, required this.emails, required this.onChanged});

  @override
  State<EmailsField> createState() => _EmailsFieldState();
}

class _EmailsFieldState extends State<EmailsField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add(String raw) {
    final email = raw.trim().replaceAll(',', '');
    if (email.isEmpty || widget.emails.contains(email)) {
      _controller.clear();
      return;
    }
    widget.onChanged([...widget.emails, email]);
    _controller.clear();
  }

  void _remove(String email) =>
      widget.onChanged(widget.emails.where((e) => e != email).toList());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          keyboardType: TextInputType.emailAddress,
          onSubmitted: _add,
          onChanged: (v) {
            if (v.endsWith(',') || v.endsWith(' ')) _add(v);
          },
          decoration: InputDecoration(
            hintText: 'correo@empresa.com',
            prefixIcon: Icon(Icons.alternate_email,
                size: 20, color: context.colors.textSecondary),
          ),
        ),
        if (widget.emails.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final email in widget.emails)
                Chip(
                  label: Text(email, style: const TextStyle(fontSize: 12)),
                  backgroundColor: context.colors.primaryLight,
                  labelStyle: TextStyle(color: context.colors.primaryDark),
                  deleteIconColor: context.colors.primaryDark,
                  onDeleted: () => _remove(email),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
            ],
          ),
        ],
      ],
    );
  }
}
