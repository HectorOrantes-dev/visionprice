import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../shared/widgets/field_label.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../domain/entities/perfil_entity.dart';
import '../providers/auth_providers.dart';
import '../providers/perfil_provider.dart';

/// Se muestra cuando faltan datos del perfil (hoy: teléfono vacío) justo
/// antes de grabar un audio — el registro simplificado solo pide
/// correo+contraseña+rol, así que nombre/teléfono reales se completan aquí,
/// con los mismos campos que antes vivían en el registro.
class CompletarPerfilScreen extends ConsumerStatefulWidget {
  final PerfilEntity perfilActual;
  final VoidCallback onCompletado;

  const CompletarPerfilScreen({
    super.key,
    required this.perfilActual,
    required this.onCompletado,
  });

  @override
  ConsumerState<CompletarPerfilScreen> createState() =>
      _CompletarPerfilScreenState();
}

class _CompletarPerfilScreenState extends ConsumerState<CompletarPerfilScreen> {
  late final _nombreController =
      TextEditingController(text: widget.perfilActual.nombre);
  late final _telefonoController =
      TextEditingController(text: widget.perfilActual.telefono);
  bool _guardando = false;
  String? _error;

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final nombre = _nombreController.text.trim();
    if (nombre.length < 2) {
      setState(() => _error = 'El nombre debe tener al menos 2 caracteres.');
      return;
    }
    setState(() {
      _guardando = true;
      _error = null;
    });
    try {
      await ref.read(actualizarPerfilUseCaseProvider)(
        nombre: nombre,
        telefono: _telefonoController.text.trim(),
      );
      ref.invalidate(perfilProvider);
      if (!mounted) return;
      widget.onCompletado();
    } catch (e) {
      setState(() {
        _guardando = false;
        _error =
            e is ApiException ? e.message : 'No se pudieron guardar los datos.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: BackButton(color: context.colors.textPrimary),
        title: Text('Completa tus datos',
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Te hace falta llenar algunos datos antes de grabar.',
                style: TextStyle(
                    fontSize: 14, color: context.colors.textSecondary),
              ),
              const SizedBox(height: 24),
              const FieldLabel('NOMBRE'),
              const SizedBox(height: 8),
              TextField(
                controller: _nombreController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Tu nombre completo',
                  prefixIcon: Icon(Icons.badge_outlined,
                      color: context.colors.textSecondary, size: 20),
                ),
              ),
              const SizedBox(height: 20),
              const FieldLabel('TELÉFONO'),
              const SizedBox(height: 8),
              TextField(
                controller: _telefonoController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '+52 55 1234 5678',
                  prefixIcon: Icon(Icons.phone_outlined,
                      color: context.colors.textSecondary, size: 20),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!,
                    style:
                        TextStyle(color: context.colors.error, fontSize: 13)),
              ],
              const SizedBox(height: 28),
              GradientButton(
                onPressed: _guardando ? null : _guardar,
                child: _guardando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Guardar y continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
