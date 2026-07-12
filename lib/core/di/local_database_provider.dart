import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/local_database.dart';

part 'local_database_provider.g.dart';

/// Base de datos local (sqflite). `keepAlive`: singleton de sesión.
@Riverpod(keepAlive: true)
LocalDatabase localDatabase(LocalDatabaseRef ref) => LocalDatabase();
