import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../shared/widgets/vision_price_logo.dart';
import '../widgets/register_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // El ViewModel se resuelve desde la DI automatizada (getIt); en su
    // El estado del registro vive en `registerProvider` (Riverpod, autoDispose):
    // se crea al observarlo desde los widgets hijos (que también cargan roles).
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: BackButton(color: context.colors.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const VisionPriceLogo(size: 40, showWordmark: true),
              const SizedBox(height: 32),
              const RegisterHeader(),
              const SizedBox(height: 32),
              RegisterForm(
                nameController: _nameController,
                emailController: _emailController,
                passwordController: _passwordController,
                phoneController: _phoneController,
              ),
              const SizedBox(height: 24),
              RegisterButton(
                nameController: _nameController,
                emailController: _emailController,
                passwordController: _passwordController,
                phoneController: _phoneController,
              ),
              RegisterTwoFactorSection(codeController: _codeController),
              const RegisterErrorBanner(),
              const SizedBox(height: 32),
              RegisterLoginRow(onTap: () => Navigator.pop(context)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
