import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../recording/presentation/providers/processing_provider.dart';
import '../../../budget/presentation/screens/parameters_review_screen.dart';
import '../widgets/process_step.dart';
import '../widgets/processing_app_bar.dart';
import '../widgets/processing_error_card.dart';
import '../widgets/processing_section_label.dart';
import '../widgets/processing_status_card.dart';
import '../widgets/step_state.dart';
import '../widgets/transcription_card.dart';

class ProcessingScreen extends ConsumerWidget {
  final int grabacionId;
  const ProcessingScreen({super.key, required this.grabacionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(processingProvider(grabacionId));
    final transcripcion = vm.grabacion?.transcripcion;
    final tieneTranscripcion = vm.grabacion?.tieneTranscripcion ?? false;
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProcessingAppBar(hasError: vm.hasError, isDone: vm.isDone),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    TranscriptionCard(
                      transcripcion: transcripcion,
                      // El spinner solo mientras el sondeo sigue vivo: se
                      // apaga cuando llega la transcripción, hay error,
                      // termina (aunque venga vacía) o se agota el tope.
                      loading: !tieneTranscripcion &&
                          !vm.hasError &&
                          !vm.isDone &&
                          !vm.timedOut,
                    ),
                    const SizedBox(height: 20),
                    const ProcessingSectionLabel('PASOS DE PROCESAMIENTO'),
                    const SizedBox(height: 12),
                    ProcessStep(
                      icon: Icons.check_circle,
                      title: 'Transcribiendo audio',
                      subtitle: tieneTranscripcion
                          ? 'Completado'
                          : 'Transcribiendo el audio...',
                      state: tieneTranscripcion
                          ? ProcessStepState.done
                          : ProcessStepState.inProgress,
                    ),
                    const SizedBox(height: 8),
                    ProcessStep(
                      icon: Icons.settings,
                      title: 'Interpretando descripción',
                      subtitle: vm.isDone
                          ? 'Completado'
                          : (tieneTranscripcion
                              ? 'Extrayendo entidades constructivas...'
                              : 'En espera'),
                      state: vm.isDone
                          ? ProcessStepState.done
                          : (tieneTranscripcion
                              ? ProcessStepState.inProgress
                              : ProcessStepState.waiting),
                    ),
                    const SizedBox(height: 8),
                    ProcessStep(
                      icon: Icons.calculate_outlined,
                      title: 'Listo para calcular',
                      subtitle: vm.isDone ? 'Completado' : 'En espera',
                      state: vm.isDone
                          ? ProcessStepState.done
                          : ProcessStepState.waiting,
                    ),
                    const SizedBox(height: 24),
                    if (vm.hasError)
                      const ProcessingErrorCard()
                    else
                      ProcessingStatusCard(
                          isDone: vm.isDone,
                          confianza: vm.grabacion?.confianza),
                    const SizedBox(height: 16),
                    if (!vm.isDone && !vm.hasError)
                      Center(
                        child: Text(
                          vm.timedOut
                              ? 'Sigue procesando. Vuelve más tarde para ver el resultado.'
                              : 'Sondeando cada 4 s · puedes esperar aquí',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.colors.textSecondary,
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
