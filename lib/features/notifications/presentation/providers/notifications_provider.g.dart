// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationsHash() => r'c125ad52ece587069730046de827e8b1fab11fed';

/// Notifier de notificaciones (Riverpod moderno). Reemplaza al
/// `NotificationsViewModel` (ChangeNotifier).
///
/// Copied from [Notifications].
@ProviderFor(Notifications)
final notificationsProvider =
    AutoDisposeNotifierProvider<Notifications, NotificationsState>.internal(
  Notifications.new,
  name: r'notificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Notifications = AutoDisposeNotifier<NotificationsState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
