import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../recording/presentation/providers/processing_provider.dart';
import '../../../budget/presentation/screens/parameters_review_screen.dart';

class ProcessingScreen extends StatelessWidget {
  final int grabacionId;
  const ProcessingScreen({super.key, required this.grabacionId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<ProcessingViewModel>()..start(grabacionId),
      child: _ProcessingView(grabacionId: grabacionId),
    );
  }
}

class _ProcessingView extends StatelessWidget {
  final int grabacionId;
  const _ProcessingView({required this.grabacionId});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProcessingViewModel>();
    final transcripcion = vm.grabacion?.transcripcion;
    final tieneTranscripcion = vm.grabacion?.tieneTranscripcion ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProcessingAppBar(hasError: vm.hasError, isDone: vm.isDone),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _TranscriptionCard(
                      transcripcion: transcripcion,
                      loading: !tieneTranscripcion && !vm.hasError,
                    ),
                    const SizedBox(height: 20),
                    _SectionLabel('PASOS DE PROCESAMIENTO'),
                    const SizedBox(height: 12),
                    _ProcessStep(
                      icon: Icons.check_circle,
                      title: 'Transcribiendo audio',
                      subtitle: tieneTranscripcion
                          ? 'Completado'
                          : 'Transcribiendo el audio...',
                      state: tieneTranscripcion
                          ? _StepState.done
                          : _StepState.inProgress,
                    ),
                    const SizedBox(height: 8),
                    _ProcessStep(
                      icon: Icons.settings,
                      title: 'Interpretando descripción',
                      subtitle: vm.isDone
                          ? 'Completado'
                          : (tieneTranscripcion
                              ? 'Extrayendo entidades constructivas...'
                              : 'En espera'),
                      state: vm.isDone
                          ? _StepState.done
                          : (tieneTranscripcion
                              ? _StepState.inProgress
                              : _StepState.waiting),
                    ),
                    const SizedBox(height: 8),
                    _ProcessStep(
                      icon: Icons.calculate_outlined,
                      title: 'Listo para calcular',
                      subtitle: vm.isDone ? 'Completado' : 'En espera',
                      state:
                          vm.isDone ? _StepState.done : _StepState.waiting,
                    ),
                    const SizedBox(height: 24),
                    if (vm.hasError)
                      _ErrorCard()
                    else
                      _StatusCard(isDone: vm.isDone, confianza: vm.grabacion?.confianza),
                    const SizedBox(height: 16),
                    if (!vm.isDone && !vm.hasError)
                      Center(
                        child: Text(
                          'Sondeando cada 4 s · puedes esperar aquí',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    if (vm.hasError)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Reintentar grabación'),
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: vm.isDone
                              ? () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ParametersReviewScreen(
                                        grabacionId: grabacionId,
                                      ),
                                    ),
                                  )
                              : null,
                          child: const Text('Ver resultados'),
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
  final bool hasError;
  final bool isDone;
  const _ProcessingAppBar({required this.hasError, required this.isDone});

  @override
  Widget build(BuildContext context) {
    final subtitle = hasError
        ? 'Ocurrió un error'
        : (isDone ? 'Análisis completado' : 'Análisis de tu descripción');
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Procesando',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
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
  final String? transcripcion;
  final bool loading;
  const _TranscriptionCard({this.transcripcion, required this.loading});

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
          if (loading)
            Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Text(
                  'Esperando transcripción...',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            )
          else
            Text(
              transcripcion == null || transcripcion!.isEmpty
                  ? 'Sin transcripción'
                  : '"$transcripcion"',
              style: const TextStyle(
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

class _StatusCard extends StatelessWidget {
  final bool isDone;
  final double? confianza;
  const _StatusCard({required this.isDone, this.confianza});

  @override
  Widget build(BuildContext context) {
    final pct = confianza != null ? '${(confianza! * 100).round()}%' : null;
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
            isDone ? 'Estado' : 'Procesando',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            isDone
                ? (pct != null ? 'Listo · confianza $pct' : 'Sincronizado')
                : '~ unos segundos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDone ? AppColors.success : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'El procesamiento falló. Vuelve a intentar la grabación.',
              style: TextStyle(fontSize: 13, color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
