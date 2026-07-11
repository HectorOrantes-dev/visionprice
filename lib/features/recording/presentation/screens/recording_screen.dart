import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../sync/presentation/screens/processing_screen.dart';
import '../providers/recording_provider.dart';
import '../widgets/audio_visualizer.dart';

class RecordingScreen extends StatelessWidget {
  const RecordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _RecordingView();
  }
}

class _RecordingView extends ConsumerWidget {
  const _RecordingView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recordingProvider);
    final notifier = ref.read(recordingProvider.notifier);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            _RecordingAppBar(),
            _ProjectSelector(state: state),
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
                        color: context.colors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  AudioVisualizer(
                    amplitudeStream: notifier.amplitudeStream,
                    isRecording: state.isRecording,
                  ),
                  const SizedBox(height: 32),
                  _MicButton(state: state, notifier: notifier),
                  const SizedBox(height: 24),
                  _TimerDisplay(elapsed: state.elapsedFormatted),
                  const SizedBox(height: 12),
                  if (state.isRecording) _RecordingIndicator(),
                  if (state.hasRecording)
                    Text(
                      'Grabación lista para subir',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: context.colors.success,
                      ),
                    ),
                  if (state.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 8),
                      child: Text(
                        state.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                ],
              ),
            ),
            _BottomActions(state: state, notifier: notifier),
            const SizedBox(height: 16),
            _ConnectivityChip(state: state, notifier: notifier),
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
            icon: Icon(Icons.arrow_back_ios,
                size: 18, color: context.colors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nueva grabación',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
              Text(
                'Funciona sin internet',
                style: TextStyle(
                  fontSize: 12,
                  color: context.colors.textSecondary,
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
  final RecordingState state;
  final Recording notifier;
  const _MicButton({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: state.isUploading
          ? null
          : () {
              if (state.isRecording) {
                notifier.stopRecording();
              } else if (!state.hasRecording) {
                notifier.startRecording();
              }
            },
      child: Container(
        width: 88,
        height: 88,
        decoration: BoxDecoration(
          color:
              state.isRecording ? context.colors.recordingRed : context.colors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color:
                  (state.isRecording ? context.colors.recordingRed : context.colors.primary)
                      .withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Icon(
          state.isRecording ? Icons.stop : Icons.mic,
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
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: context.colors.textPrimary,
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
          decoration: BoxDecoration(
            color: context.colors.recordingRed,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          'Grabando...',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: context.colors.recordingRed,
          ),
        ),
      ],
    );
  }
}

class _BottomActions extends StatelessWidget {
  final RecordingState state;
  final Recording notifier;
  const _BottomActions({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
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
                    : () {
                        if (state.selectedProyecto == null) {
                          showProjectSheet(context);
                          return;
                        }
                        notifier.upload(
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

/// Selector de proyecto (obligatorio): muestra el proyecto elegido y abre el
/// bottom sheet para elegir/crear.
class _ProjectSelector extends StatelessWidget {
  final RecordingState state;
  const _ProjectSelector({required this.state});

  @override
  Widget build(BuildContext context) {
    final proyecto = state.selectedProyecto;
    final tieneProyecto = proyecto != null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: GestureDetector(
        onTap: () => showProjectSheet(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: tieneProyecto ? context.colors.border : context.colors.warning,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.folder_outlined,
                  size: 20,
                  color:
                      tieneProyecto ? context.colors.primary : context.colors.warning),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PROYECTO',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      state.loadingProyectos
                          ? 'Cargando proyectos...'
                          : (proyecto?.nombre ?? 'Selecciona un proyecto'),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: tieneProyecto
                            ? context.colors.textPrimary
                            : context.colors.warning,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.unfold_more,
                  size: 18, color: context.colors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

/// Abre el bottom sheet para elegir un proyecto existente o crear uno nuevo.
void showProjectSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const _ProjectSheet(),
  );
}

class _ProjectSheet extends ConsumerWidget {
  const _ProjectSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recordingProvider);
    final notifier = ref.read(recordingProvider.notifier);
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
                color: context.colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Elige un proyecto',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (state.loadingProyectos)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (state.proyectos.isEmpty)
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
                          size: 18, color: context.colors.textSecondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Aún no tienes proyectos.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Créalos desde la pantalla de Inicio con "Crear nuevo proyecto" y vuelve aquí para seleccionarlo.',
                    style: TextStyle(
                      fontSize: 13,
                      color: context.colors.textSecondary,
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
                children: state.proyectos.map((p) {
                  final selected = state.selectedProyecto?.id == p.id;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      selected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: selected ? context.colors.primary : context.colors.textHint,
                    ),
                    title: Text(p.nombre),
                    subtitle: p.direccion != null ? Text(p.direccion!) : null,
                    onTap: () {
                      notifier.selectProyecto(p);
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
  final RecordingState state;
  final Recording notifier;
  const _ConnectivityChip({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final online = state.online;

    late final Color bg;
    late final Color fg;
    late final IconData icon;
    late final String label;

    if (online == null) {
      bg = context.colors.surfaceVariant;
      fg = context.colors.textSecondary;
      icon = Icons.wifi_find_outlined;
      label = 'Verificando conexión...';
    } else if (online) {
      bg = context.colors.successLight;
      fg = context.colors.success;
      icon = Icons.wifi;
      label = 'Conectado · listo para subir';
    } else {
      bg = context.colors.warningLight;
      fg = context.colors.warning;
      icon = Icons.wifi_off;
      label = 'Sin internet · audio guardado localmente';
    }

    return GestureDetector(
      onTap: notifier.checkConnectivity,
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
