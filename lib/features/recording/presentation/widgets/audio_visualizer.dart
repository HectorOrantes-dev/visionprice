import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'dart:math' as math;

import '../../../../core/theme/app_theme.dart';

class AudioVisualizer extends StatefulWidget {
  final Stream<Amplitude>? amplitudeStream;
  final bool isRecording;

  const AudioVisualizer({
    super.key,
    required this.amplitudeStream,
    required this.isRecording,
  });

  @override
  State<AudioVisualizer> createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AudioVisualizer> with SingleTickerProviderStateMixin {
  List<double> _amplitudes = List.filled(30, 0.0);
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    widget.amplitudeStream?.listen((Amplitude amp) {
      if (!mounted) return;
      if (!widget.isRecording) return;
      
      // Amplitude is typically between -160 and 0. 
      // We normalize it between 0 and 1.
      double normalized = (amp.current + 160) / 160;
      normalized = math.max(0.0, math.min(1.0, normalized));
      
      // Make variations more visible
      normalized = math.pow(normalized, 3).toDouble(); 

      setState(() {
        _amplitudes.removeAt(0);
        _amplitudes.add(normalized);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isRecording) {
      return const SizedBox(height: 50, child: Center(child: Text('Presiona el micrófono para hablar', style: TextStyle(color: AppColors.textSecondary))));
    }

    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(_amplitudes.length, (index) {
          // Scale from 0-1 to pixel height (min 4, max 50)
          final height = 4.0 + (_amplitudes[index] * 46.0);
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 4,
            height: height,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }
}
