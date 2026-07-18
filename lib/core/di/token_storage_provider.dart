import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/token_storage.dart';

part 'token_storage_provider.g.dart';

/// Almacenamiento del token de sesión (core). `keepAlive`: singleton.
@Riverpod(keepAlive: true)
TokenStorage tokenStorage(Ref ref) => TokenStorage();
