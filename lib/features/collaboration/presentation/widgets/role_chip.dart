import 'package:flutter/material.dart';

import '../models/project_role.dart';

/// Chip de color según el rol (pill con el acento del rol).
class RoleChip extends StatelessWidget {
  final ProjectRole rol;
  const RoleChip({super.key, required this.rol});

  @override
  Widget build(BuildContext context) {
    final color = rol.color(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        rol.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
