import '../../domain/entities/subscripcion_entity.dart';

abstract class AccountRemoteDataSource {
  Future<List<SubscripcionEntity>> listarSubscripciones();
}
