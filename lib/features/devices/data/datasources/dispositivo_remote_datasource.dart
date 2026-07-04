abstract class DispositivoRemoteDataSource {
  Future<void> registrar(String token, String plataforma);
  Future<void> borrar(String token);
}
