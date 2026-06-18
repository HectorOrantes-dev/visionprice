import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/project.dart';

/// Formulario de creación de proyecto — máximo 3 campos
class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({super.key});

  @override
  State<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  WorkType _selectedType = WorkType.floor;
  String _selectedCity = 'CDMX';

  static const _cities = [
    'CDMX', 'Guadalajara', 'Monterrey', 'Puebla',
    'Tijuana', 'León', 'Juárez', 'Mérida', 'Cancún', 'Querétaro'
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _create() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: Disparar CreateProjectUseCase
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Nuevo Proyecto'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¿Qué vamos a presupuestar hoy?',
                  style: AppTypography.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Solo 3 datos para comenzar',
                  style: AppTypography.textTheme.bodyMedium,
                ),
                const SizedBox(height: 36),

                // Campo 1: Nombre del proyecto
                Text('Nombre', style: AppTypography.textTheme.titleSmall
                    ?.copyWith(color: AppColors.primary)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameCtrl,
                  style: AppTypography.textTheme.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'Ej. Baño principal, Cocina sur...',
                    prefixIcon:
                        Icon(Icons.drive_file_rename_outline, color: AppColors.textHint),
                  ),
                  validator: (v) =>
                      v != null && v.length >= 3 ? null : 'Mínimo 3 caracteres',
                ),
                const SizedBox(height: 28),

                // Campo 2: Tipo de trabajo
                Text('Tipo de trabajo', style: AppTypography.textTheme.titleSmall
                    ?.copyWith(color: AppColors.primary)),
                const SizedBox(height: 12),
                Row(
                  children: WorkType.values
                      .map((type) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: _WorkTypeChip(
                                type: type,
                                isSelected: _selectedType == type,
                                onTap: () =>
                                    setState(() => _selectedType = type),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 28),

                // Campo 3: Ciudad
                Text('Ciudad', style: AppTypography.textTheme.titleSmall
                    ?.copyWith(color: AppColors.primary)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedCity,
                  dropdownColor: AppColors.bgElevated,
                  style: AppTypography.textTheme.bodyLarge,
                  decoration: const InputDecoration(
                    prefixIcon:
                        Icon(Icons.location_city_outlined, color: AppColors.textHint),
                  ),
                  items: _cities
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedCity = v!),
                ),

                const SizedBox(height: 48),

                // CTA
                ElevatedButton.icon(
                  onPressed: _create,
                  icon: const Icon(Icons.check, size: 22),
                  label: const Text('Crear Proyecto'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkTypeChip extends StatelessWidget {
  const _WorkTypeChip({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final WorkType type;
  final bool isSelected;
  final VoidCallback onTap;

  IconData get _icon {
    switch (type) {
      case WorkType.floor:
        return Icons.view_quilt_outlined;
      case WorkType.wall:
        return Icons.vertical_distribute;
      case WorkType.ceiling:
        return Icons.roofing;
      case WorkType.mixed:
        return Icons.construction;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.15)
                : AppColors.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 1.5 : 0.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                _icon,
                color: isSelected ? AppColors.primary : AppColors.textHint,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                type.label,
                style: AppTypography.textTheme.labelSmall?.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
