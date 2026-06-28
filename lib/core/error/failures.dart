import 'package:equatable/equatable.dart';

/// Jerarquía de Failures para la capa Domain
/// Uso con dartz Either<Failure, T>
sealed class Failure extends Equatable {
  const Failure([this.message = 'Error desconocido']);
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Error de red (sin conexión, timeout)
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Sin conexión a internet']);
}

/// Error de autenticación (JWT expirado, no autorizado)
final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Sesión expirada. Inicia sesión nuevamente']);
}

/// Error del servidor (500, 503)
final class ServerFailure extends Failure {
  const ServerFailure(super.message, [this.statusCode]);
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// Recurso no encontrado (404)
final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Recurso no encontrado']);
}

/// Error de validación / entrada de datos
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Error de caché local (Hive)
final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Error al leer datos locales']);
}

/// Error al exportar PDF
final class ExportFailure extends Failure {
  const ExportFailure([super.message = 'Error al generar el PDF']);
}
