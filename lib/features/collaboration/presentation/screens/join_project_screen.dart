import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../providers/collaboration_providers.dart';

class JoinProjectScreen extends ConsumerStatefulWidget {
  const JoinProjectScreen({super.key});

  @override
  ConsumerState<JoinProjectScreen> createState() => _JoinProjectScreenState();
}

class _JoinProjectScreenState extends ConsumerState<JoinProjectScreen> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _unirse() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    await ref.read(unirseAProyectoProvider.notifier).unirse(code);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final asyncState = ref.watch(unirseAProyectoProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Unirse a Proyecto'),
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_add, size: 80, color: colors.primary),
            const SizedBox(height: 24),
            Text(
              'Ingresa el código de invitación',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Pídele al dueño del proyecto que genere un código para ti.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textSecondary),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _codeController,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, letterSpacing: 4, fontWeight: FontWeight.bold, color: colors.textPrimary),
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: 'CÓDIGO',
                hintStyle: TextStyle(color: colors.textHint, letterSpacing: 4),
                filled: true,
                fillColor: colors.surfaceVariant,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            asyncState.when(
              data: (result) {
                if (result == null) {
                  return SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: colors.primary, foregroundColor: colors.textOnPrimary),
                      onPressed: _unirse,
                      child: const Text('Unirme', style: TextStyle(fontSize: 18)),
                    ),
                  );
                }

                return Column(
                  children: [
                    Icon(Icons.check_circle, color: colors.success, size: 48),
                    const SizedBox(height: 16),
                    Text('¡Te has unido a "${result.proyectoNombre}"!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.success, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Tu rol: ${result.rol.label}', style: TextStyle(color: colors.textPrimary)),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(foregroundColor: colors.primary, side: BorderSide(color: colors.primary)),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Volver a mis proyectos'),
                      ),
                    )
                  ],
                );
              },
              loading: () => CircularProgressIndicator(color: colors.primary),
              error: (err, _) => Column(
                children: [
                  Text(err.toString(), style: TextStyle(color: colors.error), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: colors.primary, foregroundColor: colors.textOnPrimary),
                      onPressed: _unirse,
                      child: const Text('Reintentar', style: TextStyle(fontSize: 18)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
