import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/usecases/account_usecases.dart';
import '../widgets/payment_method.dart';

/// ViewModel de la pantalla "Método de Pago". `@injectable` (factory).
///
/// Carga la suscripción activa (real, desde `GET /me/subscriptions`) para el
/// resumen, y gestiona el método de pago seleccionado. El cobro en sí lo hace
/// el microservicio de Pagos (Conekta/PayPal), que hoy no está expuesto para
/// iniciar un checkout desde esta API — por eso [confirmar] es un placeholder.
@injectable
class PaymentMethodViewModel extends ChangeNotifier {
  final ObtenerSuscripcionesUseCase _obtenerSuscripciones;

  PaymentMethodViewModel(this._obtenerSuscripciones) {
    load();
  }

  bool _loading = true;
  String? _errorMessage;
  SubscriptionEntity? _subscription;
  PaymentMethod _selected = PaymentMethod.conekta;
  String? _confirmMessage;

  bool get loading => _loading;
  String? get errorMessage => _errorMessage;
  SubscriptionEntity? get subscription => _subscription;
  PaymentMethod get selected => _selected;
  String? get confirmMessage => _confirmMessage;

  /// Carga la suscripción activa (o la primera) para el resumen.
  Future<void> load() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final subs = await _obtenerSuscripciones();
      _subscription = subs.where((s) => s.activa).isNotEmpty
          ? subs.firstWhere((s) => s.activa)
          : (subs.isNotEmpty ? subs.first : null);
    } catch (e) {
      _errorMessage = e is ApiException
          ? e.message
          : 'No se pudo cargar la suscripción.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void seleccionar(PaymentMethod method) {
    if (_selected == method) return;
    _selected = method;
    _confirmMessage = null;
    notifyListeners();
  }

  /// Confirma el pago. TODO(back-end): cuando exista el endpoint de checkout
  /// (micro de Pagos / Conekta), aquí se iniciaría el cobro con [_selected].
  /// Por ahora informa que el checkout aún no está disponible.
  Future<void> confirmar() async {
    _confirmMessage =
        'Pago aún no disponible: falta el endpoint de checkout en el back-end.';
    notifyListeners();
  }
}
