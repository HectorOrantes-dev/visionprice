import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Singleton de Dio configurado para VisionPrice API Gateway
///
/// - Base URL configurable via env
/// - JWT Interceptor
/// - Retry en errores de red
/// - Logging en debug
final class ApiClient {
  ApiClient._();

  static const String _baseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api.visionprice.mx/v1');

  static const Duration _connectTimeout = Duration(seconds: 10);
  static const Duration _receiveTimeout = Duration(seconds: 30);

  static Dio? _instance;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-App-Version': '1.0.0',
        },
      ),
    );

    // Logger solo en debug
    assert(() {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
          compact: true,
        ),
      );
      return true;
    }());

    // TODO: Agregar AuthInterceptor con JWT
    // dio.interceptors.add(AuthInterceptor(getIt<SecureStorage>()));

    return dio;
  }
}
