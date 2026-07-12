import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/connectivity_service_provider.dart';
import '../../../../core/network/api_exception.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../project/domain/entities/proyecto_entity.dart';
import '../../../project/presentation/providers/project_providers.dart';

part 'home_provider.g.dart';

/// Estado inmutable de la pantalla de inicio (Dashboard).
class HomeState {
  final bool loading;
  final String? error;
  final List<ProyectoEntity> proyectos;
  final bool? online; // null = verificando
  final String? nombre;

  const HomeState({
    this.loading = false,
    this.error,
    this.proyectos = const [],
    this.online,
    this.nombre,
  });

  bool get isOffline => online == false;

  /// Saludo dependiente de la hora local del dispositivo.
  String get saludo {
    final hora = DateTime.now().hour;
    if (hora >= 5 && hora < 12) return 'Buenos días';
    if (hora >= 12 && hora < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  /// Primer nombre del usuario (o `null` mientras carga el perfil).
  String? get nombreCorto {
    final n = nombre?.trim();
    if (n == null || n.isEmpty) return null;
    return n.split(' ').first;
  }

  static const _keep = Object();

  HomeState copyWith({
    bool? loading,
    Object? error = _keep,
    List<ProyectoEntity>? proyectos,
    Object? online = _keep,
    Object? nombre = _keep,
  }) {
    return HomeState(
      loading: loading ?? this.loading,
      error: error == _keep ? this.error : error as String?,
      proyectos: proyectos ?? this.proyectos,
      online: online == _keep ? this.online : online as bool?,
      nombre: nombre == _keep ? this.nombre : nombre as String?,
    );
  }
}

/// Notifier de la pantalla de inicio (Riverpod moderno). Reúne proyectos,
/// conectividad real (ping) y creación de proyectos. Reemplaza al
/// `HomeViewModel` (ChangeNotifier).
@riverpod
class Home extends _$Home {
  @override
  HomeState build() {
    checkConnectivity();
    cargarProyectos();
    cargarNombre();
    return const HomeState();
  }

  /// Trae el nombre del usuario desde `/me/perfil` para el saludo.
  Future<void> cargarNombre() async {
    try {
      final perfil = await ref.read(getPerfilUseCaseProvider)();
      state = state.copyWith(nombre: perfil.nombre);
    } catch (_) {
      // Si falla, el saludo se muestra sin nombre.
    }
  }

  /// Verifica conexión real (ping al back-end) y actualiza el estado.
  Future<void> checkConnectivity() async {
    final online = await ref.read(connectivityServiceProvider).isOnline();
    state = state.copyWith(online: online);
  }

  /// Carga los proyectos del usuario desde el back-end.
  Future<void> cargarProyectos() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final proyectos = await ref.read(obtenerProyectosUseCaseProvider)();
      state = state.copyWith(proyectos: proyectos, loading: false);
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error:
            e is ApiException ? e.message : 'No se pudieron cargar los proyectos',
      );
    }
  }

  /// Refresca proyectos y conectividad (pull-to-refresh / reintento).
  Future<void> refresh() async {
    await checkConnectivity();
    await cargarProyectos();
  }

  /// Crea un proyecto nuevo y lo coloca al inicio de la lista.
  Future<ProyectoEntity> crearProyecto({
    required String nombre,
    String? direccion,
  }) async {
    final proyecto = await ref.read(crearProyectoUseCaseProvider)(
        nombre: nombre, direccion: direccion);
    state = state.copyWith(proyectos: [proyecto, ...state.proyectos]);
    return proyecto;
  }
}
