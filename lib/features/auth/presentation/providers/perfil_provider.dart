import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/perfil_entity.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'perfil_state.dart';

// El enum de estado vive en su propio archivo (SRP); se re-exporta para que
// las pantallas que importan este provider sigan viendo `PerfilState`.
export 'perfil_state.dart';

/// ViewModel de la pantalla "Perfil". `@injectable` (factory): una instancia
/// por pantalla, con el [GetPerfilUseCase] ya inyectado. Carga el perfil
/// (`GET /api/v1/me/perfil`) al crearse.
@injectable
class PerfilViewModel extends ChangeNotifier {
  final GetPerfilUseCase _getPerfilUseCase;

  PerfilViewModel(this._getPerfilUseCase) {
    load();
  }

  PerfilState _state = PerfilState.loading;
  String? _errorMessage;
  PerfilEntity? _perfil;

  PerfilState get state => _state;
  String? get errorMessage => _errorMessage;
  PerfilEntity? get perfil => _perfil;
  bool get isLoading => _state == PerfilState.loading;

  /// Carga el perfil. Tras la primera vez viene de la caché del repositorio
  /// (sin pegar a la red). Usa [forceRefresh] para forzar una recarga real.
  Future<void> load({bool forceRefresh = false}) async {
    _state = PerfilState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _perfil = await _getPerfilUseCase(forceRefresh: forceRefresh);
      _state = PerfilState.success;
    } catch (e) {
      _state = PerfilState.error;
      _errorMessage =
          e is ApiException ? e.message : 'No se pudo cargar el perfil';
    }
    notifyListeners();
  }

  /// Fuerza una recarga desde el back-end (p. ej. pull-to-refresh).
  Future<void> refresh() => load(forceRefresh: true);
}
