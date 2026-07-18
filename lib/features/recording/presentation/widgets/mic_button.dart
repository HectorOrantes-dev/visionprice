import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../providers/recording_provider.dart';

/// Botón de micrófono con animación de pulso durante la grabación. Antes el
/// privado `_MicButton`.
class MicButton extends StatefulWidget {
  final RecordingState state;
  final Recording notifier;
  const MicButton({super.key, required this.state, required this.notifier});

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  @override
  void initState() {
    super.initState();
    if (widget.state.isRecording) _pulseController.repeat();
  }

  @override
  void didUpdateWidget(covariant MicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.isRecording && !oldWidget.state.isRecording) {
      _pulseController.repeat();
    } else if (!widget.state.isRecording && oldWidget.state.isRecording) {
      _pulseController
        ..stop()
        ..reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final notifier = widget.notifier;
    final color = state.isRecording
        ? context.colors.recordingRed
        : context.colors.primary;
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (state.isRecording)
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, _) {
                final t = _pulseController.value;
                return Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: (1 - t) * 0.45),
                        blurRadius: 4,
                        spreadRadius: t * 22,
                      ),
                    ],
                  ),
                );
              },
            ),
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
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
        ],
      ),
    );
  }
}
