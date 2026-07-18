import 'project_role.dart';

/// Código de invitación a un proyecto (view-model UI-only para maquetar).
class InvitationVM {
  final String codigo;
  final ProjectRole rol;

  /// Tiempo restante hasta que expira (para pintar "Expira en 2d 4h").
  final Duration expiraEn;
  final int usos;

  /// Estado del código: 'activo' | 'revocado' | 'expirado'.
  final String estado;

  const InvitationVM({
    required this.codigo,
    required this.rol,
    required this.expiraEn,
    this.usos = 0,
    this.estado = 'activo',
  });

  /// Texto tipo "2d 4h" / "5h 12m" / "8m" a partir de [expiraEn].
  String get expiraTexto {
    if (expiraEn.isNegative || expiraEn == Duration.zero) return 'Expirado';
    final d = expiraEn.inDays;
    final h = expiraEn.inHours % 24;
    final m = expiraEn.inMinutes % 60;
    if (d > 0) return '${d}d ${h}h';
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }
}
