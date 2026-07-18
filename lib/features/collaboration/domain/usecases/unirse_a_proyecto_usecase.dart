import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/unirse_result_entity.dart';
import '../repositories/collaboration_repository.dart';

class UnirseAProyectoUseCase {
  final CollaborationRepository repository;

  UnirseAProyectoUseCase(this.repository);

  Future<Either<Failure, UnirseResultEntity>> call(String codigo) {
    return repository.unirseAProyecto(codigo);
  }
}
