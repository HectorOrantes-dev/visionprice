import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../shared/widgets/vision_price_logo.dart';
import '../widgets/or_divider.dart';
import '../widgets/register_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                emailController: _emailController,
                passwordController: _passwordController,
              ),
              const SizedBox(height: 24),
              RegisterButton(
                emailController: _emailController,
                passwordController: _passwordController,
              ),
              RegisterTwoFactorSection(codeController: _codeController),
              const RegisterErrorBanner(),
              const SizedBox(height: 24),
              const OrDivider(),
              const SizedBox(height: 16),
              const RegisterGoogleButton(),
              const SizedBox(height: 16),
              RegisterLoginRow(onTap: () => Navigator.pop(context)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
