import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/usecases/account_usecases.dart';

@injectable
class SubscriptionsViewModel extends ChangeNotifier {
  final ObtenerSuscripcionesUseCase _obtener;
  SubscriptionsViewModel(this._obtener) {
    load();
  }

  bool _loading = true;
  String? _errorMessage;
  List<SubscriptionEntity> _items = const [];

  bool get loading => _loading;
  String? get errorMessage => _errorMessage;
  List<SubscriptionEntity> get items => _items;

  Future<void> load() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _items = await _obtener();
    } catch (e) {
      _errorMessage = e is ApiException
          ? e.message
          : 'No se pudieron cargar las suscripciones.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
