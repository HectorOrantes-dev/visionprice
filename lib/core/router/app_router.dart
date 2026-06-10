import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/projects/presentation/pages/home_page.dart';
import '../../features/projects/presentation/pages/create_project_page.dart';
import '../../features/scanner/presentation/pages/scanner_page.dart';
import '../../features/scanner/presentation/pages/manual_mode_page.dart';
import '../../features/viewer3d/presentation/pages/viewer3d_page.dart';
import '../../features/materials/presentation/pages/materials_page.dart';
import '../../features/budget/presentation/pages/budget_page.dart';

/// Rutas nombradas de VisionPrice
abstract final class AppRoutes {
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const createProject = '/projects/create';
  static const scanner = '/scanner';
  static const manualMode = '/scanner/manual';
  static const viewer3d = '/viewer3d';
  static const materials = '/materials';
  static const budget = '/budget';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.onboarding,
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.createProject,
      name: 'createProject',
      builder: (context, state) => const CreateProjectPage(),
    ),
    GoRoute(
      path: AppRoutes.scanner,
      name: 'scanner',
      builder: (context, state) => const ScannerPage(),
    ),
    GoRoute(
      path: AppRoutes.manualMode,
      name: 'manualMode',
      builder: (context, state) => const ManualModePage(),
    ),
    GoRoute(
      path: AppRoutes.viewer3d,
      name: 'viewer3d',
      builder: (context, state) {
        final projectId = state.uri.queryParameters['projectId'] ?? '';
        return Viewer3dPage(projectId: projectId);
      },
    ),
    GoRoute(
      path: AppRoutes.materials,
      name: 'materials',
      builder: (context, state) {
        final projectId = state.uri.queryParameters['projectId'] ?? '';
        return MaterialsPage(projectId: projectId);
      },
    ),
    GoRoute(
      path: AppRoutes.budget,
      name: 'budget',
      builder: (context, state) {
        final projectId = state.uri.queryParameters['projectId'];
        return BudgetPage(projectId: projectId);
      },
    ),
  ],
);
