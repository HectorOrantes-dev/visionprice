import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../budget/presentation/screens/parameters_review_screen.dart';

class ProcessingScreen extends StatelessWidget {
  const ProcessingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProcessingAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _TranscriptionCard(),
                    const SizedBox(height: 20),
                    _SectionLabel('PASOS DE PROCESAMIENTO'),
                    const SizedBox(height: 12),
                    _ProcessStep(
                      icon: Icons.check_circle,
                      title: 'Transcribiendo audio',
                      subtitle: 'Completado · 0:32 procesados',
                      state: _StepState.done,
                    ),
                    const SizedBox(height: 8),
                    _ProcessStep(
                      icon: Icons.settings,
                      title: 'Interpretando descripción',
                      subtitle: 'LLM extrayendo entidades constructivas...',
                      state: _StepState.inProgress,
                    ),
                    const SizedBox(height: 8),
                    _ProcessStep(
                      icon: Icons.calculate_outlined,
                      title: 'Calculando materiales',
                      subtitle: 'En espera',
                      state: _StepState.waiting,
                    ),
                    const SizedBox(height: 24),
                    _TimeEstimateCard(),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Puedes cerrar esta pantalla · notificación al completar',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ParametersReviewScreen()),
                        ),
                        child: const Text('Ver resultados (demo)'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProcessingAppBar extends StatelessWidget {
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
            child: const Icon(Icons.settings, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Procesando',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Análisis de tu descripción',
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

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 1.0,
      ),
    );
  }
}

class _TranscriptionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel('TRANSCRIPCIÓN DEL AUDIO'),
          const SizedBox(height: 12),
          const Text(
            '"Necesito tirar firme en una bodega de diez por ocho metros, aproximadamente, y también revoque en las cuatro paredes. Ah, y seis castillos de amarre."',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

enum _StepState { done, inProgress, waiting }

class _ProcessStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final _StepState state;

  const _ProcessStep({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: state == _StepState.inProgress
                ? const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.primary,
                    ),
                  )
                : Icon(icon, size: 18, color: _iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: state == _StepState.waiting
                        ? AppColors.textHint
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color get _iconBg {
    switch (state) {
      case _StepState.done:
        return AppColors.successLight;
      case _StepState.inProgress:
        return AppColors.primaryLight;
      case _StepState.waiting:
        return AppColors.surfaceVariant;
    }
  }

  Color get _iconColor {
    switch (state) {
      case _StepState.done:
        return AppColors.success;
      case _StepState.inProgress:
        return AppColors.primary;
      case _StepState.waiting:
        return AppColors.textHint;
    }
  }
}

class _TimeEstimateCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            'Tiempo estimado restante',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '~25 segundos',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
