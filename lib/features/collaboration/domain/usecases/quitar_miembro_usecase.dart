import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/collaboration_repository.dart';

class QuitarMiembroUseCase {
  final CollaborationRepository repository;

  QuitarMiembroUseCase(this.repository);

  Future<Either<Failure, void>> call(int proyectoId, int usuarioId) {
    return repository.quitarMiembro(proyectoId, usuarioId);
  }
}
