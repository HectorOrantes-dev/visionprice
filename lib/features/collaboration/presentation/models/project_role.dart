import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

/// Rol con el que un colaborador participa en un proyecto.
///
/// UI-ONLY / TEMPORAL: son placeholders para maquetar. Cuando se conecte el
/// back-end, estos valores se alinearán con los `rol_en_proyecto` reales.
enum ProjectRole {
  arquitecto,
  ingenieroCivil,
  maestroObra,
  colaborador,
}

extension ProjectRoleX on ProjectRole {
  String get label => switch (this) {
        ProjectRole.arquitecto => 'Arquitecto',
        ProjectRole.ingenieroCivil => 'Ingeniero civil',
        ProjectRole.maestroObra => 'Maestro de obra',
        ProjectRole.colaborador => 'Colaborador',
      };

  /// Color de acento del rol, tomado de la paleta de la app.
  Color color(BuildContext context) {
    final c = context.colors;
    return switch (this) {
      ProjectRole.arquitecto => c.primary,
      ProjectRole.ingenieroCivil => c.info,
      ProjectRole.maestroObra => c.warning,
      ProjectRole.colaborador => c.textSecondary,
    };
  }
}
