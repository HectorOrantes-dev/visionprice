import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

/// Instancia global de GetIt — accesible desde cualquier capa.
///
/// Uso en ViewModels:
/// ```dart
/// GetProjectsUseCase get _getProjects => getIt<GetProjectsUseCase>();
/// ```
final getIt = GetIt.instance;

/// Inicializa todas las dependencias de la app.
/// Debe llamarse en [main()] antes de [runApp()].
///
/// El archivo [injection.config.dart] es generado automáticamente por
/// `injectable_generator` al ejecutar:
/// ```bash
/// dart run build_runner build --delete-conflicting-outputs
/// ```
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<GetIt> configureDependencies() async => getIt.init();
