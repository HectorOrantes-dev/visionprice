// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// AsyncNotifier de la lista de notificaciones. `build()` carga la lista y
/// Riverpod la expone como `AsyncValue<List<NotificacionEntity>>`. La UI la
/// consume con `.when()`.

@ProviderFor(Notifications)
final notificationsProvider = NotificationsProvider._();

/// AsyncNotifier de la lista de notificaciones. `build()` carga la lista y
/// Riverpod la expone como `AsyncValue<List<NotificacionEntity>>`. La UI la
/// consume con `.when()`.
final class NotificationsProvider
    extends $AsyncNotifierProvider<Notifications, List<NotificacionEntity>> {
  /// AsyncNotifier de la lista de notificaciones. `build()` carga la lista y
  /// Riverpod la expone como `AsyncValue<List<NotificacionEntity>>`. La UI la
  /// consume con `.when()`.
  NotificationsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'notificationsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notificationsHash();

  @$internal
  @override
  Notifications create() => Notifications();
}

String _$notificationsHash() => r'c06f51c3a2869eff1f5b21b0ec6a2c2577f5268d';

/// AsyncNotifier de la lista de notificaciones. `build()` carga la lista y
/// Riverpod la expone como `AsyncValue<List<NotificacionEntity>>`. La UI la
/// consume con `.when()`.

abstract class _$Notifications
    extends $AsyncNotifier<List<NotificacionEntity>> {
  FutureOr<List<NotificacionEntity>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<List<NotificacionEntity>>, List<NotificacionEntity>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<NotificacionEntity>>,
            List<NotificacionEntity>>,
        AsyncValue<List<NotificacionEntity>>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
