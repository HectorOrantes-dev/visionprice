import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../auth/domain/entities/perfil_entity.dart';
import 'info_row.dart';

/// Tarjeta con los datos de la cuenta que devuelve `/me/perfil`.
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
          InfoRow(
            icon: Icons.badge_outlined,
            label: 'Rol',
            value: _capitalize(perfil.rol.replaceAll('_', ' ')),
          ),
          if (perfil.telefono.isNotEmpty)
            InfoRow(
              icon: Icons.phone_outlined,
              label: 'Teléfono',
              value: perfil.telefono,
            ),
          InfoRow(
            icon: Icons.workspace_premium_outlined,
            label: 'Plan',
            value: perfil.tienePlan ? perfil.planActivo! : 'Sin plan activo',
            valueColor: perfil.tienePlan
                ? context.colors.primary
                : context.colors.textSecondary,
          ),
          if (perfil.vigenciaHasta != null)
            InfoRow(
              icon: Icons.event_available_outlined,
              label: 'Vigencia',
              value: _fmtDate(perfil.vigenciaHasta!),
            ),
          InfoRow(
            icon: Icons.lock_outline,
            label: 'Inicio de sesión',
            value: perfil.proveedorAuth == 'google'
                ? 'Google'
                : 'Correo y contraseña',
          ),
          if (perfil.fechaRegistro != null)
            InfoRow(
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
