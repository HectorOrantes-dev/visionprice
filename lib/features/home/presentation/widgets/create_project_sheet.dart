import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/text_formatters.dart';
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
  // Empiezan en `null` (campo intacto, sin tocar) para no gritarle "obligatorio"
  // al usuario antes de que escriba nada; en cuanto escribe algo una vez, se
  // revalida en cada tecla (ver _onNombreChanged/_onDireccionChanged).
  String? _error;
  String? _errorDireccion;
  bool _nombreTocado = false;
  bool _direccionTocada = false;

  @override
  void initState() {
    super.initState();
    _nombreController.addListener(_onNombreChanged);
    _direccionController.addListener(_onDireccionChanged);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  void _onNombreChanged() {
    if (!_nombreTocado) _nombreTocado = true;
    setState(() => _error = validateProjectName(_nombreController.text));
  }

  void _onDireccionChanged() {
    if (!_direccionTocada) _direccionTocada = true;
    setState(() =>
        _errorDireccion = validateOptionalText(_direccionController.text));
  }

  /// Habilita "Crear proyecto" solo con datos ya válidos — la validación real
  /// pasa mientras el usuario escribe (arriba), esto solo bloquea el botón.
  bool get _formularioValido =>
      validateProjectName(_nombreController.text) == null &&
      validateOptionalText(_direccionController.text) == null;

  Future<void> _crear() async {
    final nombre = _nombreController.text.trim();
    final direccion = _direccionController.text.trim();
    setState(() {
      _creating = true;
      _error = null;
      _errorDireccion = null;
    });
    try {
      await widget.notifier.crearProyecto(
        nombre: nombre,
        direccion: direccion,
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
              inputFormatters: kNoSymbolsFormatters,
              decoration: InputDecoration(
                labelText: 'Nombre',
                hintText: 'Ej. Casa Polanco',
                prefixIcon: Icon(Icons.create_new_folder_outlined,
                    size: 20, color: context.colors.textSecondary),
                errorText: _nombreTocado ? _error : null,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _direccionController,
              textCapitalization: TextCapitalization.sentences,
              inputFormatters: kNoSymbolsFormatters,
              decoration: InputDecoration(
                labelText: 'Dirección (opcional)',
                hintText: 'Ej. Col. Del Valle',
                prefixIcon: Icon(Icons.location_on_outlined,
                    size: 20, color: context.colors.textSecondary),
                errorText: _direccionTocada ? _errorDireccion : null,
              ),
            ),
            const SizedBox(height: 16),
            GradientButton(
              height: 48,
              onPressed: (_creating || !_formularioValido) ? null : _crear,
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
