import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/estimate.dart';
import '../providers/budget_provider.dart';
import '../widgets/budget_section_card.dart';
import '../widgets/budget_summary_row.dart';
import '../widgets/contingency_slider.dart';

/// Fase 7: Pantalla de Presupuesto Final
///
/// Layout:
///  ┌──────────────────────────────────┐
///  │  AppBar: Presupuesto Final       │
///  │  Chip: nombre del proyecto       │
///  ├──────────────────────────────────┤
///  │  [Sección Materiales]            │
///  │    - Lista de líneas             │
///  │    - Sliders de desperdicio      │
///  ├──────────────────────────────────┤
///  │  [Sección Mano de Obra]          │
///  ├──────────────────────────────────┤
///  │  [Sección Contingencia]          │
///  │    - Slider 5%–20%               │
///  ├──────────────────────────────────┤
///  │  [Sección Extras]                │
///  ├──────────────────────────────────┤
///  │  Resumen Financiero Total        │
///  ├──────────────────────────────────┤
///  │  [Botón Exportar PDF]            │
///  └──────────────────────────────────┘
class BudgetPage extends ConsumerStatefulWidget {
  const BudgetPage({super.key, this.projectId});

  final String? projectId;

  @override
  ConsumerState<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends ConsumerState<BudgetPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final budgetState = ref.watch(budgetNotifierProvider);
    final notifier = ref.read(budgetNotifierProvider.notifier);

    // Escucha exportación completada
    ref.listen(budgetNotifierProvider, (prev, next) {
      if (next.exportedPdfPath != null && prev?.exportedPdfPath == null) {
        _showExportSuccessSnackBar(context);
      }
      if (next.hasError && !prev!.hasError) {
        _showErrorSnackBar(context, next.errorMessage!);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: budgetState.isLoading
          ? const _LoadingView()
          : budgetState.estimate == null
              ? const _EmptyView()
              : _buildContent(context, budgetState, notifier),
    );
  }

  Widget _buildContent(
    BuildContext context,
    BudgetState state,
    BudgetNotifier notifier,
  ) {
    final estimate = state.estimate!;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── SliverAppBar con gradiente ───
          _BudgetSliverAppBar(projectName: estimate.projectName),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),

                // ─── SECCIÓN 1: MATERIALES ───
                _MaterialsSection(
                  lines: estimate.materialLines,
                  onWasteChanged: notifier.onWastePercentChanged,
                ),

                const SizedBox(height: 16),

                // ─── SECCIÓN 2: MANO DE OBRA ───
                BudgetSectionCard(
                  title: 'Mano de Obra',
                  totalAmount: estimate.laborCost.toMXN,
                  icon: Icons.engineering_outlined,
                  accentColor: AppColors.accent,
                  children: [
                    BudgetSummaryRow(
                      label: 'Instalación general',
                      value: estimate.laborCost.toMXN,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tarifa estimada según zona y tipo de trabajo',
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ─── SECCIÓN 3: CONTINGENCIA ───
                BudgetSectionCard(
                  title: 'Contingencia',
                  totalAmount: estimate.contingencyAmount.toMXN,
                  icon: Icons.shield_outlined,
                  accentColor: _contingencyColor(estimate.contingencyPercent),
                  children: [
                    ContingencySlider(
                      value: estimate.contingencyPercent,
                      onChanged: notifier.onContingencyChanged,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'La contingencia cubre imprevistos en materiales y mano de obra.',
                      style: AppTypography.textTheme.bodySmall,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ─── SECCIÓN 4: EXTRAS ───
                BudgetSectionCard(
                  title: 'Extras',
                  totalAmount: estimate.extrasAmount.toMXN,
                  icon: Icons.add_circle_outline,
                  accentColor: AppColors.textSecondary,
                  children: [
                    BudgetSummaryRow(
                      label: 'Herramientas y traslados',
                      value: estimate.extrasAmount.toMXN,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ─── RESUMEN TOTAL ───
                _FinancialSummaryCard(estimate: estimate),

                const SizedBox(height: 24),

                // ─── BOTÓN EXPORTAR PDF ───
                ExportPdfButton(
                  isLoading: state.isExporting,
                  isExported: state.exportedPdfPath != null,
                  onTap: notifier.exportToPdf,
                ),

                const SizedBox(height: 12),

                // Nota legal
                Text(
                  'Precios referenciales. Sujetos a variación del mercado.',
                  textAlign: TextAlign.center,
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Color _contingencyColor(double percent) {
    if (percent <= 8) return AppColors.success;
    if (percent <= 14) return AppColors.warning;
    return AppColors.error;
  }

  void _showExportSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 20),
            const SizedBox(width: 10),
            Text(
              'PDF generado exitosamente',
              style: AppTypography.textTheme.bodyMedium
                  ?.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
        backgroundColor: AppColors.bgElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

// ============================================================
// SUB-WIDGETS PRIVADOS
// ============================================================

/// SliverAppBar con gradiente y nombre del proyecto
class _BudgetSliverAppBar extends StatelessWidget {
  const _BudgetSliverAppBar({required this.projectName});

  final String projectName;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: AppColors.bgDark,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0D1520),
                AppColors.bgDark,
              ],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 80, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Presupuesto Final',
                style: AppTypography.textTheme.displaySmall,
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppColors.primary.withOpacity(0.3), width: 0.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.folder_outlined,
                      size: 13,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      projectName,
                      style: AppTypography.textTheme.labelMedium
                          ?.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      leading: IconButton(
        icon: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: const Icon(Icons.arrow_back_ios_new,
              size: 16, color: AppColors.textPrimary),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: const Icon(Icons.share_outlined,
                  size: 18, color: AppColors.textPrimary),
            ),
            onPressed: () {
              // TODO: Compartir presupuesto
            },
          ),
        ),
      ],
    );
  }
}

/// Sección de materiales con lista y sliders de desperdicio
class _MaterialsSection extends StatefulWidget {
  const _MaterialsSection({
    required this.lines,
    required this.onWasteChanged,
  });

  final List<EstimateLine> lines;
  final void Function(String lineId, double percent) onWasteChanged;

  @override
  State<_MaterialsSection> createState() => _MaterialsSectionState();
}

class _MaterialsSectionState extends State<_MaterialsSection> {
  bool _showWasteSliders = false;

  double get _total =>
      widget.lines.fold(0.0, (sum, l) => sum + l.subtotal);

  @override
  Widget build(BuildContext context) {
    return BudgetSectionCard(
      title: 'Materiales',
      totalAmount: _total.toMXN,
      icon: Icons.inventory_2_outlined,
      accentColor: AppColors.primary,
      trailing: TextButton(
        onPressed: () =>
            setState(() => _showWasteSliders = !_showWasteSliders),
        child: Text(
          _showWasteSliders ? 'Ocultar' : 'Ajustar desperdicio',
          style: AppTypography.textTheme.labelSmall
              ?.copyWith(color: AppColors.primary),
        ),
      ),
      children: [
        // Lista de materiales
        ...widget.lines.map((line) => Column(
              children: [
                MaterialLineRow(
                  materialName: line.materialName,
                  quantity: line.effectiveQuantity.toStringAsFixed(2),
                  unit: line.unit,
                  unitPrice: line.unitPrice.toMXN,
                  subtotal: line.subtotal.toMXN,
                  supplierName: line.supplierName,
                  isPriceFromCache: line.isPriceFromCache,
                  wastePercent: line.wastePercent.toStringAsFixed(0),
                ),
                if (widget.lines.last != line)
                  const Divider(height: 1, color: AppColors.divider),
              ],
            )),

        // Sliders de desperdicio (expandibles)
        if (_showWasteSliders) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ajustar % de desperdicio',
                  style: AppTypography.textTheme.titleSmall?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                ...widget.lines.map((line) => WastePercentSlider(
                      materialName: line.materialName,
                      value: line.wastePercent,
                      onChanged: (v) =>
                          widget.onWasteChanged(line.id, v),
                    )),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Tarjeta de resumen financiero total con totales animados
class _FinancialSummaryCard extends StatelessWidget {
  const _FinancialSummaryCard({required this.estimate});

  final Estimate estimate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0E1A14), Color(0xFF0A1510)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Resumen Financiero',
                style: AppTypography.textTheme.titleLarge
                    ?.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BudgetSummaryRow(
            label: 'Materiales',
            value: estimate.materialsSubtotal.toMXN,
            showDivider: true,
          ),
          BudgetSummaryRow(
            label: 'Mano de obra',
            value: estimate.laborCost.toMXN,
            showDivider: true,
          ),
          BudgetSummaryRow(
            label: 'Contingencia (${estimate.contingencyPercent.toStringAsFixed(0)}%)',
            value: estimate.contingencyAmount.toMXN,
            valueColor: _contingencyColor(estimate.contingencyPercent),
            showDivider: true,
          ),
          BudgetSummaryRow(
            label: 'Extras',
            value: estimate.extrasAmount.toMXN,
            showDivider: true,
          ),
          const SizedBox(height: 8),
          // Total sin IVA
          BudgetSummaryRow(
            label: 'Subtotal (sin IVA)',
            value: estimate.grandTotal.toMXN,
            isTotal: false,
            showDivider: true,
          ),
          // IVA
          BudgetSummaryRow(
            label: 'IVA 16%',
            value: estimate.ivaAmount.toMXN,
            valueColor: AppColors.textSecondary,
            showDivider: true,
          ),
          const SizedBox(height: 4),
          // TOTAL GENERAL — highlight máximo
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppColors.primary.withOpacity(0.3), width: 0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL GENERAL',
                      style: AppTypography.textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'IVA incluido',
                      style: AppTypography.textTheme.bodySmall,
                    ),
                  ],
                ),
                // Valor animado
                _AnimatedAmount(value: estimate.grandTotalWithIva),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _contingencyColor(double percent) {
    if (percent <= 8) return AppColors.success;
    if (percent <= 14) return AppColors.warning;
    return AppColors.error;
  }
}

/// Monto grande que anima cuando cambia (contingencia / waste slider)
class _AnimatedAmount extends StatefulWidget {
  const _AnimatedAmount({required this.value});
  final double value;

  @override
  State<_AnimatedAmount> createState() => _AnimatedAmountState();
}

class _AnimatedAmountState extends State<_AnimatedAmount>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  double _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void didUpdateWidget(_AnimatedAmount old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _previousValue = old.value;
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final displayed =
            _previousValue + (_anim.value * (widget.value - _previousValue));
        return Text(
          displayed.toMXN,
          style: AppTypography.textTheme.displaySmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        );
      },
    );
  }
}

/// Vista de carga
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
          SizedBox(height: 16),
          Text(
            'Calculando presupuesto...',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Vista vacía
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 64, color: AppColors.textHint),
          SizedBox(height: 16),
          Text(
            'Sin presupuesto disponible',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
