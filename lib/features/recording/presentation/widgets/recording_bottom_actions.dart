import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../sync/presentation/screens/processing_screen.dart';
import '../providers/recording_provider.dart';
import 'project_sheet.dart';

/// Botonera inferior (detener / subir / reintentar). Antes `_BottomActions`.
class RecordingBottomActions extends StatelessWidget {
  final RecordingViewModel vm;
  const RecordingBottomActions({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          if (vm.isRecording)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.recordingRed,
                ),
                onPressed: vm.stopRecording,
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
          if (vm.hasRecording || vm.isUploading) ...[
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: vm.isUploading
                    ? null
                    : () {
                        if (vm.selectedProyecto == null) {
                          showProjectSheet(context, vm);
                          return;
                        }
                        vm.upload(
                          onUploaded: (id) => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProcessingScreen(grabacionId: id),
                            ),
                          ),
                        );
                      },
                child: vm.isUploading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
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
          if (!vm.isRecording && !vm.isUploading)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: vm.retry,
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
