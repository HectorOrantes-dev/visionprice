import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/recording_provider.dart';
import '../../../sync/presentation/screens/processing_screen.dart';
import '../widgets/audio_visualizer.dart';

class RecordingScreen extends StatelessWidget {
  const RecordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<RecordingViewModel>(),
      child: const _RecordingView(),
    );
  }
}

class _RecordingView extends StatelessWidget {
  const _RecordingView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RecordingViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _RecordingAppBar(),
            _ProjectSelector(vm: vm),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Describe el espacio y los trabajos a realizar,\ncomo si le explicaras a un compañero',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  AudioVisualizer(
                    amplitudeStream: vm.amplitudeStream,
                    isRecording: vm.isRecording,
                  ),
                  const SizedBox(height: 32),
                  _MicButton(vm: vm),
                  const SizedBox(height: 24),
                  _TimerDisplay(elapsed: vm.elapsedFormatted),
                  const SizedBox(height: 12),
                  if (vm.isRecording) _RecordingIndicator(),
                  if (vm.hasRecording)
                    const Text(
                      'Grabación lista para subir',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.success,
                      ),
                    ),
                  if (vm.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 8),
                      child: Text(
                        vm.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                ],
              ),
            ),
            _BottomActions(vm: vm),
            const SizedBox(height: 16),
            _ConnectivityChip(vm: vm),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _RecordingAppBar extends StatelessWidget {
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nueva grabación',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Funciona sin internet',
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

class _MicButton extends StatelessWidget {
  final RecordingViewModel vm;
  const _MicButton({required this.vm});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: vm.isUploading
          ? null
          : () {
              if (vm.isRecording) {
                vm.stopRecording();
              } else if (!vm.hasRecording) {
                vm.startRecording();
              }
            },
      child: Container(
        width: 88,
        height: 88,
        decoration: BoxDecoration(
          color: vm.isRecording ? AppColors.recordingRed : AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (vm.isRecording ? AppColors.recordingRed : AppColors.primary)
                  .withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Icon(
          vm.isRecording ? Icons.stop : Icons.mic,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }
}

class _TimerDisplay extends StatelessWidget {
  final String elapsed;
  const _TimerDisplay({required this.elapsed});

  @override
  Widget build(BuildContext context) {
    return Text(
      elapsed,
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 2,
      ),
    );
  }
}

class _RecordingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.recordingRed,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'Grabando...',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.recordingRed,
          ),
        ),
      ],
    );
  }
}

class _BottomActions extends StatelessWidget {
  final RecordingViewModel vm;
  const _BottomActions({required this.vm});

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
                          onUploaded: (id) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Grabación encolada para subir en segundo plano.'),
                                backgroundColor: AppColors.primary,
                              ),
                            );
                          },
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

/// Selector de proyecto (obligatorio): muestra el proyecto elegido y abre el
/// bottom sheet para elegir/crear.
class _ProjectSelector extends StatelessWidget {
  final RecordingViewModel vm;
  const _ProjectSelector({required this.vm});

  @override
  Widget build(BuildContext context) {
    final proyecto = vm.selectedProyecto;
    final tieneProyecto = proyecto != null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: GestureDetector(
        onTap: () => showProjectSheet(context, vm),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: tieneProyecto ? AppColors.border : AppColors.warning,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.folder_outlined,
                  size: 20,
                  color: tieneProyecto
                      ? AppColors.primary
                      : AppColors.warning),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PROYECTO',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      vm.loadingProyectos
                          ? 'Cargando proyectos...'
                          : (proyecto?.nombre ?? 'Selecciona un proyecto'),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: tieneProyecto
                            ? AppColors.textPrimary
                            : AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.unfold_more,
                  size: 18, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

/// Abre el bottom sheet para elegir un proyecto existente o crear uno nuevo.
void showProjectSheet(BuildContext context, RecordingViewModel vm) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => ListenableBuilder(
      listenable: vm,
      builder: (ctx, _) => _ProjectSheet(vm: vm),
    ),
  );
}

class _ProjectSheet extends StatelessWidget {
  final RecordingViewModel vm;
  const _ProjectSheet({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Elige un proyecto',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (vm.loadingProyectos)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (vm.proyectos.isEmpty)
            // El alta de proyectos ahora vive en la pantalla de inicio; aquí
            // solo se selecciona uno existente.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Aún no tienes proyectos.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Créalos desde la pantalla de Inicio con "Crear nuevo proyecto" y vuelve aquí para seleccionarlo.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 320),
              child: ListView(
                shrinkWrap: true,
                children: vm.proyectos.map((p) {
                  final selected = vm.selectedProyecto?.id == p.id;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      selected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: selected
                          ? AppColors.primary
                          : AppColors.textHint,
                    ),
                    title: Text(p.nombre),
                    subtitle: p.direccion != null ? Text(p.direccion!) : null,
                    onTap: () {
                      vm.selectProyecto(p);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

/// Chip que refleja la conectividad REAL (ping al back-end):
/// - verificando → gris neutro
/// - en línea → verde "Conectado"
/// - offline → naranja "Sin internet · audio guardado localmente"
class _ConnectivityChip extends StatelessWidget {
  final RecordingViewModel vm;
  const _ConnectivityChip({required this.vm});

  @override
  Widget build(BuildContext context) {
    final online = vm.online;

    late final Color bg;
    late final Color fg;
    late final IconData icon;
    late final String label;

    if (online == null) {
      bg = AppColors.surfaceVariant;
      fg = AppColors.textSecondary;
      icon = Icons.wifi_find_outlined;
      label = 'Verificando conexión...';
    } else if (online) {
      bg = AppColors.successLight;
      fg = AppColors.success;
      icon = Icons.wifi;
      label = 'Conectado · listo para subir';
    } else {
      bg = AppColors.warningLight;
      fg = AppColors.warning;
      icon = Icons.wifi_off;
      label = 'Sin internet · audio guardado localmente';
    }

    return GestureDetector(
      onTap: vm.checkConnectivity,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: fg,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
