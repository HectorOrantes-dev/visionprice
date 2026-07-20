import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import '../config/pinning_config.dart';

/// Fábrica de clientes HTTP (`dio`) para la práctica de HTTPS Pinning.
///
/// Expone dos clientes con el MISMO consumo de API para poder comparar:
///  - [pinned]   → valida estrictamente el certificado (rechaza MitM).
///  - [unpinned] → cliente normal (sirve para demostrar la intercepción).
class ApiClient {
  /// Cliente con **certificate pinning**.
  ///
  /// Se construye un [SecurityContext] con `withTrustedRoots: false` (no confía
  /// en NINGUNA CA del sistema) y se le añade como único certificado de
  /// confianza el del servidor legítimo (`PinningConfig.pinnedCertificatePem`).
  ///
  /// Resultado: el cliente SOLO completa el handshake si el servidor presenta
  /// exactamente ese certificado. Un proxy MitM presenta el suyo → la cadena no
  /// valida contra el certificado fijado → `HandshakeException`
  /// (`CERTIFICATE_VERIFY_FAILED`), es decir, la conexión se aborta de forma
  /// segura. Este método es determinista y funciona igual en Android/iOS.
  static Dio pinned() {
    final context = SecurityContext(withTrustedRoots: false)
      ..setTrustedCertificatesBytes(
        utf8.encode(PinningConfig.pinnedCertificatePem),
      );

    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () => HttpClient(context: context),
    );

    return dio;
  }

  /// Cliente HTTP **sin pinning**: no valida el certificado del servidor.
  ///
  /// `dart:io` no lee el almacén de CAs de usuario de Android (solo el stack
  /// nativo lo hace), así que aunque el usuario instale la CA del proxy MitM
  /// en el sistema, Dio seguiría rechazándola por certificado no confiable.
  /// Para representar fielmente "sin pinning = sin protección ante MitM", este
  /// cliente acepta cualquier certificado explícitamente. SOLO para esta
  /// práctica de laboratorio: en producción nunca se debe desactivar la
  /// validación de certificados así.
  static Dio unpinned() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () => HttpClient()
        ..badCertificateCallback = (cert, host, port) => true,
    );

    return dio;
  }
}
