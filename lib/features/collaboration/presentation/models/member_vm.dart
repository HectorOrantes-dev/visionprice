import 'project_role.dart';

/// Miembro de un proyecto (view-model UI-only para maquetar la lista).
class MemberVM {
  final String nombre;
  final String correo;
  final ProjectRole rol;
  final bool esDueno;

  const MemberVM({
    required this.nombre,
    required this.correo,
    required this.rol,
    this.esDueno = false,
  });

  /// Iniciales para el avatar (1-2 letras del nombre).
  String get iniciales {
    final partes =
        nombre.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (partes.isEmpty) return '?';
    if (partes.length == 1) return partes.first.substring(0, 1).toUpperCase();
    return (partes.first.substring(0, 1) + partes[1].substring(0, 1))
        .toUpperCase();
  }
}
