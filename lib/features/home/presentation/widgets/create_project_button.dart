import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../providers/home_provider.dart';
import 'create_project_sheet.dart';

/// Botón de la home para crear un proyecto (abre el `CreateProjectSheet`).
class CreateProjectButton extends StatelessWidget {
  final Home notifier;
  const CreateProjectButton({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton(
          onPressed: () => CreateProjectSheet.show(context, notifier),
          style: OutlinedButton.styleFrom(
            foregroundColor: context.colors.primary,
            side: BorderSide(color: context.colors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.create_new_folder_outlined, size: 20),
              SizedBox(width: 10),
              Text(
                'Crear nuevo proyecto',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
