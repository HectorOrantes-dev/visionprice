abstract class DispositivoRemoteDataSource {
  Future<void> registrar(String pushToken, String deviceId, String platform);
  Future<void> borrar(String pushToken);
}
