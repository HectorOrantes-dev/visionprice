import '../models/invitation_vm.dart';
import '../models/member_vm.dart';
import '../models/project_role.dart';

/// DATOS FALSOS (mock) para maquetar las vistas de colaboración.
///
/// TEMPORAL: todo lo hardcodeado vive aquí para poder borrarlo de un tirón
/// cuando se conecte el back-end. NO usar en producción.
abstract final class CollabMock {
  /// Nombre del proyecto de ejemplo (para los AppBar / subtítulos).
  static const proyectoNombre = 'Construcción Calle 45';

  /// Miembros del proyecto: el dueño primero, luego colaboradores.
  static const List<MemberVM> miembros = [
    MemberVM(
      nombre: 'Lidia Molina',
      correo: 'lidia@empresa.com',
      rol: ProjectRole.arquitecto,
      esDueno: true,
    ),
    MemberVM(
      nombre: 'Héctor Orantes',
      correo: 'hector@empresa.com',
      rol: ProjectRole.ingenieroCivil,
    ),
    MemberVM(
      nombre: 'Joaquín Gómez',
      correo: 'joaquin@empresa.com',
      rol: ProjectRole.maestroObra,
    ),
    MemberVM(
      nombre: 'Ana Ruiz',
      correo: 'ana@empresa.com',
      rol: ProjectRole.colaborador,
    ),
  ];

  /// Solo tú en el proyecto (para probar el estado vacío).
  static const List<MemberVM> soloDueno = [
    MemberVM(
      nombre: 'Lidia Molina',
      correo: 'lidia@empresa.com',
      rol: ProjectRole.arquitecto,
      esDueno: true,
    ),
  ];

  /// Códigos de invitación activos de ejemplo.
  static const List<InvitationVM> invitaciones = [
    InvitationVM(
      codigo: 'VP-7Q2K-9XLM',
      rol: ProjectRole.colaborador,
      expiraEn: Duration(days: 2, hours: 4),
      usos: 3,
    ),
    InvitationVM(
      codigo: 'VP-3H8T-2WZP',
      rol: ProjectRole.maestroObra,
      expiraEn: Duration(hours: 5, minutes: 12),
      usos: 1,
    ),
  ];

  /// Un código recién "generado" (mock) para la pantalla de generar invitación.
  static const InvitationVM codigoGenerado = InvitationVM(
    codigo: 'VP-5D1F-8KQR',
    rol: ProjectRole.colaborador,
    expiraEn: Duration(days: 3),
    usos: 0,
  );
}
