import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/home_provider.dart';
import 'create_project_sheet.dart';

/// Botón "Crear nuevo proyecto" de la home. Antes la función `_createProjectButton`.
class CreateProjectButton extends StatelessWidget {
  final HomeViewModel vm;
  const CreateProjectButton({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton(
          onPressed: () => showCreateProjectSheet(context, vm),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
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
