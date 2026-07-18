import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/invitacion_entity.dart';
import '../repositories/collaboration_repository.dart';

class ObtenerInvitacionesUseCase {
  final CollaborationRepository repository;

  ObtenerInvitacionesUseCase(this.repository);

  Future<Either<Failure, List<InvitacionEntity>>> call(int proyectoId) {
    return repository.obtenerInvitaciones(proyectoId);
  }
}
