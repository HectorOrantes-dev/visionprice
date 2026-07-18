import 'package:flutter/material.dart';

import '../models/project_role.dart';
import 'role_option.dart';

/// Selector del `rol_en_proyecto` con el que entrará el invitado.
/// Muestra un chip por rol; el seleccionado se resalta.
class RoleSelector extends StatelessWidget {
  final ProjectRole selected;
  final ValueChanged<ProjectRole> onChanged;

  const RoleSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final rol in ProjectRole.values)
          RoleOption(
            rol: rol,
            selected: rol == selected,
            onTap: () => onChanged(rol),
          ),
      ],
    );
  }
}
