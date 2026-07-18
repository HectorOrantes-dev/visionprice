import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/invitacion_entity.dart';
import '../entities/miembros_result_entity.dart';
import '../entities/unirse_result_entity.dart';

abstract class CollaborationRepository {
  Future<Either<Failure, MiembrosResultEntity>> obtenerMiembros(int proyectoId);
  Future<Either<Failure, void>> quitarMiembro(int proyectoId, int usuarioId);
  Future<Either<Failure, InvitacionEntity>> generarInvitacion(int proyectoId, String rol, List<String>? correos);
  Future<Either<Failure, List<InvitacionEntity>>> obtenerInvitaciones(int proyectoId);
  Future<Either<Failure, void>> revocarInvitacion(int proyectoId, int invitacionId);
  Future<Either<Failure, UnirseResultEntity>> unirseAProyecto(String codigo);
}
