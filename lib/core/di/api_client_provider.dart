import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/api_client.dart';
import 'http_client_provider.dart';
import 'token_storage_provider.dart';

part 'api_client_provider.g.dart';

/// Cliente de la API (core), con Bearer token. `keepAlive`: singleton.
@Riverpod(keepAlive: true)
ApiClient apiClient(ApiClientRef ref) => ApiClient(
      ref.watch(httpClientProvider),
      ref.watch(tokenStorageProvider),
    );
