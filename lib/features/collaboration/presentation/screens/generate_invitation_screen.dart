import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/project_role.dart';
import '../providers/collaboration_providers.dart';

class GenerateInvitationScreen extends ConsumerStatefulWidget {
  final int proyectoId;

  const GenerateInvitationScreen({super.key, required this.proyectoId});

  @override
  ConsumerState<GenerateInvitationScreen> createState() => _GenerateInvitationScreenState();
}

class _GenerateInvitationScreenState extends ConsumerState<GenerateInvitationScreen> {
  ProjectRole _selectedRole = ProjectRole.colaborador;
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _generar() async {
    List<String>? correos;
    if (_emailController.text.trim().isNotEmpty) {
      correos = _emailController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    
    await ref.read(generarInvitacionProvider.notifier).generar(
          widget.proyectoId,
          _selectedRole.apiValue,
          correos: correos,
        );
        
    // Forzamos a recargar la lista de invitaciones para que aparezca la nueva al volver.
    ref.read(invitacionesProvider(widget.proyectoId).notifier).recargar();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final asyncState = ref.watch(generarInvitacionProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Nueva Invitación'),
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selecciona el rol para el nuevo miembro:', style: TextStyle(color: colors.textPrimary)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<ProjectRole>(
                  value: _selectedRole,
                  isExpanded: true,
                  dropdownColor: colors.surfaceVariant,
                  style: TextStyle(color: colors.textPrimary),
                  items: ProjectRole.values.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role.label),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedRole = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Correos (opcional, separados por coma):', style: TextStyle(color: colors.textPrimary)),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              style: TextStyle(color: colors.textPrimary),
              decoration: InputDecoration(
                hintText: 'ejemplo@empresa.com, otro@mail.com',
                hintStyle: TextStyle(color: colors.textHint),
                filled: true,
                fillColor: colors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            asyncState.when(
              data: (invitacion) {
                if (invitacion == null) {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: colors.primary, foregroundColor: colors.textOnPrimary),
                      onPressed: _generar,
                      child: const Text('Generar Código', style: TextStyle(fontSize: 16)),
                    ),
                  );
                }
                
                return Card(
                  color: colors.successLight.withAlpha(50),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Código generado', style: TextStyle(color: colors.success, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        SelectableText(
                          invitacion.codigo,
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4, color: colors.primary),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: invitacion.codigo));
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copiado al portapapeles')));
                          },
                          icon: const Icon(Icons.copy),
                          label: const Text('Copiar'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Column(
                children: [
                  Text('Error: $e', style: TextStyle(color: colors.error)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: colors.primary, foregroundColor: colors.textOnPrimary),
                      onPressed: _generar,
                      child: const Text('Reintentar', style: TextStyle(fontSize: 16)),
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
