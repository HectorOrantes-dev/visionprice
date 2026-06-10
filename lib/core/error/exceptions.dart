/// Excepciones de la capa Data (se mapean a Failures en los repositorios)
class NetworkException implements Exception {
  const NetworkException([this.message = 'Sin conexión a internet']);
  final String message;
  @override
  String toString() => 'NetworkException: $message';
}

class UnauthorizedException implements Exception {
  const UnauthorizedException([this.message = 'No autorizado']);
  final String message;
}

class ServerException implements Exception {
  const ServerException({required this.message, this.statusCode});
  final String message;
  final int? statusCode;
  @override
  String toString() => 'ServerException($statusCode): $message';
}

class NotFoundException implements Exception {
  const NotFoundException([this.message = 'Recurso no encontrado']);
  final String message;
}

class CacheException implements Exception {
  const CacheException([this.message = 'Error de caché local']);
  final String message;
}
