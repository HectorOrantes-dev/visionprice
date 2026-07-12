import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/location_service.dart';

part 'location_service_provider.g.dart';

/// Servicio de ubicación (core). `keepAlive`: singleton de sesión.
@Riverpod(keepAlive: true)
LocationService locationService(LocationServiceRef ref) => LocationService();
