import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/connectivity_service.dart';
import 'api_client_provider.dart';

part 'connectivity_service_provider.g.dart';

/// Servicio de conectividad real (ping al back-end). `keepAlive`: singleton.
@Riverpod(keepAlive: true)
ConnectivityService connectivityService(ConnectivityServiceRef ref) =>
    ConnectivityService(ref.watch(apiClientProvider));
