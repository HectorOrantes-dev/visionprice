import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'nearby_stores_screen.dart';

class ParametersReviewScreen extends StatelessWidget {
  const ParametersReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _ReviewAppBar(),
            _LowConfidenceBanner(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  _ActivityItem(
                    icon: Icons.layers_outlined,
                    title: 'Firme de concreto',
                    detail: '80 m² · f\'c 150 kg/cm²',
                    confidence: _Confidence.high,
                  ),
                  SizedBox(height: 8),
                  _ActivityItem(
                    icon: Icons.square_outlined,
                    title: 'Revoque de muros',
                    detail: '~8 m² · ⚠️ revisar',
                    confidence: _Confidence.low,
                    note: 'Baja confianza — confirma la cantidad',
                  ),
                  SizedBox(height: 8),
                  _ActivityItem(
                    icon: Icons.view_column_outlined,
                    title: 'Castillos de amarre',
                    detail: '6 piezas · varilla 3/8"',
                    confidence: _Confidence.high,
                  ),
                  SizedBox(height: 16),
                  _AddActivityButton(),
                ],
              ),
            ),
            _ConfirmButton(),
          ],
        ),
      ),
    );
  }
}

class _ReviewAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                size: 18, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.edit_note,
                color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Esto es lo que dijiste?',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Revisa antes de calcular',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LowConfidenceBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_outlined,
              size: 16, color: AppColors.warning),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {},
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 13),
                children: [
                  TextSpan(
                    text: '1 campo con baja confianza',
                    style: TextStyle(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: ' — toca para corregir',
                    style: TextStyle(color: AppColors.warning),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _Confidence { high, low }

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;
  final _Confidence confidence;
  final String? note;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.detail,
    required this.confidence,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    final isLow = confidence == _Confidence.low;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLow
              ? AppColors.warning.withValues(alpha: 0.4)
              : AppColors.border,
          width: isLow ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isLow ? AppColors.warningLight : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon,
                size: 20,
                color: isLow ? AppColors.warning : AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isLow ? AppColors.warning : AppColors.primary,
                  ),
                ),
                if (note != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    note!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.warning,
                    ),
                  ),
                ],
                if (confidence == _Confidence.high)
                  const Text(
                    '✓ Alta confianza',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.success,
                    ),
                  ),
              ],
            ),
          ),
          const Icon(Icons.edit_outlined,
              size: 18, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _AddActivityButton extends StatelessWidget {
  const _AddActivityButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 18, color: AppColors.primary),
            SizedBox(width: 8),
            Text(
              'Agregar actividad',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const NearbyStoresScreen()),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_forward, size: 18),
              SizedBox(width: 8),
              Text('Confirmar y calcular materiales'),
            ],
          ),
        ),
      ),
    );
  }
}
