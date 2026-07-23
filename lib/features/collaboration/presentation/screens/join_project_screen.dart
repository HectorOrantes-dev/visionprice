import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../providers/collaboration_providers.dart';

/// Unirse a un proyecto con un código de invitación (`POST /proyectos/unirse`).
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

  Future<void> _unirse() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) return;
    await ref.read(unirseAProyectoProvider.notifier).unirse(code);
    // El proyecto nuevo debe aparecer en "Mis proyectos" al volver a la home.
    final unido = ref.read(unirseAProyectoProvider).value;
    if (unido != null) {
      await ref.read(homeProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final asyncState = ref.watch(unirseAProyectoProvider);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        elevation: 0,
        leading: BackButton(color: c.textPrimary),
        title: Text('Unirme a un proyecto',
            style: TextStyle(
                color: c.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: c.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.group_add_outlined,
                      size: 34, color: c.primary),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text('Ingresa el código de invitación',
                    textAlign: TextAlign.center,
                    style:
                        AppTextStyles.heading(size: 20, color: c.textPrimary)),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  'Pídele al dueño del proyecto que genere un código para ti.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13, color: c.textSecondary, height: 1.4),
                ),
              ),
              const SizedBox(height: 28),
              TextField(
                controller: _codeController,
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.characters,
                style: TextStyle(
                    fontSize: 22,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w800,
                    color: c.textPrimary),
                decoration: InputDecoration(
                  hintText: 'CÓDIGO',
                  hintStyle: TextStyle(color: c.textHint, letterSpacing: 3),
                  filled: true,
                  fillColor: c.surface,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: c.border),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: c.border),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              asyncState.when(
                data: (result) => result == null
                    ? GradientButton(
                        height: 52,
                        onPressed: _unirse,
                        child: const Text('Unirme'),
                      )
                    : _Exito(
                        rol: result.rol.label,
                        onVolver: () => Navigator.pop(context),
                      ),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (e, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: c.errorLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, size: 16, color: c.error),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              e is ApiException
                                  ? e.message
                                  : 'No se pudo unir al proyecto.',
                              style: TextStyle(fontSize: 12, color: c.error),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    GradientButton(
                      height: 52,
                      onPressed: _unirse,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Estado de éxito tras unirse: confirma el rol asignado y ofrece volver.
/// El back-end de `/proyectos/unirse` no devuelve el nombre del proyecto
/// (solo los datos del miembro), así que no se muestra aquí — ya aparece en
/// "Mis proyectos" al volver.
class _Exito extends StatelessWidget {
  final String rol;
  final VoidCallback onVolver;
  const _Exito({required this.rol, required this.onVolver});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: [
        Icon(Icons.check_circle, color: c.success, size: 48),
        const SizedBox(height: 12),
        Text('¡Te uniste al proyecto!',
            textAlign: TextAlign.center,
            style: AppTextStyles.heading(size: 18, color: c.success)),
        const SizedBox(height: 6),
        Text('Tu rol: $rol', style: TextStyle(color: c.textSecondary)),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: onVolver,
            child: const Text('Volver a mis proyectos'),
          ),
        ),
      ],
    );
  }
}
