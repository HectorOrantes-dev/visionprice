import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/role_entity.dart';
import '../providers/register_provider.dart';

/// Selector de rol del registro. Antes el privado `_RoleDropdown`.
class RoleDropdown extends ConsumerWidget {
  const RoleDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);
    return DropdownButtonFormField<RoleEntity>(
      initialValue: state.selectedRole,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: 'Selecciona tu rol',
        prefixIcon: Icon(
          Icons.work_outline,
          color: context.colors.textSecondary,
          size: 20,
        ),
        errorText: state.roleError,
      ),
      items: state.roles
          .map(
            (role) => DropdownMenuItem<RoleEntity>(
              value: role,
              child: Text(role.label),
            ),
          )
          .toList(),
      onChanged: state.isLoading ? null : notifier.selectRole,
    );
  }
}
