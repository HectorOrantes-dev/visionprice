// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Cliente HTTP compartido (core). `keepAlive`: singleton de sesión.
///
/// Se construye sobre un `HttpClient` con `autoUncompress = false`: algunos
/// back-ends/proxies responden con `Content-Encoding: gzip` pero un cuerpo que
/// NO es un gzip válido, y la descompresión automática de Dart reventaba con
/// `FormatException: Filter error, bad data`. Con esto Dart nunca intenta
/// descomprimir; además pedimos el cuerpo sin comprimir vía el header
/// `Accept-Encoding: identity` (ver `ApiClient._headers`).

@ProviderFor(httpClient)
final httpClientProvider = HttpClientProvider._();

/// Cliente HTTP compartido (core). `keepAlive`: singleton de sesión.
///
/// Se construye sobre un `HttpClient` con `autoUncompress = false`: algunos
/// back-ends/proxies responden con `Content-Encoding: gzip` pero un cuerpo que
/// NO es un gzip válido, y la descompresión automática de Dart reventaba con
/// `FormatException: Filter error, bad data`. Con esto Dart nunca intenta
/// descomprimir; además pedimos el cuerpo sin comprimir vía el header
/// `Accept-Encoding: identity` (ver `ApiClient._headers`).

final class HttpClientProvider
    extends $FunctionalProvider<http.Client, http.Client, http.Client>
    with $Provider<http.Client> {
  /// Cliente HTTP compartido (core). `keepAlive`: singleton de sesión.
  ///
  /// Se construye sobre un `HttpClient` con `autoUncompress = false`: algunos
  /// back-ends/proxies responden con `Content-Encoding: gzip` pero un cuerpo que
  /// NO es un gzip válido, y la descompresión automática de Dart reventaba con
  /// `FormatException: Filter error, bad data`. Con esto Dart nunca intenta
  /// descomprimir; además pedimos el cuerpo sin comprimir vía el header
  /// `Accept-Encoding: identity` (ver `ApiClient._headers`).
  HttpClientProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'httpClientProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$httpClientHash();

  @$internal
  @override
  $ProviderElement<http.Client> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  http.Client create(Ref ref) {
    return httpClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(http.Client value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<http.Client>(value),
    );
  }
}

String _$httpClientHash() => r'1b320f95d4d9d3b2ec5289bc264d15218fb71263';
