import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../domain/entities/role_entity.dart';
import '../providers/auth_providers.dart';
import '../providers/login_provider.dart';

/// Se muestra cuando `loginWithGoogle` avisa que la cuenta de Google todavía
/// no existe en el back-end: pide el rol (el único dato que falta, ya que
/// nombre/correo vienen del propio Google) y completa el registro.
class GoogleRoleScreen extends ConsumerStatefulWidget {
  final String idToken;
  const GoogleRoleScreen({super.key, required this.idToken});

  @override
  ConsumerState<GoogleRoleScreen> createState() => _GoogleRoleScreenState();
}

class _GoogleRoleScreenState extends ConsumerState<GoogleRoleScreen> {
  List<RoleEntity> _roles = const [];
  RoleEntity? _seleccionado;
  bool _cargandoRoles = true;
  String? _errorRoles;

  @override
  void initState() {
    super.initState();
    _cargarRoles();
  }

  Future<void> _cargarRoles() async {
    try {
      final roles = await ref.read(getRolesUseCaseProvider)();
      if (!mounted) return;
      setState(() {
        _roles = roles;
        _cargandoRoles = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorRoles = 'No se pudieron cargar los roles.';
        _cargandoRoles = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: BackButton(color: context.colors.textPrimary),
        title: Text('Un último paso',
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            )),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('¿Cuál es tu rol?',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary)),
              const SizedBox(height: 8),
              Text(
                'Es lo único que necesitamos para terminar de crear tu cuenta con Google.',
                style: TextStyle(fontSize: 14, color: context.colors.textSecondary),
              ),
              const SizedBox(height: 24),
              if (_cargandoRoles)
                const Center(child: CircularProgressIndicator())
              else if (_errorRoles != null)
                Text(_errorRoles!, style: TextStyle(color: context.colors.error))
              else
                DropdownButtonFormField<RoleEntity>(
                  initialValue: _seleccionado,
                  isExpanded: true,
                  decoration: InputDecoration(
                    hintText: 'Selecciona tu rol',
                    prefixIcon: Icon(Icons.work_outline,
                        color: context.colors.textSecondary, size: 20),
                  ),
                  items: _roles
                      .map((r) => DropdownMenuItem(value: r, child: Text(r.label)))
                      .toList(),
                  onChanged: loginState.isLoading
                      ? null
                      : (r) => setState(() => _seleccionado = r),
                ),
              if (loginState.errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(loginState.errorMessage!,
                    style: TextStyle(color: context.colors.error, fontSize: 13)),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _seleccionado == null || loginState.isLoading
                      ? null
                      : () => ref.read(loginProvider.notifier).registerWithGoogle(
                            idToken: widget.idToken,
                            rol: _seleccionado!.value,
                            onSuccess: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const HomeScreen()),
                              (route) => false,
                            ),
                          ),
                  child: loginState.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Crear cuenta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
