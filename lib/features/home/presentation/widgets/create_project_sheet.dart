import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/home_provider.dart';

/// Abre el bottom sheet para dar de alta un proyecto desde la home.
void showCreateProjectSheet(BuildContext context, HomeViewModel vm) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => CreateProjectSheet(vm: vm),
  );
}

/// Formulario del bottom sheet de alta de proyecto. Antes `_CreateProjectSheet`.
class CreateProjectSheet extends StatefulWidget {
  final HomeViewModel vm;
  const CreateProjectSheet({super.key, required this.vm});

  @override
  State<CreateProjectSheet> createState() => _CreateProjectSheetState();
}

class _CreateProjectSheetState extends State<CreateProjectSheet> {
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
    if (nombre.length < 2) {
      setState(() => _error = 'Escribe un nombre (mín. 2 caracteres)');
      return;
    }
    setState(() {
      _creating = true;
      _error = null;
    });
    try {
      await widget.vm.crearProyecto(
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
            'Nuevo proyecto',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nombreController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Nombre',
              hintText: 'Ej. Casa Polanco',
              prefixIcon: const Icon(Icons.create_new_folder_outlined,
                  size: 20, color: AppColors.textSecondary),
              errorText: _error,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _direccionController,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Dirección (opcional)',
              hintText: 'Ej. Col. Del Valle',
              prefixIcon: Icon(Icons.location_on_outlined,
                  size: 20, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
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
          ),
        ],
      ),
    );
  }
}
