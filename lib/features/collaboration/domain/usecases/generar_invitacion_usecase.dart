import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/invitacion_entity.dart';
import '../repositories/collaboration_repository.dart';

class GenerarInvitacionUseCase {
  final CollaborationRepository repository;

  GenerarInvitacionUseCase(this.repository);

  Future<Either<Failure, InvitacionEntity>> call(int proyectoId, String rol, {List<String>? correos}) {
    return repository.generarInvitacion(proyectoId, rol, correos);
  }
}
