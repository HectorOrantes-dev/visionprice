import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

/// Instancia global de GetIt
final getIt = GetIt.instance;

/// Configura todas las dependencias de la app
/// Llamar desde main() antes de runApp()
///
/// Uso:
/// ```dart
/// await configureDependencies();
/// ```
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<GetIt> configureDependencies() async => getIt.init();
