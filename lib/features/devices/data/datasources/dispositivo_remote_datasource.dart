// La implementación vive en su propio archivo (una clase por archivo, SRP);
// se re-exporta para no romper imports existentes ni la DI generada.
export 'dispositivo_remote_datasource_impl.dart';

abstract class DispositivoRemoteDataSource {
  Future<void> registrar(String token, String plataforma);
  Future<void> borrar(String token);
}
