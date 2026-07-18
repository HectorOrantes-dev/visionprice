import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/miembros_result_entity.dart';
import '../repositories/collaboration_repository.dart';

class ObtenerMiembrosUseCase {
  final CollaborationRepository repository;

  ObtenerMiembrosUseCase(this.repository);

  Future<Either<Failure, MiembrosResultEntity>> call(int proyectoId) {
    return repository.obtenerMiembros(proyectoId);
  }
}
