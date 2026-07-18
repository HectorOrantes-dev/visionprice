import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/collaboration_repository.dart';

class RevocarInvitacionUseCase {
  final CollaborationRepository repository;

  RevocarInvitacionUseCase(this.repository);

  Future<Either<Failure, void>> call(int proyectoId, int invitacionId) {
    return repository.revocarInvitacion(proyectoId, invitacionId);
  }
}
