import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Datos de las 3 páginas de onboarding
final _onboardingData = [
  _OnboardingSlide(
    icon: Icons.view_in_ar_outlined,
    iconColor: AppColors.primary,
    title: 'Escanea en Segundos',
    subtitle:
        'Apunta tu cámara a la superficie. La IA detecta planos y reconstruye la geometría en 3D automáticamente.',
    gradientColors: [const Color(0xFF0D2018), AppColors.bgDark],
  ),
  _OnboardingSlide(
    icon: Icons.analytics_outlined,
    iconColor: AppColors.accent,
    title: 'Calcula con Precisión',
    subtitle:
        'Obtén cantidades exactas de materiales considerando desperdicios, cortes y áreas netas al instante.',
    gradientColors: [const Color(0xFF0D1520), AppColors.bgDark],
  ),
  _OnboardingSlide(
    icon: Icons.price_check_outlined,
    iconColor: AppColors.warning,
    title: 'Precios en Tiempo Real',
    subtitle:
        'Compara precios de Home Depot, Sodimac y Construrama en tu ciudad. Presupuesta con datos actuales.',
    gradientColors: [const Color(0xFF1A140A), AppColors.bgDark],
  ),
];

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _currentPage = 0;

  void _next() {
    if (_currentPage < _onboardingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Stack(
        children: [
          // Páginas
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _onboardingData.length,
            itemBuilder: (context, i) =>
                _OnboardingSlideWidget(slide: _onboardingData[i]),
          ),

          // Bottom controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _onboardingData.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == i ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == i
                                ? AppColors.primary
                                : AppColors.border,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Botón siguiente / comenzar
                    ElevatedButton(
                      onPressed: _next,
                      child: Text(
                        _currentPage == _onboardingData.length - 1
                            ? 'Comenzar'
                            : 'Siguiente',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Saltar
                    TextButton(
                      onPressed: () => context.go(AppRoutes.login),
                      child: const Text('Saltar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
}

class _OnboardingSlideWidget extends StatelessWidget {
  const _OnboardingSlideWidget({required this.slide});

  final _OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: slide.gradientColors,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Icono grande con glow
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: slide.iconColor.withOpacity(0.1),
                  border: Border.all(
                      color: slide.iconColor.withOpacity(0.3), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: slide.iconColor.withOpacity(0.2),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Icon(slide.icon, size: 64, color: slide.iconColor),
              ),
              const Spacer(),
              // Título
              Text(
                slide.title,
                textAlign: TextAlign.center,
                style: AppTypography.textTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              // Subtitle
              Text(
                slide.subtitle,
                textAlign: TextAlign.center,
                style: AppTypography.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
