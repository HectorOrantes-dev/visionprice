import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../security/services/notification_service.dart';
import '../providers/login_provider.dart';
import '../widgets/login_widgets.dart';
import 'forgot_password_screen.dart';
import 'privacy_notice_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Obtiene el token FCM del dispositivo (null si Firebase no está configurado).
    NotificationService.getToken();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // El ViewModel se resuelve desde la DI automatizada (getIt), con sus use
    // cases ya inyectados. Una instancia nueva (factory) por pantalla.
    return ChangeNotifierProvider(
      create: (_) => getIt<LoginViewModel>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const LoginLogo(),
                const SizedBox(height: 28),
                const LoginHeader(),
                const SizedBox(height: 24),
                LoginForm(
                  emailController: _emailController,
                  passwordController: _passwordController,
                ),
                const SizedBox(height: 24),
                LoginKeepSessionRow(
                  onForgot: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen()),
                  ),
                ),
                const SizedBox(height: 24),
                LoginContinueButton(
                  emailController: _emailController,
                  passwordController: _passwordController,
                ),
                TwoFactorSection(codeController: _codeController),
                const LoginErrorBanner(),
                const SizedBox(height: 24),
                const OrDivider(),
                const SizedBox(height: 16),
                const SocialButtons(),
                const SizedBox(height: 20),
                LoginRegisterRow(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                ),
                const SizedBox(height: 12),
                LoginPrivacyNotice(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const PrivacyNoticeScreen()),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
