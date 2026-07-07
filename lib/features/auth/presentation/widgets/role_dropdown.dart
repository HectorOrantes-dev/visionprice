import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/role_entity.dart';
import '../providers/register_provider.dart';

/// Selector de rol del registro (antes privado `_RoleDropdown`).
class RoleDropdown extends StatelessWidget {
  const RoleDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();
    return DropdownButtonFormField<RoleEntity>(
      initialValue: vm.selectedRole,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: 'Selecciona tu rol',
        prefixIcon: const Icon(
          Icons.work_outline,
          color: AppColors.textSecondary,
          size: 20,
        ),
        errorText: vm.roleError,
      ),
      items: vm.roles
          .map(
            (role) => DropdownMenuItem<RoleEntity>(
              value: role,
              child: Text(role.label),
            ),
          )
          .toList(),
      onChanged: vm.isLoading ? null : vm.selectRole,
    );
  }
}
