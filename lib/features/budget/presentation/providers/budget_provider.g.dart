// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$budgetGrandTotalHash() => r'c7017cc601cf788d31b075edd359c5bb65e7e0f4';

/// Provider para el grand total actualizado en tiempo real
///
/// Copied from [budgetGrandTotal].
@ProviderFor(budgetGrandTotal)
final budgetGrandTotalProvider = AutoDisposeProvider<double>.internal(
  budgetGrandTotal,
  name: r'budgetGrandTotalProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetGrandTotalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BudgetGrandTotalRef = AutoDisposeProviderRef<double>;
String _$budgetMaterialsSubtotalHash() =>
    r'984f2cbcf626790a4a91e591b412ad747ab46077';

/// Provider para el subtotal de materiales
///
/// Copied from [budgetMaterialsSubtotal].
@ProviderFor(budgetMaterialsSubtotal)
final budgetMaterialsSubtotalProvider = AutoDisposeProvider<double>.internal(
  budgetMaterialsSubtotal,
  name: r'budgetMaterialsSubtotalProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetMaterialsSubtotalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BudgetMaterialsSubtotalRef = AutoDisposeProviderRef<double>;
String _$budgetContingencyAmountHash() =>
    r'3d0d6f112b6a5fb28cac246180d6d26aecc281c2';

/// Provider para el monto de contingencia
///
/// Copied from [budgetContingencyAmount].
@ProviderFor(budgetContingencyAmount)
final budgetContingencyAmountProvider = AutoDisposeProvider<double>.internal(
  budgetContingencyAmount,
  name: r'budgetContingencyAmountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetContingencyAmountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BudgetContingencyAmountRef = AutoDisposeProviderRef<double>;
String _$budgetMaterialLinesHash() =>
    r'fd35df49caebe2b058d684d54d6b939f61dad240';

/// Provider para la lista de líneas (para lista de materiales)
///
/// Copied from [budgetMaterialLines].
@ProviderFor(budgetMaterialLines)
final budgetMaterialLinesProvider =
    AutoDisposeProvider<List<EstimateLine>>.internal(
  budgetMaterialLines,
  name: r'budgetMaterialLinesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetMaterialLinesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BudgetMaterialLinesRef = AutoDisposeProviderRef<List<EstimateLine>>;
String _$budgetNotifierHash() => r'309b634b9b9ba16342efdfa78234978e98cfc8ad';

/// Notifier que gestiona el estado del presupuesto final.
///
/// Principios clave:
/// - Inmutabilidad: cada cambio genera un nuevo [BudgetState]
/// - Reactividad: Riverpod propaga los cambios automáticamente
/// - Responsabilidad única: solo calcula y exporta presupuestos
///
/// Copied from [BudgetNotifier].
@ProviderFor(BudgetNotifier)
final budgetNotifierProvider =
    AutoDisposeNotifierProvider<BudgetNotifier, BudgetState>.internal(
  BudgetNotifier.new,
  name: r'budgetNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BudgetNotifier = AutoDisposeNotifier<BudgetState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
