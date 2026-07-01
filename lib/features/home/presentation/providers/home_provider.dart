import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../auth/domain/usecases/auth_usecases.dart';
import '../../../project/domain/entities/proyecto_entity.dart';
import '../../../project/domain/usecases/proyecto_usecases.dart';

/// ViewModel de la pantalla de inicio (Dashboard). `@injectable` (factory).
///
/// Reúne los datos de la home: la lista de proyectos del usuario (desde el
/// back-end), el estado de conectividad **real** (ping) y la creación de
/// nuevos proyectos — que ahora vive aquí, no en la pantalla de grabación.
@injectable
class HomeViewModel extends ChangeNotifier {
  final ObtenerProyectosUseCase _obtenerProyectos;
  final CrearProyectoUseCase _crearProyecto;
  final ConnectivityService _connectivity;
  final GetPerfilUseCase _getPerfil;

  HomeViewModel(
    this._obtenerProyectos,
    this._crearProyecto,
    this._connectivity,
    this._getPerfil,
  ) {
    checkConnectivity();
    cargarProyectos();
    cargarNombre();
  }

  bool _loading = false;
  String? _error;
  List<ProyectoEntity> _proyectos = const [];
  bool? _online; // null = verificando
  String? _nombre;

  bool get loading => _loading;
  String? get error => _error;
  List<ProyectoEntity> get proyectos => _proyectos;

  /// Saludo dependiente de la hora local del dispositivo.
  String get saludo {
    final hora = DateTime.now().hour;
    if (hora >= 5 && hora < 12) return 'Buenos días';
    if (hora >= 12 && hora < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  /// Primer nombre del usuario (o `null` mientras carga el perfil).
  String? get nombreCorto {
    final n = _nombre?.trim();
    if (n == null || n.isEmpty) return null;
    return n.split(' ').first;
  }

  /// Trae el nombre del usuario desde `/me/perfil` para el saludo.
  Future<void> cargarNombre() async {
    try {
      final perfil = await _getPerfil();
      _nombre = perfil.nombre;
      notifyListeners();
    } catch (_) {
      // Si falla, el saludo se muestra sin nombre.
    }
  }

  /// `null` mientras verifica; luego `true`/`false` según conectividad real.
  bool? get online => _online;
  bool get isOffline => _online == false;

  /// Verifica conexión real (ping al back-end) y actualiza el estado.
  Future<void> checkConnectivity() async {
    _online = await _connectivity.isOnline();
    notifyListeners();
  }

  /// Carga los proyectos del usuario desde el back-end.
  Future<void> cargarProyectos() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _proyectos = await _obtenerProyectos();
    } catch (e) {
      _error = e is ApiException
          ? e.message
          : 'No se pudieron cargar los proyectos';
    } finally {
      _loading = false;
      notifyListeners();
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
    final proyecto =
        await _crearProyecto(nombre: nombre, direccion: direccion);
    _proyectos = [proyecto, ..._proyectos];
    notifyListeners();
    return proyecto;
  }
}
