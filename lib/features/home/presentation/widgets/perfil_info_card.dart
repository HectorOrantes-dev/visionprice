import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../auth/domain/entities/perfil_entity.dart';
import 'perfil_info_row.dart';

/// Tarjeta con los datos de la cuenta que devuelve `/me/perfil`.
/// Antes el privado `_PerfilInfoCard`.
class PerfilInfoCard extends StatelessWidget {
  final PerfilEntity perfil;

  const PerfilInfoCard({super.key, required this.perfil});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        children: [
          PerfilInfoRow(
            icon: Icons.badge_outlined,
            label: 'Rol',
            value: _capitalize(perfil.rol.replaceAll('_', ' ')),
          ),
          if (perfil.telefono.isNotEmpty)
            PerfilInfoRow(
              icon: Icons.phone_outlined,
              label: 'Teléfono',
              value: perfil.telefono,
            ),
          PerfilInfoRow(
            icon: Icons.workspace_premium_outlined,
            label: 'Plan',
            value: perfil.tienePlan ? perfil.planActivo! : 'Sin plan activo',
            valueColor:
                perfil.tienePlan ? context.colors.primary : context.colors.textSecondary,
          ),
          if (perfil.vigenciaHasta != null)
            PerfilInfoRow(
              icon: Icons.event_available_outlined,
              label: 'Vigencia',
              value: _fmtDate(perfil.vigenciaHasta!),
            ),
          PerfilInfoRow(
            icon: Icons.lock_outline,
            label: 'Inicio de sesión',
            value: perfil.proveedorAuth == 'google'
                ? 'Google'
                : 'Correo y contraseña',
          ),
          if (perfil.fechaRegistro != null)
            PerfilInfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Miembro desde',
              value: _fmtDate(perfil.fechaRegistro!),
              showDivider: false,
            ),
        ],
      ),
    );
  }

  static String _fmtDate(DateTime d) => DateFormat('dd/MM/yyyy').format(d);

  static String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
