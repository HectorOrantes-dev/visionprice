import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';

import '../../features/projects/presentation/pages/home_page.dart';
import '../../features/recording/presentation/screens/recording_screen.dart';
import '../../features/sync/presentation/screens/sync_queue_screen.dart';
import '../../features/sync/presentation/screens/processing_screen.dart';
import '../../features/budget/presentation/screens/parameters_review_screen.dart';
import '../../features/budget/presentation/screens/nearby_stores_screen.dart';
import '../../features/budget/presentation/screens/budget_result_screen.dart';
import '../../features/budget/presentation/screens/export_pdf_screen.dart';
import '../../features/materials/presentation/pages/materials_page.dart';
import '../../features/materials/presentation/pages/material_catalog_page.dart';

/// Rutas nombradas de VisionPrice
abstract final class AppRoutes {
  // Autenticación
  static const login = '/login';
  static const register = '/register';
  
  // Navegación Principal
  static const home = '/home';
  static const projects = '/projects';
  static const syncQueue = '/sync';
  static const profile = '/profile';

  // Flujo V2 (Creación por Voz)
  static const voiceRecord = '/voice-record';
  static const processing = '/processing';
  static const reviewParameters = '/review-parameters';
  static const geoMatch = '/geo-match';
  static const budget = '/budget';
  static const exportPdf = '/export-pdf';

  // Legado / Adicionales
  static const createProject = '/projects/create';
  static const materials = '/materials';
  static const materialCatalog = '/material-catalog';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  debugLogDiagnostics: false,
  routes: [
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
    // Navegación Principal
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.projects,
      name: 'projects',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.syncQueue,
      name: 'syncQueue',
      builder: (context, state) => const SyncQueueScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: 'profile',
      builder: (context, state) => const _ProfilePlaceholder(),
    ),
    // Flujo V2
    GoRoute(
      path: AppRoutes.voiceRecord,
      name: 'voiceRecord',
      builder: (context, state) => const RecordingScreen(),
    ),
    GoRoute(
      path: AppRoutes.processing,
      name: 'processing',
      builder: (context, state) => const ProcessingScreen(),
    ),
    GoRoute(
      path: AppRoutes.reviewParameters,
      name: 'reviewParameters',
      builder: (context, state) => const ParametersReviewScreen(),
    ),
    GoRoute(
      path: AppRoutes.geoMatch,
      name: 'geoMatch',
      builder: (context, state) => const NearbyStoresScreen(),
    ),
    GoRoute(
      path: AppRoutes.budget,
      name: 'budget',
      builder: (context, state) => const BudgetResultScreen(),
    ),
    GoRoute(
      path: AppRoutes.exportPdf,
      name: 'exportPdf',
      builder: (context, state) => const ExportPdfScreen(),
    ),
    GoRoute(
      path: AppRoutes.materials,
      name: 'materials',
      builder: (context, state) => MaterialsPage(
        projectId: state.uri.queryParameters['projectId'] ?? 'unknown',
      ),
    ),
    GoRoute(
      path: AppRoutes.materialCatalog,
      name: 'materialCatalog',
      builder: (context, state) => MaterialCatalogPage(
        materialId: state.uri.queryParameters['materialId'],
      ),
    ),
  ],
);

/// Pantalla temporal para Perfil (por implementar con vista completa)
class _ProfilePlaceholder extends StatelessWidget {
  const _ProfilePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil de Usuario')),
      body: const Center(
        child: Text(
          'Perfil de Usuario — por implementar',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
