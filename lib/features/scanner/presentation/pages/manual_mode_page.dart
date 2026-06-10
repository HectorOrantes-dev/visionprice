import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Modo Manual — calculadora de superficies como plan de contingencia
class ManualModePage extends StatefulWidget {
  const ManualModePage({super.key});

  @override
  State<ManualModePage> createState() => _ManualModePageState();
}

class _ManualModePageState extends State<ManualModePage> {
  final _widthCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  double? _area;

  void _calculate() {
    final w = double.tryParse(_widthCtrl.text.replaceAll(',', '.'));
    final h = double.tryParse(_heightCtrl.text.replaceAll(',', '.'));
    if (w != null && h != null) {
      setState(() => _area = w * h);
    }
  }

  @override
  void dispose() {
    _widthCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        title: const Text('Modo Manual'),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Calculadora de Superficie',
                style: AppTypography.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Ingresa las medidas manualmente para calcular el área',
                style: AppTypography.textTheme.bodyMedium,
              ),
              const SizedBox(height: 36),

              // Ancho
              Text('Ancho (metros)',
                  style: AppTypography.textTheme.titleSmall
                      ?.copyWith(color: AppColors.primary)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _widthCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: AppTypography.textTheme.bodyLarge,
                decoration: const InputDecoration(
                  hintText: 'Ej. 3.50',
                  suffixText: 'm',
                  prefixIcon: Icon(Icons.swap_horiz, color: AppColors.textHint),
                ),
              ),
              const SizedBox(height: 20),

              // Alto
              Text('Alto / Largo (metros)',
                  style: AppTypography.textTheme.titleSmall
                      ?.copyWith(color: AppColors.primary)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _heightCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: AppTypography.textTheme.bodyLarge,
                decoration: const InputDecoration(
                  hintText: 'Ej. 4.20',
                  suffixText: 'm',
                  prefixIcon: Icon(Icons.swap_vert, color: AppColors.textHint),
                ),
              ),
              const SizedBox(height: 32),

              // Resultado
              if (_area != null)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.square_foot,
                          color: AppColors.primary, size: 32),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Área calculada',
                              style: AppTypography.textTheme.bodySmall),
                          Text(
                            '${_area!.toStringAsFixed(2)} m²',
                            style:
                                AppTypography.textTheme.displaySmall?.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              const Spacer(),

              ElevatedButton.icon(
                onPressed: _calculate,
                icon: const Icon(Icons.calculate_outlined),
                label: const Text('Calcular Área'),
              ),
              const SizedBox(height: 12),

              if (_area != null)
                OutlinedButton.icon(
                  onPressed: () => context.go(
                      '${AppRoutes.materials}?projectId=manual'),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Continuar con esta medida'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
