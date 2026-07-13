// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Base de datos local (sqflite). `keepAlive`: singleton de sesión.

@ProviderFor(localDatabase)
final localDatabaseProvider = LocalDatabaseProvider._();

/// Base de datos local (sqflite). `keepAlive`: singleton de sesión.

final class LocalDatabaseProvider
    extends $FunctionalProvider<LocalDatabase, LocalDatabase, LocalDatabase>
    with $Provider<LocalDatabase> {
  /// Base de datos local (sqflite). `keepAlive`: singleton de sesión.
  LocalDatabaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'localDatabaseProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$localDatabaseHash();

  @$internal
  @override
  $ProviderElement<LocalDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalDatabase create(Ref ref) {
    return localDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalDatabase>(value),
    );
  }
}

String _$localDatabaseHash() => r'dedd3dccd5700b8c3950e49449decd7a6319eb9b';
