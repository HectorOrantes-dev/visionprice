import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validation_mixin.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../providers/home_provider.dart';

/// Bottom sheet para dar de alta un proyecto desde la home.
class CreateProjectSheet extends StatefulWidget {
  final Home notifier;
  const CreateProjectSheet({super.key, required this.notifier});

  /// Abre el sheet de alta de proyecto.
  static void show(BuildContext context, Home notifier) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => CreateProjectSheet(notifier: notifier),
    );
  }

  @override
  State<CreateProjectSheet> createState() => _CreateProjectSheetState();
}

class _CreateProjectSheetState extends State<CreateProjectSheet>
    with ValidationMixin {
  final _nombreController = TextEditingController();
  final _direccionController = TextEditingController();
  bool _creating = false;
  String? _error;

  @override
  void dispose() {
    _nombreController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  Future<void> _crear() async {
    final nombre = _nombreController.text.trim();
    final nombreError = validateProjectName(nombre);
    if (nombreError != null) {
      setState(() => _error = nombreError);
      return;
    }
    setState(() {
      _creating = true;
      _error = null;
    });
    try {
      await widget.notifier.crearProyecto(
        nombre: nombre,
        direccion: _direccionController.text.trim(),
      );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      setState(() => _error = 'No se pudo crear el proyecto.');
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
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
              'Nuevo proyecto',
              style: AppTextStyles.heading(
                size: 20,
                weight: FontWeight.w800,
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nombreController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Nombre',
                hintText: 'Ej. Casa Polanco',
                prefixIcon: Icon(Icons.create_new_folder_outlined,
                    size: 20, color: context.colors.textSecondary),
                errorText: _error,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _direccionController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Dirección (opcional)',
                hintText: 'Ej. Col. Del Valle',
                prefixIcon: Icon(Icons.location_on_outlined,
                    size: 20, color: context.colors.textSecondary),
              ),
            ),
            const SizedBox(height: 16),
            GradientButton(
              height: 48,
              onPressed: _creating ? null : _crear,
              child: _creating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Crear proyecto'),
            ),
          ],
        ),
      ),
    );
  }
}
