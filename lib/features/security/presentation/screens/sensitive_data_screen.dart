import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/gradient_button.dart';

/// Pantalla de gestión de datos sensibles guardados localmente
/// (SharedPreferences). La señal remota WIPE_DATA los borra (ver
/// NotificationService). Tema claro, coherente con VisionPrice.
class SensitiveDataScreen extends StatefulWidget {
  const SensitiveDataScreen({super.key});

  /// Callback estático para refrescar la pantalla tras un WIPE_DATA externo.
  static void Function()? onWipe;

  @override
  State<SensitiveDataScreen> createState() => _SensitiveDataScreenState();
}

class _SensitiveDataScreenState extends State<SensitiveDataScreen> {
  final _emailController = TextEditingController();
  final _tokenController = TextEditingController();
  final _cardController = TextEditingController();
  final _keyController = TextEditingController();

  Map<String, String> _storedData = {};

  static const _fields = {
    'sensitive_email': 'Correo',
    'sensitive_token': 'Token de sesión',
    'sensitive_card': 'Tarjeta',
    'sensitive_key': 'Clave privada',
  };

  @override
  void initState() {
    super.initState();
    _loadData();
    SensitiveDataScreen.onWipe = () {
      if (mounted) _loadData();
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

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedData = {
        for (final entry in _fields.entries)
          entry.value: prefs.getString(entry.key) ?? 'Vacío',
      };
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sensitive_email', _emailController.text);
    await prefs.setString('sensitive_token', _tokenController.text);
    await prefs.setString('sensitive_card', _cardController.text);
    await prefs.setString('sensitive_key', _keyController.text);

    _emailController.clear();
    _tokenController.clear();
    _cardController.clear();
    _keyController.clear();

    await _loadData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos guardados localmente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            _field(_tokenController, 'Token de sesión', Icons.vpn_key_outlined),
            const SizedBox(height: 10),
            _field(_cardController, 'Tarjeta', Icons.credit_card_outlined),
            const SizedBox(height: 10),
            _field(_keyController, 'Clave privada', Icons.lock_outline,
                obscure: true),
            const SizedBox(height: 16),
            GradientButton(
              onPressed: _saveData,
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.colors.border),
              ),
              child: Column(
                children: _storedData.entries.map((entry) {
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
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Si llega la señal WIPE_DATA por push, estos datos se borran.',
                      style: TextStyle(fontSize: 12, color: context.colors.warning),
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
