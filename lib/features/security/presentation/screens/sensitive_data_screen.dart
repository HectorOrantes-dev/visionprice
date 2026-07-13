import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../providers/sensitive_data_provider.dart';

/// Pantalla de gestión de datos sensibles guardados localmente
/// (SharedPreferences, vía `sensitiveDataProvider`). La señal remota WIPE_DATA
/// los borra (ver NotificationService) y refresca esta pantalla invalidando el
/// provider. Los `TextEditingController` se quedan locales (así debe ser).
class SensitiveDataScreen extends ConsumerStatefulWidget {
  const SensitiveDataScreen({super.key});

  /// Callback estático que el NotificationService dispara tras un WIPE_DATA
  /// externo para refrescar la pantalla si está abierta.
  static void Function()? onWipe;

  @override
  ConsumerState<SensitiveDataScreen> createState() =>
      _SensitiveDataScreenState();
}

class _SensitiveDataScreenState extends ConsumerState<SensitiveDataScreen> {
  final _emailController = TextEditingController();
  final _tokenController = TextEditingController();
  final _cardController = TextEditingController();
  final _keyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Tras un WIPE_DATA externo, recargar los datos invalidando el provider.
    SensitiveDataScreen.onWipe = () {
      if (mounted) ref.invalidate(sensitiveDataProvider);
    };
  }

  @override
  void dispose() {
    SensitiveDataScreen.onWipe = null;
    _emailController.dispose();
    _tokenController.dispose();
    _cardController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    await ref.read(sensitiveDataProvider.notifier).guardar(
          email: _emailController.text,
          token: _tokenController.text,
          card: _cardController.text,
          key: _keyController.text,
        );
    _emailController.clear();
    _tokenController.clear();
    _cardController.clear();
    _keyController.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos guardados localmente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(sensitiveDataProvider);
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: const Text('Datos sensibles'),
        backgroundColor: context.colors.surface,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Ingresar nuevos datos',
                style: AppTextStyles.heading(
                  size: 16,
                  weight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _field(_emailController, 'Correo', Icons.email_outlined),
              const SizedBox(height: 10),
              _field(
                  _tokenController, 'Token de sesión', Icons.vpn_key_outlined),
              const SizedBox(height: 10),
              _field(_cardController, 'Tarjeta', Icons.credit_card_outlined),
              const SizedBox(height: 10),
              _field(_keyController, 'Clave privada', Icons.lock_outline,
                  obscure: true),
              const SizedBox(height: 16),
              GradientButton(
                onPressed: _guardar,
                child: const Text('Guardar'),
              ),
              const SizedBox(height: 28),
              Text(
                'Datos guardados en local',
                style: AppTextStyles.heading(
                  size: 16,
                  weight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              dataAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Text('No se pudieron leer los datos: $e',
                    style: TextStyle(color: context.colors.error)),
                data: (stored) => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.colors.border),
                  ),
                  child: Column(
                    children: stored.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: context.colors.textPrimary,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                entry.value,
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: context.colors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.colors.warningLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 16, color: context.colors.warning),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Si llega la señal WIPE_DATA por push, estos datos se borran.',
                        style: TextStyle(
                            fontSize: 12, color: context.colors.warning),
                      ),
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

  Widget _field(TextEditingController c, String label, IconData icon,
      {bool obscure = false}) {
    return TextField(
      controller: c,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: context.colors.textSecondary),
      ),
    );
  }
}
