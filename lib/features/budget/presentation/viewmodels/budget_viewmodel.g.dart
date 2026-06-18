// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$budgetGrandTotalHash() => r'43cc1b9113cf007cc864e3566c282b3a0031efc3';

/// See also [budgetGrandTotal].
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
    r'0b5030b5577a982a7d1d4bc419e0dc1eec32be3f';

/// See also [budgetMaterialsSubtotal].
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
    r'0643e6a0977a490e24ad3e81ed75a675292bd391';

/// See also [budgetContingencyAmount].
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
    r'a8e1243fc5ac1ad51a6c6dc75e9978a1c8aa86cd';

/// See also [budgetMaterialLines].
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
String _$budgetViewModelHash() => r'515fe5fa11aaa50f424d10d4991bb9b386fdb23d';

/// ViewModel del presupuesto — migrado desde BudgetNotifier (Riverpod provider).
///
/// Ahora obtiene los use cases reales desde GetIt en lugar de TODOs.
///
/// Copied from [BudgetViewModel].
@ProviderFor(BudgetViewModel)
final budgetViewModelProvider =
    AutoDisposeNotifierProvider<BudgetViewModel, BudgetState>.internal(
  BudgetViewModel.new,
  name: r'budgetViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BudgetViewModel = AutoDisposeNotifier<BudgetState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
