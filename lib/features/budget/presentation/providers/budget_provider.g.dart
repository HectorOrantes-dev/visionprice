// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$budgetNotifierHash() => r'budget_notifier_hash_placeholder';

/// Notifier principal del presupuesto
///
/// Copied from [BudgetNotifier].
@ProviderFor(BudgetNotifier)
final budgetNotifierProvider =
    AutoDisposeNotifierProvider<BudgetNotifier, BudgetState>.internal(
  BudgetNotifier.new,
  name: r'budgetNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$budgetNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BudgetNotifier = AutoDisposeNotifier<BudgetState>;

String _$budgetGrandTotalHash() => r'budget_grand_total_hash_placeholder';

/// Provider del total general
///
/// Copied from [budgetGrandTotal].
@ProviderFor(budgetGrandTotal)
final budgetGrandTotalProvider = AutoDisposeProvider<double>.internal(
  budgetGrandTotal,
  name: r'budgetGrandTotalProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$budgetGrandTotalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BudgetGrandTotalRef = AutoDisposeProviderRef<double>;

String _$budgetMaterialsSubtotalHash() =>
    r'budget_materials_subtotal_hash_placeholder';

/// Provider del subtotal de materiales
///
/// Copied from [budgetMaterialsSubtotal].
@ProviderFor(budgetMaterialsSubtotal)
final budgetMaterialsSubtotalProvider = AutoDisposeProvider<double>.internal(
  budgetMaterialsSubtotal,
  name: r'budgetMaterialsSubtotalProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$budgetMaterialsSubtotalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BudgetMaterialsSubtotalRef = AutoDisposeProviderRef<double>;

String _$budgetContingencyAmountHash() =>
    r'budget_contingency_amount_hash_placeholder';

/// Provider del monto de contingencia
///
/// Copied from [budgetContingencyAmount].
@ProviderFor(budgetContingencyAmount)
final budgetContingencyAmountProvider = AutoDisposeProvider<double>.internal(
  budgetContingencyAmount,
  name: r'budgetContingencyAmountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$budgetContingencyAmountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BudgetContingencyAmountRef = AutoDisposeProviderRef<double>;

String _$budgetMaterialLinesHash() =>
    r'budget_material_lines_hash_placeholder';

/// Provider de la lista de líneas de materiales
///
/// Copied from [budgetMaterialLines].
@ProviderFor(budgetMaterialLines)
final budgetMaterialLinesProvider =
    AutoDisposeProvider<List<EstimateLine>>.internal(
  budgetMaterialLines,
  name: r'budgetMaterialLinesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$budgetMaterialLinesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BudgetMaterialLinesRef = AutoDisposeProviderRef<List<EstimateLine>>;
