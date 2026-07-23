import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../account/presentation/screens/plan_paywall_screen.dart';
import '../../../sync/presentation/screens/processing_screen.dart';
import '../providers/recording_provider.dart';
import 'project_sheet.dart';

/// Botonera inferior de la grabación: detener, subir/procesar y reintentar.
/// Antes el privado `_BottomActions`.
class BottomActions extends ConsumerWidget {
  final RecordingState state;
  final Recording notifier;
  const BottomActions({super.key, required this.state, required this.notifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          if (state.isRecording)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.recordingRed,
                ),
                onPressed: notifier.stopRecording,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.stop, size: 18),
                    SizedBox(width: 8),
                    Text('Detener grabación'),
                  ],
                ),
              ),
            ),
          if (state.hasRecording || state.isUploading) ...[
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: state.isUploading
                    ? null
                    : () async {
                        if (state.selectedProyecto == null) {
                          ProjectSheet.show(context);
                          return;
                        }
                        await notifier.upload(
                          onUploaded: (id) {
                            if (id == -1) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Guardado localmente. Se subirá al conectarse a internet.'),
                                  backgroundColor: context.colors.primary,
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProcessingScreen(grabacionId: id),
                                ),
                              );
                            }
                          },
                        );
                        // Audio no tiene cuota gratis: 402 (`plan_required`)
                        // significa que hace falta suscripción activa.
                        if (!context.mounted) return;
                        final fresco = ref.read(recordingProvider);
                        if (fresco.esPagoRequerido) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlanPaywallScreen(
                                code: fresco.errorCode,
                                message: fresco.errorMessage ?? '',
                              ),
                            ),
                          );
                        }
                      },
                child: state.isUploading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: state.uploadProgress,
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.3),
                                color: Colors.white,
                                minHeight: 4,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${(state.uploadProgress * 100).toInt()}%',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Subir y procesar'),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          if (!state.isRecording && !state.isUploading)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: notifier.retry,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.replay, size: 18),
                    SizedBox(width: 8),
                    Text('Reintentar grabación'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
