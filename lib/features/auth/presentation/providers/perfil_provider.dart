import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/perfil_entity.dart';
import '../../domain/usecases/auth_usecases.dart';

/// Estado de la pantalla de Perfil:
/// - [loading] → cargando el perfil desde el back-end.
/// - [success] → [perfil] disponible.
/// - [error] → ver [errorMessage].
enum PerfilState { loading, success, error }

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

  Future<void> load() async {
    _state = PerfilState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _perfil = await _getPerfilUseCase();
      _state = PerfilState.success;
    } catch (e) {
      _state = PerfilState.error;
      _errorMessage =
          e is ApiException ? e.message : 'No se pudo cargar el perfil';
    }
    notifyListeners();
  }
}
